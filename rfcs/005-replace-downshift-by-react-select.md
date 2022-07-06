# RFC - Replace downshift by react-select

# Affected projects

- Frontend

# Motivations

- Don't reinvent the wheel

A lot of the code in `StyledSelect` is dedicated to re-creating a full select behaviour. For example [we catch the keyboard events](https://github.com/opencollective/opencollective-frontend/blob/aacbf4f36efe8d6ff71308252dcdcf8b9565a5a7/src/components/StyledSelect.js#L252) to navigate between items. This is time consuming to maintain and error prone.

- Improve accessibility

Whatever we do, we'll never be able to reach the level of accessibility of the native select or the one of a library with hundreds of testers and contributors.

Someone actually complained about our select component on Twitter (see [StyledSelect accessibility · Issue #2056 · opencollective/opencollective · GitHub](https://github.com/opencollective/opencollective/issues/2056))

- Add rich features to our existing selects

By using a library to handle our selects, we can benefit from other rich features that they may implement. See `Solution` for more details.

# Solution

I've used `react-select` in the past. It's a mature library (it went through major re-designs for v2 and V3) that is actually the more popular select library for react (almost 17.000 stars on GitHub). It uses the same patterns than `styled-component` for customization, so we'll be able to implement our design system easily.

In addition to everything you could expect from a select, it has the following features:

- Searchable

Useful to easily pick items from long lists (ex: for our countries select)

See [React-Select](https://react-select.com/home#fixed-options)

- Asynchronously fetch for options

Could be useful if we want to implement an autocomplete select to pick a collective. We had this use case for "archive collective", to transfer the remaining funds to another collective.

See [React-Select - Async](https://react-select.com/async)

- Creatable

This mode is made for things like tags input. It combines autocomplete / select with the ability to add new items.

See [React-Select - Creatable](https://react-select.com/creatable)

### Impact on bundle size

Once this change is made, we can remove:

- `react-tag-input` - 11.6kB (+ additional CSS included)
- `downshift` - 7.1kb
- All our internal code to deal with keystrokes, options building...etc

`react-select` is 26.1kb (less if we don't use Async fetch) so it could add up to 8kb to our bundle size once we made all the changes.

# Alternatives

- [instructure-react/react-select-box: An accessible select box component for React.](https://github.com/instructure-react/react-select-box)

  - Less popular
  - Not maintained
  - Bad looking default styles

- [furqanZafar/react-selectize](https://github.com/furqanZafar/react-selectize)

  - Less popular
  - Not maintained
  - Bad looking default styles

- [davidtheclark/react-aria-menubutton: A fully accessible, easily themeable, React-powered menu button](https://github.com/davidtheclark/react-aria-menubutton)

  - Less popular
  - Bad looking default styles

- [Semantic-Org/Semantic-UI-React: The official Semantic-UI-React integration](https://github.com/Semantic-Org/Semantic-UI-React)
  - Styled with CSS

# Proof of concept

Can be added to this PR if requested.

# Adoption / Transition strategy

We only use `StyledSelect` in 3 parts of the code so the migration should be easy.
A \$100 bounty to migrate everything would be appropriate.
