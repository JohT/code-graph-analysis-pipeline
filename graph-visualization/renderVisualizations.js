import puppeteer, { Browser } from "puppeteer";
import { basename, dirname } from "path";
import { globSync } from "glob";
import { existsSync, mkdirSync } from "fs";

// __filename and __dirname don't exist when using es6 modules.
// So they will be derived from the nodejs command line argument index 1 (script filename).
const indexOfScriptFilePathArgument = 1;
const __filename = process.argv[indexOfScriptFilePathArgument];
const __dirname = dirname(__filename);

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
  await page.setViewport({ width: 1600, height: 1000, isMobile: false, isLandscape: true, hasTouch: false, deviceScaleFactor: 1 });

  console.log(`Loading ${htmlFilename}`);
  await page.goto(`file://${htmlFilename}`);
  
  // Login with Neo4j server password from the environment variable NEO4J_INITIAL_PASSWORD
  const loginButton = await page.waitForSelector('#neo4j-server-login');
  await page.type('#neo4j-server-password', process.env.NEO4J_INITIAL_PASSWORD);
  await loginButton.click();

  // Wait for the graph visualization to be rendered onto a HTML5 canvas
  await page.waitForSelector("div canvas");

  // Get all HTML canvas tag elements
  const canvasElements = await page.$$("div canvas");
  if (canvasElements.length <= 0) {
    console.error(`No elements with CSS selector 'div canvas' found in ${htmlFilename}`);
  }

  // Take a png screenshot of every canvas element and save them with increasing indices
  const reportName = basename(htmlFilename, ".html");
  const directoryName = camelToKebabCase(reportName);
  if (!existsSync(directoryName)) {
    mkdirSync(directoryName);
  }
  let index = 1;
  await Promise.all(
    canvasElements.map(async (canvasElement) => {
      console.log(`Taking screenshot ${reportName} of canvas ${index} in ${htmlFilename} ...`);
      await canvasElement.screenshot({ path: `./${directoryName}/${reportName}-${index}.png`, omitBackground: true });
      index++;
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
