const path = require('path')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const { ESBuildMinifyPlugin } = require('esbuild-loader')
const CopyWebpackPlugin = require('copy-webpack-plugin')

module.exports = (env, options) => {
  const devMode = options.mode !== 'production';

  return {
    optimization: {
      minimizer: [
        new ESBuildMinifyPlugin({ target: 'es2015', css: true })
      ]
    },
    entry: {
      'app': './js/app.js'
    },
    output: {
      filename: '[name].js',
      path: path.resolve(__dirname, '../priv/static/js'),
      publicPath: '/js/'
    },
    devtool: devMode ? 'eval-cheap-module-source-map' : undefined,
    module: {
      rules: [
        {
          test: /\.js$/,
          exclude: /node_modules/,
          use: {
            loader: 'esbuild-loader',
            options: {
              // loader: 'jsx',  // Remove this if you're not using JSX
              target: 'es2015'  // Syntax to compile to (see options below for possible values)
            }
          }
        },
        {
          test: /\.css$/,
          use: [
            MiniCssExtractPlugin.loader,  // extract CSS into separate file
            'css-loader',                 // translates CSS into CommonJS
            'postcss-loader'              // CSS postprocessing
          ]
        },
        {
          test: /\.(gif|svg|woff2)$/,
          use: {
            loader: 'url-loader',
            options: { limit: 8192 }      // use file-loader if file size < 8 Kb
          }
        }
      ]
    },
    plugins: [
      new MiniCssExtractPlugin({ filename: '../css/app.css' }),
      new CopyWebpackPlugin({ patterns: [{ from: 'static/', to: '../' }]})
    ]
  }
};
