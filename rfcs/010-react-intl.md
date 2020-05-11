# RFC 010 - Best Practices with react-intl

## Affected projects

- Frontend

## Motivation

We're using react-intl and have currently 2 ways of expressing a message ("defineMessages + formatMessage", or "FormattedMessage"). It's currently not clear when to use one or another approach and guidelines would be useful for current and new developers.

## Comparaison of the 2 approaches

### defineMessages + formatMessage

```
const messages = defineMessages({
  'exampleString': {
    id: 'myComponent.exampleString',
    defaultMessage: "This is an example string",
  },
```

```
<H3>{this.intl.formatMessage(messages['exampleString'])}<H3>
```

Pros:
- Without JSX "bloat", concise
- Can be assigned to a variable
- Can be post manipulated in Javascript
- Support values
- Because it exports a string, it's sometimes the only option available (ie. to fill an HTML `select`'s options)

Cons:
- 2 steps: Needs first to defineMessages then formatMessage
- It's usually more verbose
- Unused strings are not automatically detected nor removed from the translations files, you need to remove them from the `defineMessages` first, and there's no linter warning to tell you wether they're used or not

### FormattedMessage

```
<H3><FormattedMessage id="myComponent.exampleString" defaultMessage="This is an example string" /><H3>
```

Pros:
- Self contained
- Can see the defaultValue in its context
- Only one "id" to think about
- No need for useIntl / injectIntl
- Snippet for developer productivity
- Support values

Cons:
- Doesn't looks right when used as attribute
- Can't be assigned to a variable or manipulated in Javascript

## Recommandation

By default, we should favor FormattedMessage because it's simpler and easier.

"defineMessages + formatMessage" can be used in the following situations:

- to use as attribute: ```attribute={formatMessage(messages.label)}```
- use a variable for the message key: ```formatMessage(messages[stringId])```
- manipulate string with Javascript: ```formatMessage(messages.label).toUpper()```

## Adoption / Transition strategy

- No automated mass migration should be planned
- Developers should consider recommandations from this RFC when contributing new code
- Following these recommandations is not mandatory for a PRs to be accepted
- Any developer is free to contribute refactored code following these recommandations
