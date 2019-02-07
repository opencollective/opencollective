# Add a Donate Button

See https://opencollective.com/widgets

# Redirect people to your website after they made a donation

You can create a custom URL to donate a specific amount (and frequency) using by appending `/donate`, `/pay` or `/contribute` to your collective url: e.g. 
- https://opencollective.com/webpack/donate/100/month/bronze%20sponsorship
- https://opencollective.com/webpack/pay/1000/invoice%201234

You can also append to that url a redirect parameter. That way, after the user donates money, they will be redirected to your URL and we will pass the `transactionid`.

E.g. https://opencollective.com/octobox/pay/100/month/support%20the%20community?redirect=https://octobox.io/callback

When you donate you will be redirected to https://octobox.io/callback?transactionid=12345

Then you can call our API to get all the details about that transaction:

https://api.opencollective.com/v1/collectives/octobox/transactions/12345?apiKey=xxxxx
(you can get your api key in your "Applications" page that you can access from your logged in user dropdown menu)

Example of the data being returned:

```json
{
    "result": {
        "id": 134368,
        "uuid": null,
        "type": "CREDIT",
        "createdAt": "Wed Nov 07 2018 09:05:06 GMT+0000 (UTC)",
        "description": "Monthly donation to Octobox",
        "amount": 10000,
        "currency": "USD",
        "hostCurrency": "USD",
        "hostCurrencyFxRate": 1,
        "netAmountInCollectiveCurrency": 8680,
        "hostFeeInHostCurrency": -500,
        "platformFeeInHostCurrency": -500,
        "paymentProcessorFeeInHostCurrency": -320,
        "paymentMethod": {
            "id": 34801,
            "service": "stripe",
            "name": "4242"
        },
        "fromCollective": {
            "id": 23657,
            "slug": "anonymous1338",
            "name": "anonymous",
            "image": null
        },
        "collective": {
            "id": 413,
            "slug": "octobox",
            "name": "Octobox",
            "image": "https://opencollective-production.s3-us-west-1.amazonaws.com/4e491a10-aae0-11e8-a91b-df5253215e9d.png"
        },
        "host": {
            "id": 11004,
            "slug": "opensourcecollective",
            "name": "Open Source Collective 501c6 (Non Profit)",
            "image": "https://opencollective-production.s3-us-west-1.amazonaws.com/5f4a3920-11b6-11e8-b28d-b359f3c5ca14.png"
        },
        "order": {
            "id": 33193,
            "status": "ACTIVE",
            "subscription": {
                "id": 26426,
                "interval": "month"
            }
        }
    }
}
```
