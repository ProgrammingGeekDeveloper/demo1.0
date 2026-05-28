const webpack = require("webpack");

module.exports = function override(config) {
  // Remove fork-ts-checker (good for crash reduction)
  config.plugins = (config.plugins || []).filter(
    (plugin) => plugin.constructor?.name !== "ForkTsCheckerWebpackPlugin"
  );

  const rule = config.module.rules.find((r) => Array.isArray(r.oneOf));

  if (rule) {
    rule.oneOf.splice(rule.oneOf.length - 1, 0, {
      test: /\.po$/,
      use: [{ loader: "@lingui/loader" }],
    });
  }

  config.resolve.fallback = {
    os: false,
    http: false,
    https: false,
    stream: false,
    crypto: false,
  };

  config.plugins.push(
    new webpack.ProvidePlugin({
      Buffer: ["buffer", "Buffer"],
    })
  );

  return config;
};