# project structure
## directories
mkdir -p www test src/assets src/style src/js/components
## js
echo 'import "../style/main.scss";
import React from "react";
import ReactDOM from "react-dom";

const thisFileName = "src/js/index.js";
const App = props => <h1>Hello from { props.file }</h1>;

ReactDOM.render(<App file={ thisFileName } />, document.getElementById("app"));
' > src/js/index.js
## css
echo 'html, html * { box-sizing: border-box; }
' > src/style/main.scss
## html
echo '<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
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
node node_modules/npm-add-script/cmd.js -k dev -v "export NODE_ENV=dev; webpack-dev-server"

#express js
npm i express --save

# webpack
npm i webpack@2 webpack-dev-server@2 --save
npm i html-webpack-plugin copy-webpack-plugin file-loader --save
echo '/* eslint-env node */
/* eslint-disable no-console */

const path = require("path")
  , webpack = require("webpack");

const HtmlWebpackPlugin = require("html-webpack-plugin")
  , CopyWebpackPlugin = require("copy-webpack-plugin");


const PRODUCTION = "production" == process.env.NODE_ENV
  , DEV_SERVER_PORT = 3000;

console.log("NODE_ENV production: %s", PRODUCTION);

module.exports = {

  "devtool": PRODUCTION ? false : "sourcemap"

  , "context": path.resolve(__dirname, "./src")

  , "entry": {
      "app": "./js/index.js"
    }

  , "output": {
      "path": path.resolve(__dirname, "./www")
      , "filename": "[name].js"
    }

  , "module": {
      "rules": [
        {
          "test": /\.scss$/
          , "use": [
              "style-loader"
              , "css-loader"
              , "sass-loader"
            ]
          , "exclude": /node_modules/
        }
        ,  {
          "test": /\.jsx?$/
          , "loader": "babel-loader"
          , "query": {
              "presets": ["es2015", "react"]
            }
          , "exclude": /node_modules/
        }
      ]
    }
  , "plugins": [
       new HtmlWebpackPlugin({ "template": "./index.html" })
       , new webpack.DefinePlugin({
            "process.env": {
              "NODE_ENV": JSON.stringify(process.env.NODE_ENV)
            }
        })
      , new CopyWebpackPlugin([
          { "from": "./assets", "to": "./assets" }
        ])
    ]

  , "devServer": {
      "port": DEV_SERVER_PORT
      , "contentBase": path.resolve(__dirname, "./www")
      , "historyApiFallback": { "index": "index.html" }
      , "inline": true
    }

};' > webpack.config.js

# css with sass
npm i node-sass css-loader style-loader sass-loader --save-dev

# babel
npm i babel-core babel-loader babel-preset-es2015 --save-dev
echo '{ "plugins": [], "presets": ["es2015"] }' > .babelrc

# react
npm i react react-dom react-router --save
npm i babel-preset-react --save-dev


# test
npm i mocha proclaim --save-dev
echo '
import assert from "proclaim";

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
