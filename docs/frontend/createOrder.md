# Redirect people to your website after a donation

You can create a custom URL to donate a specific amount (and frequency) using by appending `/donate`, `/pay` or `/contribute` to your collective url: e.g. 
- https://opencollective.com/webpack/donate/100/month/bronze%20sponsorship
- https://opencollective.com/webpack/pay/1000/invoice%201234

You can also append to that url a redirect parameter. That way, after the user donates money, they will be redirected to your URL and we will pass the `transactionid`.

E.g. https://opencollective.com/webpack/pay/6000/tshirt%20size%20M?redirect=https://webpack.js.org/callback

When you donate you will be redirected to https://webpack.js.org/callback?transactionid=12345

Then you can call our API to get all the details about that transaction:

https://api.opencollective.com/v1/collectives/webpack/transactions/12345
