const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// Resolve iosevkaDir
const iosevkaDir = path.dirname(require.resolve("@iosevka/monorepo/package.json"));
console.log(`Resolved Iosevka directory: ${iosevkaDir}`);

// Copy build-configuration.toml
const sourceConfig = path.resolve(__dirname, 'build-configuration.toml');
const destConfig = path.join(iosevkaDir, 'private-build-plans.toml');
console.log(`Copying config from ${sourceConfig} to ${destConfig}`);
fs.copyFileSync(sourceConfig, destConfig);

// Installing dependencies
console.log('Installing dependencies...');
execSync(`npm install`, {
  cwd: iosevkaDir,
  stdio: 'inherit'
});

console.log('Installing ttfautohint...');
execSync(`npm install ttfautohint`, {
  cwd: iosevkaDir,
  stdio: 'inherit'
});

// Run build
console.log('Starting build...');
execSync(`npm run build -- contents::CopperflameMono`, {
  cwd: iosevkaDir,
  stdio: 'inherit'
});

// Copy artifacts
const distDir = path.resolve(__dirname, 'dist');
const targetDistDir = path.join(distDir, 'CopperflameMono');
const sourceDistDir = path.join(iosevkaDir, 'dist', 'CopperflameMono');

if (!fs.existsSync(distDir)) {
  fs.mkdirSync(distDir);
}

// Remove existing target directory if it exists to ensure clean copy
if (fs.existsSync(targetDistDir)) {
  fs.rmSync(targetDistDir, { recursive: true, force: true });
}

console.log(`Copying artifacts from ${sourceDistDir} to ${targetDistDir}`);

// Helper to copy directory recursively
function copyDir(src, dest) {
  fs.mkdirSync(dest, { recursive: true });
  const entries = fs.readdirSync(src, { withFileTypes: true });

  for (const entry of entries) {
    const srcPath = path.join(src, entry.name);
    const destPath = path.join(dest, entry.name);

    if (entry.isDirectory()) {
      copyDir(srcPath, destPath);
    } else {
      fs.copyFileSync(srcPath, destPath);
    }
  }
}

if (fs.existsSync(sourceDistDir)) {
  copyDir(sourceDistDir, targetDistDir);
  console.log('Build and copy completed successfully.');
} else {
  console.error(`Build output not found at ${sourceDistDir}`);
  process.exit(1);
}
