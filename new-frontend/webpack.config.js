var path = require('path');
var webpack = require('webpack');
var HtmlWebpackPlugin = require('html-webpack-plugin');
var yml = require('node-yaml');  
var config = yml.readSync(path.join(process.cwd(), 'config.yml'));
var NODE_ENV = process.env.NODE_ENV || 'development';

module.exports = {
  // This sets the module where webpack begins bundling our TypeScript. All code 
  // that runs & modules that we need to include must reduce back to this module. 
  entry: [
    path.join(process.cwd(), 'src/ts/index.ts')
  ],
  // This regex matches filenames for the TypeScript file extension, and if they match,
  // processes them using our TypeScript loader, based on our TypeScript config in
  // `tsconfig.json`.
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
    // This adds references to our bundle to the root HTML
    // document of the app (can also add other templated values
    // if we decide we need them later)
    new HtmlWebpackPlugin({
      template: 'src/index.html'
    }),
    // This exposes values defined in `config.yml` in the `process.env`
    // object in the bundle's runtime. So we can refer to `process.env.SOME_KEY`
    // and simply change its value in `config.yml` for different environments
    // if we want.
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
