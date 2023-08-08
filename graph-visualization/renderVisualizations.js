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
 * Creates a new page and takes a screenshot of all canvas tags that are contained within a div.
 * Note: Don't run this in parallel. See https://github.com/puppeteer/puppeteer/issues/1479
 * @param {Browser} browser
 * @param {string} htmlFilename
 */
const takeCanvasScreenshots = async (browser, htmlFilename) => {
  const page = await browser.newPage();
  await page.setViewport({ width: 1500, height: 1000, isMobile: false, isLandscape: true, hasTouch: false, deviceScaleFactor: 1 });

  console.log(`Loading ${htmlFilename}`);
  await page.goto(`file://${htmlFilename}`);

  // Login with Neo4j server password from the environment variable NEO4J_INITIAL_PASSWORD
  const loginButton = await page.waitForSelector("#neo4j-server-login");
  await page.type("#neo4j-server-password", process.env.NEO4J_INITIAL_PASSWORD);
  await loginButton.click();

  // Wait for the graph visualization to be rendered onto a HTML5 canvas
  console.log(`Waiting for visualizations to be finished`);
  await page.waitForSelector(".visualization-finished", { timeout: 90_000 });

  // Get all HTML canvas tag elements
  const canvasElements = await page.$$("canvas");
  if (canvasElements.length <= 0) {
    console.error(`No elements with CSS selector 'canvas' found in ${htmlFilename}`);
  }
  console.log(`Found ${canvasElements.length} visualizations`);

  // Take a png screenshot of every canvas element and save them with increasing indices
  const reportName = basename(htmlFilename, ".html");
  const directoryName = camelToKebabCase(reportName);
  if (!existsSync(directoryName)) {
    mkdirSync(directoryName);
  }
  await Promise.all(
    Array.from(canvasElements).map(async (canvasElement, index) => {
      console.log(`Exporting image ${reportName}-${index}.png...`);
      const dataUrl = await page.evaluate(async (canvasElement) => {
        return canvasElement.toDataURL();
      }, canvasElement);
      let data = Buffer.from(dataUrl.split(",").pop(), "base64");
      console.log(`Cropping image ${reportName}-${index}.png...`);
      data = await autoCropImageBuffer(data);
      writeFileSync(`./${directoryName}/${reportName}-${index}.png`, data);
      // console.log(`Taking screenshot ${reportName} of canvas ${index} in ${htmlFilename} of element...`);
      // await canvasElement.screenshot({ path: `./${directoryName}/${reportName}-${index}.png`, omitBackground: true });
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
  browser = await puppeteer.launch({ headless: "new" }); // { headless: false } for testing

  // Get all *.html files in this (script) directory and its subdirectories
  const htmlFiles = globSync(`${__dirname}/**/*.html`, { ignore: `${__dirname}/node_modules/**` });
  for (const htmlFile of htmlFiles) {
    await takeCanvasScreenshots(browser, htmlFile);
  }
  console.log(`Successfully rendered ${htmlFiles.length} html file(s)`);
})()
  .catch((err) => console.error(err))
  .finally(() => browser?.close());
