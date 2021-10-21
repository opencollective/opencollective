# RFC 013 - Internationalization: Not use `defineMessage` or `defineMessages`

## Affected projects

This effects only the [front-end](https://github.com/opencollective/opencollective-frontend).

## Current Practice

When internationalizing strings `defineMessage` and `definemessages` are used to pre-declare the messages. This is valid as per FormatJS docs however not recommended as a best practice. See https://formatjs.io/docs/getting-started/message-declaration/#pre-declaring-using-definemessage-for-later-consumption-less-recommended

### Benefits

- The use of `defineMessages` has the benefit of having all the messages in one place; typically at the top of the component and improved readability.

### Downsides

FormatJS do not recommend using `defineMessage` or `defineMessages` and particularly warns against using them since some linting rules will not run. The [docs say](https://formatjs.io/docs/getting-started/message-declaration/#pre-declaring-using-definemessage-for-later-consumption-less-recommended), 

>You can declare a message without immediately formatting it with defineMessage and our extractor would still be able to extract it. However, our enforce-placeholders linter rule won't be able to analyze it.

Also, there are some benefits of using inline messages instead of pre-declaring. See first section of, https://formatjs.io/docs/getting-started/message-declaration/#pre-declaring-using-definemessage-for-later-consumption-less-recommended

## Best Practice

Suggest using inline version `FormattedMessage` whenever possible. 

### Downside of this approach

The developer experience might be impacted since `defineMessages` can be used to define all the messages in one place. Although this is mostly dependent on user and situation; whether one wants to read all the messages in one place for a particular component or not. 

## Solution

Going forth `FormattedMessage` as opposed to pre-declaring messages with `defineMessage` and `defineMessages`. Also remove existing `defineMessage(s)` as per, https://github.com/opencollective/opencollective/issues/4852

**Related Issue:** https://github.com/opencollective/opencollective/issues/4852