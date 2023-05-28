const { execSync } = require("child_process");
const join = require("path").join;
const fs = require("fs");

process.chdir(__dirname);

function build(template, destination) {
  console.log(`Generating ${destination}`);
  const output = execSync(
    `npx base16-builder -s copperflame.yaml -t ${template}`
  );
  fs.writeFileSync(destination, output);
}

["dark", "light"].forEach((mode) => {
  build(
    join("skylighting", `${mode}.theme.ejs`),
    join("..", "pandoc", `copperflame-${mode}.theme`)
  );
  build(
    join("latex", `${mode}.tex.ejs`),
    join("..", "pandoc", "partials", `copperflame-colors-${mode}.tex`)
  );
});

build(join("logo", "icon.svg.ejs"), join("..", "assets", "icon.svg"));
build(join("logo", "logo.svg.ejs"), join("..", "assets", "logo.svg"));
build(join("logo", "logo-pro.svg.ejs"), join("..", "assets", "logo-pro.svg"));

console.log();
console.log(`Converting svg to png`);
try {
  const logo = join("..", "assets", "logo");
  console.log(`Converting ${logo}.svg to ${logo}.png`);
  execSync(
    `inkscape --export-type=png --export-filename=${logo}.png -w 508 -h 72 ${logo}.svg`
  );
  const logoPro = join("..", "assets", "logo-pro");
  console.log(`Converting ${logoPro}.svg to ${logoPro}.png`);
  execSync(
    `inkscape --export-type=png --export-filename=${logoPro}.png -w 568 -h 72 ${logoPro}.svg`
  );
} catch (_) {
  console.log(_);
  console.warn("Inkscape failed or is not installed");
}
