const webpack = require('webpack');
const path = require('path');
const htmlWepack = require('html-webpack-plugin');

const entry = path.join(__dirname, 'src', 'index.js');
const buildDir = path.join(__dirname, 'build');
const templateFile = path.join(__dirname, 'src', 'index.html');

module.exports = {
    entry,
    output: {
        filename: 'bundle.js',
        path: buildDir
    },
    module: {
        rules: [
            {
                test: /\.js$/,
                exclude: /node_modules/
            },
            {
                test: /\.styl$/,
                exclude: /node_modules/,
                use: ['style-loader', 'css-loader', 'stylus-loader']
            },
            {
                test: /\.elm$/,
                exclude: [/node_modules/, /elm-stuff/],
                use: {
                    loader: 'elm-webpack-loader',
                    options: {}
                }
            }
        ]
    },
    plugins: [
        new htmlWepack({
            template: templateFile,
            // inject: 'head'
        })
    ],
    devServer: {
        inline: true,
        port: 8084
    }
};
