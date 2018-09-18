# Collectives API

## Get info

Get detailed information about a collective:

`/:collectiveSlug.:format(json|csv)`

E.g.: https://opencollective.com/webpack.json

```json
{
  "slug": "webpack",
  "currency": "USD",
  "image": "https://cl.ly/221T14472V23/icon-big_x6ot1e.png",
  "balance": 7614777,
  "yearlyIncome": 28499262,
  "backersCount": 556,
  "contributorsCount": 1098
}
```

Notes:

- `image` is the logo of the collective
- all amounts are in the smaller unit of the currency (cents)
- `backersCount` includes both individual backers and organizations (sponsors)
- `yearlyIncome` is the projection of the annual budget based on previous donations and monthly pledges

## Get members

Returns all members of the collectives (core contributors, contributors, backers, sponsors)

`/:collectiveSlug/members.:format(json|csv)`

You can also filter by member type (`USER` or `ORGANIZATION`):

`/:collectiveSlug/members/:memberType(all|users|organizations).:format(json|csv)`

E.g.
- https://opencollective.com/webpack/members.json?limit=10&offset=0
- https://opencollective.com/webpack/members/all.json?limit=10&offset=0

```json
[
  {
    "MemberId": 8198,
    "createdAt": "2017-10-25 09:52",
    "type": "USER",
    "role": "BACKER",
    "tier": "Backer",
    "isActive": true,
    "totalAmountDonated": 1000,
    "currency": "USD",
    "lastTransactionAt": "2018-02-01 10:53",
    "lastTransactionAmount": 200,
    "profile": "https://opencollective.com/ralph03",
    "name": "Ralph03",
    "company": null,
    "description": "",
    "image": "https://opencollective-production.s3-us-west-1.amazonaws.com/882e5a00-ce64-11e7-ae39-cb1f4eb45be3.jpg",
    "email": null,
    "twitter": null,
    "github": "https://github.com/kazup01",
    "website": null
  },
  ...
]
```

Parameters:

- limit: number of members to return per call
- offset: number of members to skip (for pagination)

Notes:
- `github` is verified via oauth but `twitter` is not
- `email` returns null unless you make an authenticated call using the `accessToken` of one of the admins of the collective
- all amounts are in the smaller unit of the currency (cents)
- `type` can be `USER`, `ORGANIZATION` or `COLLECTIVE`
- `role` can be `ADMIN`, `MEMBER`, `BACKER`, `ATTENDEE`, `FOLLOWER`, `FUNDRAISER`
- `tier` is the name of the tier
- `isActive` specifies if the backer has an active subscription

## Get members per tier

`/:collectiveSlug/[all|users|organizations].:format(json|csv)?TierId=:TierId`

