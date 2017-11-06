# totes-random


## Environment

You'll need node.js 8 installed to develop & build this application.

Run `npm i` to install dependencies.


## Developing

Add new TypeScript modules to `src/ts`.

To test your changes locally, run:

```
npm start
```

This starts the webpack dev server, which by default runs at `localhost:8000`. You can specify a `PORT` and `NODE_ENV` if you'd like. `NODE_ENV` can change the way webpack bundles the application (this isn't currently set up, though), or expose different environment variables in the bundle at `process.env` (based on values set in `config.yml`).

To bundle the app for deployment in the `dist` directory, run:

```
npm run build
```

You can also specify a `NODE_ENV` here, too.


## To-Do

- CSS (or SASS/LESS) and webpack config to bundle it
