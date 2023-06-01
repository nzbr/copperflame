import { Transformer } from '@parcel/plugin';
import * as cheerio from 'cheerio/lib/slim'; // use slim because parse5 doesn't like the input

export default new Transformer<{}>({
  async transform({ asset, options }) {
    let code = await asset.getCode();

    // remove BOM if present
    if (code.charCodeAt(0) === 0xfeff) {
      code = code.slice(1);
    }

    const $ = cheerio.load(code);

    $('.reveal section').each((i, el) => {
      // select h1 contained in el
      const h1 = $(el).children('h1').first();
      const sidebar = $(el).children('.sidebar');
      const content = $(el).children().not('h1').not('.sidebar');

      $(el).html(`
        ${h1}
        <div class="section-content${h1.length == 0 ? ' noheader' : ''}">
          <div class="main-content">
            ${content}
          </div>
          ${sidebar}
        </div>
      `);
    });

    asset.setCode($.html());

    return [asset];
  },
});
