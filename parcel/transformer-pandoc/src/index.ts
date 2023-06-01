import { Transformer } from '@parcel/plugin';
import { spawnSync } from 'node:child_process';
import type { Async } from '@parcel/types';

interface PandocConfig {
  template?: string;
  format?: string;
  assetType?: string;
  options?: string[];
}

const configPaths = ['.pandocrc', '.pandocrc.js', 'pandoc.config.js'];

export default new Transformer<PandocConfig>({
  async loadConfig({ config }) {
    const { contents: contentsAsync, filePath } = (await config.getConfig<
      Async<PandocConfig>
    >(configPaths))!;
    const contents = await contentsAsync; // await if it's a promise

    if (!contents) {
      configPaths.forEach((it) =>
        config.invalidateOnFileCreate({ fileName: it, aboveFilePath: config.searchPath }),
      );
      return {};
    }

    if (filePath) {
      if (filePath.endsWith('.js')) {
        config.invalidateOnStartup();
      }
      config.invalidateOnFileChange(filePath);
    }

    return contents;
  },
  async transform({ asset, config }) {
    if (config.template) {
      asset.invalidateOnFileChange(config.template);
    }

    const result = spawnSync(
      'pandoc',
      ['-t', config.format ?? 'html'].concat(
        config.template ? [`--template=${config.template}`] : [],
      ).concat(config.options ?? []),
      {
        input: await asset.getCode(),
      },
    );
    asset.setCode(result.stdout.toString());

    asset.type = config.assetType ?? 'html';

    return [asset];
  },
});
