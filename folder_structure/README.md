# Folder structure

    .
    ├── README.md
    ├── frontend
    │   ├── dist
    │   │   ├── css
    │   │   ├── fonts
    │   │   ├── images
    │   │   └── js
    │   └── src
    │       ├── assets
    │       │   ├── fonts
    │       │   └── images
    │       ├── components
    │       ├── css
    │       └── lib
    ├── node_modules
    ├── package.json
    ├── scripts
    ├── server
    │   ├── config
    │   ├── controllers
    │   ├── index.js
    │   ├── lib
    │   ├── models
    │   ├── routes.js
    │   └── views
    └── test

    22 directories, 4 files


## Goals

- We need to separate server code and frontend code, that way it's easy to restart the server when there is a change in any file within `server/**/*`, and it's easy to recompile the javascript and css assets when there is a change in `frontend/src/**/*`
- We need to separate editable code from compiled code (we can't have a `bundle.js` along side code that can be edited, that makes it complicated to know where we can edit the code, it is also annoying to maintain a list of files to ignore in `grep` or folder wide search)
- 3rd party modules and compiled assets should not be checked in git (easy to ignore `node_modules/` and `front/dist/` in `.gitignore`.
- Consistency: all repos should follow the same template as much as possible

## Build process

We use [Gulp](http://gulpjs.com) to automatically compile the assets (bundle the javascript, css and minify them).

All scripts should always be referenced in `package.json`. That way they can always be accessed by running `npm run $script`. We should at least have the following commands:
- `npm start`: start the server for the current environment defined by `NODE_ENV`
- `npm run dev`: start the development environment and auto restart/recompile when files changed
- `npm run build`: build all assets into `frontend/dist/`
- `npm test`: run all tests