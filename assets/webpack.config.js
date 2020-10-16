const path = require('path')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const TerserPlugin = require('terser-webpack-plugin')
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin')

module.exports = (env, options) => {
  const devMode = options.mode == 'development'

  return {
    // stats: 'minimal',
    optimization: {
      minimizer: [
        new TerserPlugin({ sourceMap: devMode }),
        new OptimizeCSSAssetsPlugin({})
      ]
    },
    entry: './js/app.js',
    output: {
      filename: 'app.js',
      path: path.resolve(__dirname, '../priv/static/js'),
      publicPath: '/js/'
    },
    devtool: devMode ? 'source-map' : undefined,
    module: {
      rules: [
        {
          test: /\.js$/,
          exclude: /node_modules/,
          use: {
            loader: 'babel-loader'
          }
        },
        {
          test: /\.s[ac]ss$/i,
          use: [
            // extract CSS into separate file
            MiniCssExtractPlugin.loader,
            // translates CSS into CommonJS
            'css-loader',
            // compiles Sass to CSS
            {
              loader: 'sass-loader',
              options: {
                sourceMap: devMode,
                sassOptions: {
                  includePaths: [
                    'node_modules/bulma/sass/',
                  ]
                },

              }
            }
          ]
        },
        {
          test: /\.(woff2)$/i,
          use: {
            // handles icons font
            loader: 'url-loader',
            options: { limit: 8192 } // 8 Kb
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
