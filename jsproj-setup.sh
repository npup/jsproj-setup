# project structure
## directories
mkdir -p www test src/style src/images src/js/components
## js
echo 'alert("hello from `src/js/app.js`");
' > src/js/app.js
## css
echo 'html, html * { box-sizing: border-box; }
' > src/style/main.scss
## html
echo '<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, user-scalable=no">
  <title></title>
</head>

<body>
  <div id="app"></div>
</body>
</html>' > src/index.html

# npm
npm init -y
## adding scripts
npm i https://github.com/coleww/npm-add-script.git --save-dev
node node_modules/npm-add-script/cmd.js -f -k test -v "export NODE_ENV=dev; npm run build-dev && mocha -u bdd 'test/**/*.@(js)'"
node node_modules/npm-add-script/cmd.js -k build -v "export NODE_ENV=production; webpack"
node node_modules/npm-add-script/cmd.js -k build-dev -v "export NODE_ENV=dev; webpack"
node node_modules/npm-add-script/cmd.js -k start -v "export NODE_ENV=production; webpack-dev-server"
node node_modules/npm-add-script/cmd.js -k start-dev -v "export NODE_ENV=dev; webpack-dev-server"

# webpack
npm i webpack webpack-dev-server --save-dev
npm i extract-text-webpack-plugin html-webpack-plugin file-loader --save-dev
echo '/* eslint-env node */
/* eslint-disable no-console */

var PRODUCTION = "production" == process.env.NODE_ENV
  , PORT = 3000;

console.log("NODE_ENV production: %s", PRODUCTION);

var webpack = require("webpack")
  , ExtractTextPlugin = require("extract-text-webpack-plugin")
  , HtmlWebpackPlugin = require("html-webpack-plugin");

module.exports = {
  "devtool": PRODUCTION ? null : "sourcemap"
  , "entry": {
      "app": "./src/js/app.js"
    }
  , "output": {
      "path": __dirname+"/www/"
      , "publicPath": "http://localhost:"+PORT+"/"
      , "filename": "app.js"
    }
  , "module": {
    "loaders": [
      {
          "test": /\.s?css$/
          , "loader": ExtractTextPlugin.extract("style", "css!sass")
        }
      , {
          "test": /.jsx?$/
          , "loader": "babel-loader"
          , "exclude": /node_modules/
          , "query": {
            "presets": ["es2015", "react"]
          }
        }
      , {
          "test": /\.(png|jpe?g|gif)$/
          , "loader": "file?context=src&name=[path][name].[ext]"
        }
    ]
  }
  , "plugins": [
      new ExtractTextPlugin("main.css")
      , new HtmlWebpackPlugin({
          "template": "./src/index.html"
          , "filename": "index.html"
        })
      , new webpack.optimize.UglifyJsPlugin({
          "compressor": { "warnings": false }
          , "test": PRODUCTION ? /\.js/ : /^$/
        })
    ]
  , "devServer": {
      "inline": true
      , "port": PORT
    }
};' > webpack.config.js
echo '/* eslint-env node */
/* eslint-disable no-console */

var webpack = require("webpack")
  , WebpackDevServer = require("webpack-dev-server")
  , config = require("./webpack.config");

var host = "0.0.0.0"
  , PORT = 3001;

new WebpackDevServer(webpack(config), {
  "publicPath": config.output.publicPath
  , "historyApiFallback": true
}).listen(PORT, host, function handler(err) {
  if (err) { console.log(err); }
  else { console.log("Listening at " + host + ":" + PORT); }
});
' > browser-history-server.js

# css with sass
npm i css-loader style-loader sass-loader --save-dev

# babel
npm i babel-core babel-loader babel-preset-es2015 --save-dev
echo '{"plugins": [], "presets": ["es2015", "react"]}' > .babelrc

# react
npm i react react-dom react-router
npm i babel-preset-react --save-dev


# test
npm i mocha proclaim --save-dev
echo '
var assert = require("proclaim");

describe("module", function () {
  it("should have tests", function () {
    assert.isTrue(false, "implement tests");
  });
});
' > test/test.js

# libs
npm i superagent --save

# git
git init .
echo 'node_modules
www' > .gitignore
echo '!.gitignore' > www/.gitignore

# guard
echo "echo '\n  ### Script $0 already executed. Only re-execute of you know what you are doing (so.. no).\n'; exit 1;\n" > "$0.tmp"
cat $0 >> "$0.tmp"
mv "$0.tmp" $0
