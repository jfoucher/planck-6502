const webpack = require("webpack");
const path = require("path");

module.exports = {
  mode: "development",
  context: path.resolve(__dirname, "."),
  entry: "./index.js",
  output: {
    path: path.resolve(__dirname, "dist"),
    filename: "bundle.js",
    library: 'PlanckLib',
    globalObject: 'this' // https://webpack.js.org/configuration/output/
  },
  resolve: {
    fallback: {
        crypto: false,
        fs: false,
        path: false
    }
},
  module: {
    rules: [
      {
        test: /planckemu\.js$/,
        loader: "exports-loader",
        options: {
            exports: 'emu'
        }
      },
      {
        test: /planckemu\.wasm$/,
        type: "javascript/auto",
        loader: "file-loader",
        options: {
          publicPath: "dist/"
        }
      }
    ]
  },
};
