import { StepInputs } from "@nzbr/parcel-transformer-postprocess-html";

export const name = "revealjs";

export function fn({ $, asset }: StepInputs) {
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

  $('[data-src]').each((i, el) => {
    const src = $(el).attr('data-src');
    if (src) {
      $(el).attr('data-src', asset.addURLDependency(src, {
        specifier: src,
        specifierType: "url",
      }));
    }
  });
}
