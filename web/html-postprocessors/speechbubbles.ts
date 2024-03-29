import * as path from 'path';
import * as fs from 'fs';
import type { StepInputs } from '@nzbr/parcel-transformer-postprocess-html';
import { toPosixPath } from '@nzbr/parcel-transformer-postprocess-html';

export const name = 'speechbubbles';

export function fn({ $, asset, options, config, logger }: StepInputs): void {
  const projectRoot = toPosixPath(options.projectRoot);
  const possibleCopperflameRoot = path.posix.join(projectRoot, 'node_modules', '@nzbr', 'copperflame');
  const root = fs.existsSync(possibleCopperflameRoot) ? possibleCopperflameRoot : projectRoot;
  const stickers = config.stickerPath ?? path.posix.join(root, 'assets', 'stickers');

  logger.info({message: `Using stickers from ${stickers}`});

  asset.invalidateOnFileCreate({
    glob: path.posix.join(stickers, '*'),
  });

  fs.readdirSync(stickers).forEach((character) => {
    const characterDir = path.posix.join(stickers, character);
    const cssClass = character.toLowerCase().trim().replaceAll(' ', '-');
    $(`.${cssClass}`).each((_, el) => {
      asset.invalidateOnFileCreate({
        glob: path.posix.join(characterDir, '*'),
      });

      const stickers = fs
        .readdirSync(characterDir)
        .filter((file) => !file.endsWith('.txt'))
        .map((file) => {
          const stickerName = file.split('.').slice(0, -1).join('.');

          return {
            stickerName,
            stickerFile: path.posix.join(characterDir, file),
            stickerAltFile: path.posix.join(characterDir, stickerName + '.txt'),
            stickerCssClass: stickerName.toLowerCase().trim().replaceAll(' ', '-'),
          };
        });

      const defaultSticker = stickers.find(
        (sticker) => sticker.stickerName === character,
      );
      const variants = stickers.filter((sticker) => sticker.stickerName !== character);

      const sticker = variants
        .concat(defaultSticker ? [defaultSticker] : [])
        .find((sticker) => $(el).hasClass(sticker.stickerCssClass));

      if (!sticker) {
        asset.invalidateOnFileCreate({
          glob: path.posix.join(characterDir, `${character}.*`),
        });
        throw new Error(`No sticker found for ${character} in ${asset.filePath}`);
      }

      if (!fs.existsSync(sticker.stickerAltFile)) {
        asset.invalidateOnFileCreate({
          glob: path.posix.join(characterDir, `${sticker.stickerName}.txt`),
        });
        throw new Error(
          `No alt text found for ${sticker.stickerName} in ${asset.filePath}`,
        );
      }

      asset.invalidateOnFileChange(sticker.stickerAltFile);
      const alt = fs.readFileSync(sticker.stickerAltFile, 'utf-8').trim();

      const url = asset.addURLDependency(
        `/${path.posix.relative(projectRoot, sticker.stickerFile)}`,
        {},
      );

      const img = `<img src="${url}" title=${character} alt="${alt}" width='128' />`;
      const text = `<div class="text">${$(el).html() ?? ''}</div>`;
      $(el).addClass('speechbubble');
      if ($(el).hasClass('inverted')) {
        $(el).removeClass('inverted');
        $(el).addClass('right-speechbubble');
          $(el).html(text + img);
      } else {
        $(el).addClass('left-speechbubble');
        $(el).html(img + text);
      }
      // width=128 is a fallback for the reader mode, because it ignores the CSS
    });
  });
}
