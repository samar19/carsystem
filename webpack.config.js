const path = require('path')
const CopyWebpackPlugin = require('copy-webpack-plugin')

module.exports = {
  entry: './app/scripts/index.js',
  mode: 'production',
  output: {
    path: path.resolve(__dirname, 'build'),
    filename: 'app.js'
  },
  plugins: [
    // Copy our app's index.html to the build folder.
    new CopyWebpackPlugin([
      { from: './app/index.html', to: 'index.html' },
{ from: './app/index.html', to: 'index.html' },
{ from: './app/blank.html', to: 'blank.html' },
{ from: './app/BuyCar.html', to: 'BuyCar.html' },
{ from: './app/checkout.html', to: 'checkout.html' },
{ from: './app/product-page.html', to: 'product-page.html' },
{ from: './app/products.html', to: 'products.html' },
{ from: './app/SellCar.html', to: 'SellCar.html' },
{ from: './app/ShowCars.html', to: 'ShowCars.html' },
      { from: './app/css', to: 'css' },
      { from: './app/img', to: 'img' },
{ from: './app/fonts', to: 'fonts' },


      { from: './app/js', to: 'js' }


      
    ])
  ],
  devtool: 'source-map',
  module: {
    rules: [
      { test: /\.s?css$/, use: [ 'style-loader', 'css-loader', 'sass-loader' ] },
      {
        test: /\.js$/,
        exclude: /(node_modules|bower_components)/,
        loader: 'babel-loader',
        query: {
          presets: ['env'],
          plugins: ['transform-react-jsx', 'transform-object-rest-spread', 'transform-runtime']
        }
      },
{ test: /\.(png|woff|woff2|eot|ttf|svg)$/, loader: 'url-loader?limit=100000' }

    ]
  }
}

