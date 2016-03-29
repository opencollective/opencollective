# Get started

## Structure

Our codebase is splitted in multiple repos: `website`, `api`, `app`. We run those 3 node.js applications separately. `website` and `app` are the client applications that you can find on `https://opencollective.com/yeoman` (`website`) and `https://app.opencollective.com/` (`app`).

To run one of the client application locally, you need to run the `api` alongside.

## Setup api

### Install postgres (mac)

```bash
brew install postgres
pg_ctl -l /usr/local/var/postgres/server.log start
```

### Install API

We currently use node `5.1.0` and npm `3.3.12`. Checkout [nvm](https://github.com/creationix/nvm) for versioning node.js binaries.

```bash
git clone https://github.com/OpenCollective/api.git
cd api
touch .env
npm install
npm install -g nodemon
```

You should be now able to run the api with `npm run dev` in autoreload mode or `npm start`.

### Run the api

```bash
npm run db:reset
npm run dev
```

If you have a problem with this step, you might need to grant privileges to your database (see below).

Check if the api is running properly by opening `http://localhost:3060/status` in your browser.

Some environment variables might be missing from your setup, you need to add them in your `.env`. If you want to test image uploading, you will need to add your own AWS config.

#### Postgres privileges

Now, assuming the postgres database superuser is `postgres`, let's create the databases.

```bash
createdb -U postgres opencollective_localhost
createdb -U postgres opencollective_test
createuser -U postgres opencollective
psql -U postgres
> GRANT ALL PRIVILEGES ON DATABASE opencollective_localhost TO opencollective;
> GRANT ALL PRIVILEGES ON DATABASE opencollective_test TO opencollective;
```

## Run the website

You will need to install gulp to compile the assets: https://github.com/gulpjs/gulp/blob/master/docs/getting-started.md

```bash
git clone https://github.com/OpenCollective/website.git
cd website
npm install
npm run dev
```

The website is now running. If you run the api alongside, you should be able to go on `http://localhost:3000/opencollective` to see the donation page.

The default flow is with paypal, if you want to setup the flow with stripe, you will need to connect your account in the `app` (instructions below)

## Run the app


```bash
git clone https://github.com/OpenCollective/app.git
cd app
npm install
npm run dev
```

Open `http://localhost:3000/login` in your browser and enter the following credentials `devuser@opencollective.com` and `password`.

If you want to try a Stripe donation, you will need to click on the blue `Authenticate with Stripe` button and finish the flow. You will first need to add the stripe api keys in the `.env` of the `api`.

```
STRIPE_SECRET
STRIPE_KEY
STRIPE_CLIENT_ID
```