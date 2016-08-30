# jsproj-setup

shell script for setting up a js project with webpack, babel, sass, react, mocha

## Usage:

	$ git clone git@github.com:npup/jsproj-setup.git
	$ mkdir -p myproj && cp jsproj-setup/jsproj-setup.sh myproj/
	$ cd myproj
	$ subl .
	$ sh jsproj-setup.sh
	$ npm run test
	$ npm run start-dev

and browse:

	open http://localhost:3000/

## React-router and browserHistory

If you want to use React-router's browserHistory, _also_ start the
"browser history server", which will serve your index page for all requests:

	$ node browser-history-server.js

and browse:

	open http://localhost:3001/
