import {Transformer} from '@parcel/plugin';
import * as cheerio from 'cheerio/lib/slim'; // use slim because parse5 doesn't like the input
import path = require('node:path');
import fs = require('node:fs');

export default new Transformer<{}>({
  async transform({asset, options}) {
    let code = await asset.getCode();

    // remove BOM if present
    if (code.charCodeAt(0) === 0xfeff) {
      code = code.slice(1);
    }

    const $ = cheerio.load(code);

    $('include').each((i, el) => {
      const src = $(el).attr('src');
      const pre = $(el).attr('pre');

      const attrs = $(el).attr() ?? {};

      const abssrc = src!.replace(
        './',
        `${path.dirname(asset.filePath)}${path.sep}`,
      );

      asset.invalidateOnFileChange(abssrc);

      let content = fs.readFileSync(abssrc, 'utf8');

      const replacement = $(
        (pre && pre !== 'false')
          ? `<pre>${content.replace('\n', '<br/>')}</pre>`
          : `<div>${content}</div>`
      );
      $(replacement).attr(attrs);

      $(el).replaceWith(replacement);

    });

    asset.setCode($.html());

    return [asset];
  },
});