You can find the `TierId` by looking at the URL after clicking on a Tier Card on the collective page (e.g. `TierId` for https://opencollective.com/webpack/order/266 is `266`).

Alternatively, you can also use the slug of a tier:

`/:collectiveSlug/tiers/:tierSlug/[all|users|organizations].format(json|csv)`

E.g. 
- https://opencollective.com/babel/members/all.json?TierId=1906&limit=10&offset=0
- https://opencollective.com/babel/tiers/gold-sponsors/all.json?limit=10&offset=0

```json
[
  {
    "MemberId": 5485,
    "createdAt": "2017-07-07 16:44",
    "type": "ORGANIZATION",
    "role": "BACKER",
    "tier": "Gold Sponsors",
    "isActive": true,
    "totalAmountDonated": 2600,
    "currency": "USD",
    "lastTransactionAt": "2018-02-01 20:23",
    "lastTransactionAmount": 1000,
    "profile": "https://opencollective.com/amp",
    "name": "AMP Project",
    "company": "",
    "description": null,
    "image": "https://opencollective-production.s3-us-west-1.amazonaws.com/68ed8b70-ebf2-11e6-9958-cb7e79408c56.png",
    "email": null,
    "twitter": "https://twitter.com/amphtml",
    "github": null,
    "website": "https://www.ampproject.org/"
  },
  {
    "MemberId": 8263,
    "createdAt": "2017-10-26 23:08",
    "type": "ORGANIZATION",
    "role": "BACKER",
    "tier": "Gold Sponsors",
    "isActive": true,
    "totalAmountDonated": 5000,
    "currency": "USD",
    "lastTransactionAt": "2018-02-02 00:08",
    "lastTransactionAmount": 1000,
    "profile": "https://opencollective.com/fbopensource",
    "name": "Facebook Open Source",
    "company": null,
    "description": "Facebook Open Source Team",
    "image": "http://res.cloudinary.com/opencollective/image/upload/v1508519428/S9gk78AS_400x400_fulq2l.jpg",
    "email": null,
    "twitter": "https://twitter.com/fbOpenSource",
    "github": null,
    "website": "https://code.facebook.com/projects/"
  }
]
```

## Get transactions from collective

`/v1/collectives/:collectiveSlug/transactions?type=:type&limit=:limit&offset=:offset&dateFrom=:dateFrom&dateTo=:dateTo&type=:includeVirtualCards`

Return All Transactions of a collective given its slug.

### Parameters

- limit: number of members to return per call
- offset: number of members to skip (for pagination)
- offset: number of members to skip (for pagination)
- type: Filter transactions of type `DEBIT` or `CREDIT`
- dateFrom: the start date(format `YYYY-MM-DD`) to be considered when returning the data
- dateTo:the end date(format `YYYY-MM-DD`) to be considered when returning the data
- includeVirtualCards: a boolean that, if true, will include the transactions generated by all virtual cards issued by the specified collective


### Curl command

```sh
curl "http://localhost:3060/v1/collectives/opencollective-company/transactions" \
  -H "Content-Type: application/json"\
  -H "Client-Id: ${ClientId}"
```

PS: For more details on how to have a Client ID/API Key, get in touch.

E.g.
- Including Virtual Card transactions(transactions that used a virtual card that was issued by the collective: http://opencollective.com/v1/collectives/opencollectiveinc/transactions?api_key=YOUR_API_KEY&includeVirtualCards=true
- NOT Including Virtual Cards: http://opencollective.com/v1/collectives/opencollectiveinc/transactions?api_key=YOUR_API_KEY
- Using `limit=20`, `type=DEBIT` and `offset=5`: http://opencollective.com/v1/collectives/opencollectiveinc/transactions?api_key=YOUR_API_KEY&includeVirtualCards=true&limit=20&type=DEBIT&offset=5


### Output

The output will be a json with a result property that will contain an array. here is an example:

```json
{
   "result":[
      {
         "id":9047,
         "uuid":null,
         "type":"CREDIT",
         "amount":500,
         "currency":"USD",
         "hostCurrency":"USD",
         "hostCurrencyFxRate":1,
         "hostFeeInHostCurrency":-25,
         "platformFeeInHostCurrency":-25,
         "paymentProcessorFeeInHostCurrency":-45,
         "netAmountInCollectiveCurrency":405,
         "createdAt":"Sun Apr 30 2017 22:33:49 GMT-0400 (Eastern Daylight Time)",
         "updatedAt":"Thu Mar 08 2018 15:24:33 GMT-0500 (Eastern Standard Time)",
         "host":{
            "id":8686,
            "slug":"opencollectiveinc"
         },
         "createdByUser":{
            "id":3605,
            "email":null
         },
         "fromCollective":{
            "id":4505,
            "slug":"christinabowen"
         },
         "collective":{
            "id":1,
            "slug":"opencollective-company"
         },
         "paymentMethod":{
            "id":2198
         }
      },
      {
         "id":7698,
         "uuid":null,
         "type":"CREDIT",
         "amount":500,
         "currency":"USD",
         "hostCurrency":"USD",
         "hostCurrencyFxRate":1,
         "hostFeeInHostCurrency":-25,
         "platformFeeInHostCurrency":-25,
         "paymentProcessorFeeInHostCurrency":-45,
         "netAmountInCollectiveCurrency":405,
         "createdAt":"Fri Mar 31 2017 22:25:57 GMT-0400 (Eastern Daylight Time)",
         "updatedAt":"Thu Mar 08 2018 15:23:18 GMT-0500 (Eastern Standard Time)",
         "host":{
            "id":8686,
            "slug":"opencollectiveinc"
         },
         "createdByUser":{
            "id":3605,
            "email":null
         },
         "fromCollective":{
            "id":4505,
            "slug":"christinabowen"
         },
         "collective":{
            "id":1,
            "slug":"opencollective-company"
         },
         "paymentMethod":{
            "id":2198
         }
      }
   ]
}
```
