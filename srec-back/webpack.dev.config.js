const path = require('path');
// const Dotenv = require('dotenv-webpack');


module.exports = {
  entry: './src/app.ts',
  mode: 'development',
  target: 'node',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'srec-server.js'
  },
  resolve: {
    extensions: ['.ts', '.js'],
  },
  plugins: [
    // new Dotenv()
  ],
  module: {
    rules: [
      {
        test: /\.ts$/,
        use: [
          'ts-loader',
        ]
      }
    ]
  }
}