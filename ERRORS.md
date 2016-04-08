# Common errors

## Database

```
SequelizeDatabaseError: column "platformFee" does not exist
  name: 'SequelizeDatabaseError'
```

You need to run the migration on your local db with `npm run db:migrate:dev`

## Headers

```
Can't set headers after they are sent
```

If you use `res.send` twice in the same route it will fail because you already responded to the request. Most of the time, the programmer forgot to return the `res.send` statement. (http://stackoverflow.com/questions/7042340/node-js-error-cant-set-headers-after-they-are-sent)


## Webhook

```
Donation not found: unknown subscription id
```

When a recurring payment occurs (each month), Stripe will hit our webhook and try to find the donation in our db. If it doesn't find it, it should be addressed immediately. Indeed, Stripe will try to hit our webhook multiple times because we don't return a 2XX status. A good way to debug this error is to find the `webhook.stripe.received` activity and check the `data.dashboardUrl` - it's a link to the event on the Stripe dashboard.


```
Stripe event received: invoice.payment_succeeded
```

If you receive multiple times the `invoice.payment_succeeded` event, it means that the webhook failed and that stripe is retrying. Check the error above to see how to debug it.

## Test

- Sometimes the CircleCI tests on API will fail for unknown reasons (timeout?). You should do `Rebuild without cache` and it should solve that problem.

- If you get a Chrome driver error on CircleCI, it means that it doesn't download the latest Google Chrome version, you might need to add:

```yaml
test:
  pre:
    - wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    - sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
    - sudo apt-get update
    - sudo apt-get install google-chrome-stable
```

- Build breaking without any code change? It happened a few times because the new version of a npm package got released broken. Check the GitHub/npmjs page of the npm package to see when was the last version released and downgrade if necessary (i.e. `numbro`).


## PayPal

- Link to support page for engineering problems: https://www.paypal-techsupport.com/app/ask , you will need it because there's almost no way to debug some error messages.

- If you can't see the PayPal error message, you should check the JSON response `res.error[0].message`.

- Check the following issue weekly https://github.com/paypal/PayPal-Python-SDK/issues/69 , once this gets solved we can refactor `script/populate_recurring_paypal_transactions.js` into a webhook.

## Frontend

- Action does not get called: Always bind the action to the props or it won't work

```js
import React, {Component, PropTypes} from 'react';
import { getUser } from './actions/users';

export default class Photo extends Component {

  componentDidMount() {
    getUser(1) // Nothing will happen
  }

  render() {
    return (
      <div>
      </div>
    );
  }
}

```

You need to connect it with Redux.

```js
import React, {Component, PropTypes} from 'react';
import { connect } from 'react-redux';

import { getUser } from './actions/users';

export default class Photo extends Component {

  componentDidMount() {
    this.props.getUser(1) // It will get it
  }

  render() {
    return (
      <div>
      </div>
    );
  }
}

export default connect(mapStateToProps, {
  getUser
})(Photo);

export function mapStateToProps({ user }) {
  return { user };
}
```

