# Script

The script opencollective-api [refund script](https://github.com/opencollective/opencollective-api/blob/master/scripts/add_refund_transactions_from_collective.js) tries to find transactions to refund given a **List/Array** of **FromCollectiveId** . 

It looks through all transactions in the opencollective database and returns the transactions(that were still not refunded yet) that match the field **FromCollectiveId** with the Input List(as said above).

## Running the Script

### Set the HEROKU Environment variable

You can log into heroku and go to the main dashboard(link: https://dashboard.heroku.com/apps/opencollective-prod-api)
You'll see something like this


### Go to the setting tabs

Through the picture above you'll see multiple tabs, then look for the setting ones and click on the button `Reveal config vars`.

You'll see a list with some variables and its respective values beside.


### Edit the Environment Variable FROM_COLLECTIVE_IDS

You look for the variable named `FROM_COLLECTIVE_IDS` and change it to the value you want. In case you don't find it on the list you can just add it.

Example: 

- if you want to refund all transactions that a collective with id X has done you'll set this `FROM_COLLECTIVE_IDS` to `X`:
    - `FROM_COLLECTIVE_IDS`: X

- if you want to refund all transactions that a collective with id X **AND** another collective with id Y has done you'll set this `FROM_COLLECTIVE_IDS` to `X,Y`:
    - `FROM_COLLECTIVE_IDS`: X,Y    

- if you want to refund all transactions that a collective with id X **AND** another collective with id Y **AND** another collective with id W has done you'll set this `FROM_COLLECTIVE_IDS` to `X,Y,W`:
    - `FROM_COLLECTIVE_IDS`: X,Y,W

- And so On...

### Running heroku 

We have more than one option here(using the heroku interface or using the terminal). I'll go with the terminal version:

1. Make sure you have heroku installed in your machine
2. Make sure you are logged in to the opencollective heroku account
3. run in staging: `heroku run npm run refund-transactions --app opencollective-staging-api`
4. run in production: `heroku run npm run refund-transactions --app opencollective-prod-api`
