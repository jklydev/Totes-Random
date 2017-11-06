var path = require('path');
var webpack = require('webpack');
var HtmlWebpackPlugin = require('html-webpack-plugin');
var yml = require('node-yaml');  
var config = yml.readSync(path.join(process.cwd(), 'config.yml'));
var NODE_ENV = process.env.NODE_ENV || 'development';

module.exports = {
  entry: [
    path.join(process.cwd(), 'src/ts/index.ts')
  ],
  module: {
    rules:[
      {
        test: /\.ts$/,
        exclude: [/node_modules/],
        loader: 'awesome-typescript-loader',
        options: { configFileName: './tsconfig.json' }
      }
    ] 
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: 'src/index.html'
    }),
    new webpack.DefinePlugin(
      Object.keys(config[NODE_ENV])
      .reduce(
        function(acc, key) {
          acc[key] = JSON.stringify(config[NODE_ENV][key]);
          return acc;
        },
        {}
      )
    )
  ],
  devServer: {
    port: process.env.PORT || 8000
  },
  output: {
    filename: 'bundle.js',
    path: path.join(process.cwd(), 'dist'),
  },
  stats: 'normal'
}
