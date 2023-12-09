import puppeteer, { Browser } from "puppeteer";
import { basename, dirname } from "path";
import { globSync } from "glob";
import { existsSync, mkdirSync, writeFileSync } from "fs";
import jimp from "jimp";

// __filename and __dirname don't exist when using es6 modules.
// So they will be derived from the nodejs command line argument index 1 (script filename).
const indexOfScriptFilePathArgument = 1;
const __filename = process.argv[indexOfScriptFilePathArgument];
const __dirname = dirname(__filename);
console.log(`renderVisualizations.js: dirname=${__dirname}`);

/**
 * Crops the image in the buffer so that there is no empty frame around it.
 * @param {Buffer} buffer
 * @returns Buffer
 */
const autoCropImageBuffer = async (buffer) => {
  return await jimp
    .read(buffer)
    .then((image) => image.autocrop())
    .then((image) => image.getBufferAsync(jimp.MIME_PNG));
};

/**
 * Converts a camel case string into an kebab case string separated with dashes.
 * Reference: {@link https://stackoverflow.com/questions/54246477/how-to-convert-camelcase-to-snake-case}
 * @param {string} str
 * @returns string
 */
const camelToKebabCase = (str) => str.replace(/[A-Z]/g, (letter) => `-${letter.toLowerCase()}`);

/**
 * Take a screenshot after an error happened.
 *
 * @param {string} htmlFilename
 * @param {string} reason
 */
const makeScreenshotOfError = async (page, htmlFilename, reason) => {
  const reportName = basename(htmlFilename, ".html");
  const directoryName = camelToKebabCase(reportName);
  console.log(`Taking an error screenshot of report ${reportName}. Reason: ${reason}`);
  await page.screenshot({ path: `./${directoryName}/error-${reportName}-${reason}.png`, omitBackground: false });
};

/**
 * Handle a catched error by taking a screenshot.
 *
 * @param {string} htmlFilename
 * @param {string} reason
 * @return
 */
const handleErrorWithScreenshot = (page, htmlFilename, reason) => async (error) => {
  await makeScreenshotOfError(page, htmlFilename, reason);
  throw new Error(error);
};
/**
 * Creates a new page and takes a screenshot of all canvas tags that are contained within a div.
 * Note: Don't run this in parallel. See https://github.com/puppeteer/puppeteer/issues/1479
 * @param {Browser} browser
 * @param {string} htmlFilename
 */
const takeCanvasScreenshots = async (browser, htmlFilename) => {
  const reportName = basename(htmlFilename, ".html");
  const directoryName = camelToKebabCase(reportName);
  if (!existsSync(directoryName)) {
    mkdirSync(directoryName);
  }

  const page = await browser.newPage();
  await page.setViewport({ width: 1500, height: 1000, isMobile: false, isLandscape: true, hasTouch: false, deviceScaleFactor: 1 });

  console.log(`Loading ${htmlFilename}`);
  await page.goto(`file://${htmlFilename}`);

  if (!process.env.NEO4J_INITIAL_PASSWORD) {
    throw new Error("Missing environment variable NEO4J_INITIAL_PASSWORD");
  }
  // Login with Neo4j server password from the environment variable NEO4J_INITIAL_PASSWORD
  const loginButton = await page.waitForSelector("#neo4j-server-login");
  await page.type("#neo4j-server-password", process.env.NEO4J_INITIAL_PASSWORD);
  await loginButton.click();

  // Wait for the graph visualization to be rendered onto a HTML5 canvas
  console.log(`Waiting for visualizations to be finished`);
  await page
    .waitForSelector(".visualization-finished", { timeout: 90_000 })
    .catch(handleErrorWithScreenshot(page, htmlFilename, "visualization-did-not-finish"));

  // Get all HTML canvas tag elements
  const canvasElements = await page.$$("canvas");
  if (canvasElements.length <= 0) {
    await makeScreenshotOfError(page, htmlFilename, "no-canvas-found");
  }
  console.log(`Found ${canvasElements.length} visualizations`);

  // Take a png screenshot of every canvas element and save them with increasing indices
  await Promise.all(
    Array.from(canvasElements).map(async (canvasElement, index) => {
      console.log(`Exporting image ${reportName}-${index}.png...`);
      const dataUrl = await page.evaluate(async (canvasElement) => {
        return canvasElement.toDataURL();
      }, canvasElement);
      let data = Buffer.from(dataUrl.split(",").pop(), "base64");
      console.log(`Cropping image ${reportName}-${index}.png...`);
      data = await autoCropImageBuffer(data).catch(handleErrorWithScreenshot(page, htmlFilename, `failed-to-crop-image-${index}`));
      writeFileSync(`./${directoryName}/${reportName}-${index}.png`, data);
    })
  );
};

let browser;
/**
 * Main code that launches puppeteer in a headless browser,
 * iterates over all HTML files in this directory and its subdirectories
 * and takes a screenshot of the canvas elements using {@link takeCanvasScreenshots}.
 */
(async () => {
  console.log("renderVisualizations.js: Starting headless browser...");
  browser = await puppeteer.launch({ headless: "new" }); // { headless: false } for testing

  // Get all *.html files in this (script) directory and its subdirectories
  // The separate filter is needed to ignore the "node_modules" directory.
  // Glob's build-in filter doesn't seem to work on Windows.
  const htmlFiles = globSync(`${__dirname}/**/*.html`, { absolute: true }).filter((file) => !file.includes("node_modules"));
  for (const htmlFile of htmlFiles) {
    await takeCanvasScreenshots(browser, htmlFile);
  }
  console.log(`renderVisualizations.js: Successfully rendered ${htmlFiles.length} html file(s)`);
})()
  .catch((err) => console.error(err))
  .finally(() => browser?.close());
