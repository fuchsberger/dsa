const path = require('path')
// const glob = require('glob')
const CopyPlugin = require('copy-webpack-plugin')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const TerserPlugin = require('terser-webpack-plugin')
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin')

module.exports = (env, options) => ({

  devtool: options.mode == 'development' ? 'source-map' : undefined,

  // stats: 'minimal',

  entry: './js/app.js',

  // stats: 'minimal',

  optimization: {
    minimizer: [
      new TerserPlugin({ test: /\.js(\?.*)?$/i }),
      new OptimizeCSSAssetsPlugin({})
    ]
  },

  output: {
    filename: 'app.js',
    path: path.resolve(__dirname, '../priv/static/js'),
    publicPath: '/js/'
  },

  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: { loader: 'babel-loader' }
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
        test: /\.(svg|png)$/,
        use: {
          loader: 'url-loader',
          options: { limit: 8192 } // 8 Kb
        }
      }
    ]
  },
  plugins: [
    new MiniCssExtractPlugin({ filename: '../css/app.css' }),
    new CopyPlugin({ patterns: [{ from: 'static/', to: '../' }]})
  ]
});
