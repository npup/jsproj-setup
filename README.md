# jsproj-setup

shell script for setting up a js project with webpack, babel, sass, react, mocha  
uses an html template. copies image assets to dist

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
