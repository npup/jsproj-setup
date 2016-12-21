# project structure
## directories
mkdir -p www test src/style src/images src/js/components
## js
echo 'alert("hello from `src/js/index.js`");
' > src/js/index.js
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

echo 'var express = require("express")
  , path = require("path")
  , app = express()
  , DEV_PORT = 3001
  , PRODUCTION = "production"==process.env.NODE_ENV
  , PORT = (PRODUCTION ? process.env.PORT : DEV_PORT) || DEV_PORT
  , root = path.join(__dirname, "../www")
  , indexFile = path.join(root, "index.html");

app.use(express.static(root));

app.get("*", function (req, res) {
  res.sendFile(indexFile);
});

app.listen(PORT, function () {
  console.log("-- express server running at port %s", PORT);
});
' > src/server.js

# npm
npm init -y
## adding scripts
npm i https://github.com/coleww/npm-add-script.git --save-dev
node node_modules/npm-add-script/cmd.js -k env -v "env"
node node_modules/npm-add-script/cmd.js -k clean -v "rm -rf www/*"
node node_modules/npm-add-script/cmd.js -f -k "test" -v "mocha --compilers js:babel-core/register -u bdd 'test/**/*.@(js)'"
node node_modules/npm-add-script/cmd.js -k build -v "export NODE_ENV=production; webpack -p"
node node_modules/npm-add-script/cmd.js -k start -v "export NODE_ENV=production; npm run build && node src/server.js"
node node_modules/npm-add-script/cmd.js -k dev -v "export NODE_ENV=dev; webpack-dev-server --content-base www/"

#express js
npm i express --save

# webpack
npm i webpack webpack-dev-server --save-dev
npm i extract-text-webpack-plugin html-webpack-plugin copy-webpack-plugin file-loader --save
echo '/* eslint-env node */
/* eslint-disable no-console */

var PRODUCTION = "production" == process.env.NODE_ENV
  , PORT = 3000;

console.log("NODE_ENV production: %s", PRODUCTION);

var webpack = require("webpack")
  , ExtractTextPlugin = require("extract-text-webpack-plugin")
  , HtmlWebpackPlugin = require("html-webpack-plugin")
  , CopyWebpackPlugin = require("copy-webpack-plugin");

// plugins
var cssExtractor = new ExtractTextPlugin("main.css")
  , htmlTemplate = new HtmlWebpackPlugin({
      "template": "./src/index.html"
      , "filename": "index.html"
    })
  , fileCopy = new CopyWebpackPlugin([
      { "from": "./src/images/apple-touch-icon.png" }
    ]);

module.exports = {
  "devtool": PRODUCTION ? null : "sourcemap"
  , "entry": {
      "app": "./src/js/index.js"
    }
  , "output": {
      "path": __dirname+"/www/"
      , "publicPath": PRODUCTION ? "/" : "http://localhost:"+PORT+"/"
      , "filename": "app.js"
    }
  , "module": {
    "loaders": [
      {
          "test": /\.s?css$/
          , "loader": cssExtractor.extract("style", "css!sass")
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
      cssExtractor
      , htmlTemplate
      , new webpack.optimize.UglifyJsPlugin({
          "compressor": { "warnings": false }
          , "test": PRODUCTION ? /\.js/ : /^$/
        })
      , new webpack.DefinePlugin({
            "process.env": {
              "NODE_ENV": JSON.stringify(process.env.NODE_ENV)
            }
        })
      , fileCopy
    ]
  , "devServer": {
      "inline": true
      , "port": PORT
      , "historyApiFallback": { "index": "index.html" }
    }
};' > webpack.config.js

# css with sass
npm i node-sass css-loader style-loader sass-loader --save-dev

# babel
npm i babel-core babel-loader babel-preset-es2015 --save-dev
echo '{"plugins": [], "presets": ["es2015", "react"]}' > .babelrc

# react
npm i react react-dom react-router --save
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
echo "echo '\n  ### Script $0 already executed. Only re-execute if you know what you are doing (so.. no).\n'; exit 1;\n" > "$0.tmp"
cat $0 >> "$0.tmp"
mv "$0.tmp" $0


echo '\nCommands:
---------------------
npm test         # run tests
npm run dev      # start hotloading development environment
npm run env      # show env variables
npm run clean    # clean dist directory (www)
npm run build    # run build for production
npm start        # start production server
'
