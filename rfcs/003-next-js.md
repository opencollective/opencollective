# RFC Frontend 002 - Next.js

## Abstract

We're using Next.js as the base framework for our frontend app for the following reasons:

  - It gives a base opiniated setup for a React application with server side rendering.
  - It provides the basic plumbing for a modern frontend javascript web application framework: Webpack and Babel.
  - It does have a great developer experience with things like out of the box hot reloading.

Following guidance of our RFC 001, we should always use the latest version of Next.js. 

To keep our dependency tree consistent, we should align key dependencies with the one provided by Next.js: babel, webpack

Because Next.js only expose React as a peer dependency, we don't have to match a specific version and can use the latest stable version of React that is compatible with Next.js.

## Resolution

  - Always use the latest stable version of Next.js.
  - Use the Babel and Webpack versions that are used in that version of Next.js
  - Always use the latest stable version of React and React-Dom that are compatible with that version of Next.js.

## Updates

 - 2023-06-05: remove mention to styled-jsx
