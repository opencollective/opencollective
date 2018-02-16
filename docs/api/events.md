# Events API

## List events

`/:collectiveSlug/events.json`

E.g. https://opencollective.com/sustainoss/events.json?limit=10&offset=0

```json
[
  {
    "id": 8770,
    "name": "Sustain",
    "description": null,
    "slug": "2017",
    "image": null,
    "startsAt": "Mon Jun 19 2017 17:00:00 GMT+0000 (UTC)",
    "endsAt": "Thu Mar 16 2017 01:00:00 GMT+0000 (UTC)",
    "location": {
      "name": "GitHub HQ",
      "address": "88 Colin P Kelly Jr Street, San Francisco, CA",
      "lat": 37.782267,
      "long": -122.391248
    },
    "url": "https://opencollective.com/sustainoss/events/2017",
    "info": "https://opencollective.com/sustainoss/events/2017.json"
  }
]
```

Parameters:
- limit: number of events to return
- offset: number of events to skip (for pagination)

Notes:
- `url` is the url of the page of the event on opencollective.com
- `info` is the url to get the detailed information about the event in json

## Get info

`/:collectiveSlug/events/:eventSlug.json`

E.g. https://opencollective.com/sustainoss/events/2017.json

```json
{
  "id": 8770,
  "name": "Sustain",
  "description": null,
  "longDescription": "A one day conversation for Open Source Software sustainers\n\nNo keynotes, expo halls or talks.\nOnly discussions about how to get more resources to support digital infrastructure.\n\n# What\nA guided discussion about getting and distributing money or services to the Open Source community. The conversation will be facilitated by [Gunner](https://aspirationtech.org/about/people/gunner) from AspirationTech.\n\n# Sustainer?\nA sustainer is someone who evangelizes and passionately advocates for the needs of open source contributors.\n\nThey educate the public through blog posts, talks & social media about the digital infrastructure that they use everyday and for the most part, take for granted.\n\nThey convince the companies that they work for to donate money, infrastructure, goods and/or services to the community at large. They also talk to the companies that they don’t work for about the benefits sustaining open source for the future.\n\n# Connect\n- Slack\nhttps://changelog.com/community\n\\#sustain\n- Twitter\n[@sustainoss](https://twitter.com/sustainoss)\n- GitHub\nhttps://github.com/sustainers/\n\n# Scholarships\nWe welcome everyone who wants to contribute to this conversation. Email us hello@sustainoss.org if the ticket doesn't fit your budget.\n\n# SUSTAIN IS SOLD OUT 🎉🎉 \nWe are still accepting sponsorships if you'd like to contribute. ",
  "slug": "2017",
  "image": null,
  "startsAt": "Mon Jun 19 2017 17:00:00 GMT+0000 (UTC)",
  "endsAt": "Thu Mar 16 2017 01:00:00 GMT+0000 (UTC)",
  "location": {
    "name": "GitHub HQ",
    "address": "88 Colin P Kelly Jr Street, San Francisco, CA",
    "lat": 37.782267,
    "long": -122.391248
  },
  "currency": "USD",
  "tiers": [
    {
      "id": 10,
      "name": "sponsor",
      "description": "Contribute to the travel & accomodation fund your logo/link on website\n$25 credit for sticker swap table.",
      "amount": 100000
    }
  ],
  "url": "https://opencollective.com/sustainoss/events/2017",
  "attendees": "https://opencollective.com/sustainoss/events/2017/attendees.json"
}
```

Notes:
- `url` is the url of the page of the event on opencollective.com
- `attendees` is the url to get the list of attendees in JSON

## Get list of attendees

`/:collectiveSlug/events/:eventSlug/attendees.json`

E.g. https://opencollective.com/sustainoss/events/2017/attendees.json?limit=10&offset=0

```json
[
  {
    "MemberId": 10057,
    "createdAt": "2017-12-01 19:42",
    "type": "USER",
    "role": "ATTENDEE",
    "isActive": true,
    "totalAmountDonated": 0,
    "lastTransactionAt": "2018-02-15 23:43",
    "lastTransactionAmount": 0,
    "profile": "https://opencollective.com/magic_cacti",
    "name": "David  Baldwin ",
    "company": null,
    "description": "Opensource hardware and software hacker",
    "image": null,
    "email": null,
    "twitter": "https://twitter.com/magic_cacti",
    "github": null,
    "website": "https://twitter.com/magic_cacti"
  },
  ...
]
```

Notes:
- `github` is verified via oauth but `twitter` is not
- `email` returns null unless you make an authenticated call using the `accessToken` of one of the admins of the collective
