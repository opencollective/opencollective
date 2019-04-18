# RFC 002 - style-components

**TL;DR:**

There is a lot of repeated and inconsistent styles spread around the application. Using an extensible library like [`styled-components`](https://www.styled-components.com/) and its [ecosystem](https://www.styled-components.com/ecosystem) will make building UIs efficient and consistent.

## Motivation:

While working on the layout and design of the new homepage (as well as the search page previously), I had some trouble learning the best practice for using a responsive grid with repeating styles and modifying existing component styles without exposing global selectors. 

`styled-jsx` is great at scoping selectors to the component, but it has not been useful for sharing common styles and creating extensible UI components. 

The `react-bootstrap` grid components allows for responsive width sizing but does not have a nice API for working with flexbox or spacing utilities (Bootstrap v4 has this but not coming anytime soon to `react-bootstrap`). 

## Solution:

While searching for a solution to these issues, I looked to one of my favorite CSS libraries, [basscss](https://basscss.com/) for inspiration and discovered a simple yet powerful grid library, built by the author of basscss, called [`grid-styled`](https://github.com/jxnblk/grid-styled) that uses [`styled-components`](https://www.styled-components.com/) as a peer dependency. 

`styled-components` works with Next.js, including server-side rendering, and allows for [styling third-party components](https://www.styled-components.com/docs/basics#styling-any-components). I believe adopting this library and pattern will cleanup a lot of our css-in-js code with no apparent impacts in performance. 

We can use it alongside `styled-jsx` while we update existing components.

## Alternatives:

I tried to recreate the API provided by `grid-styled` using `styled-jsx` however dynamically creating media queries and making the components extensible required more custom tooling than it was worth. 

## Proof of Concept:

Included in [this PR](https://github.com/opencollective/frontend/pull/434) is an example of using `styled-components` and `grid-styled` to refactor the SearchPage. The only custom css required was written to customize the `FormControl` from `react-bootstrap`. 

## Adoption / Transition Strategy:

I have not been able to find an automated solution for converting `styled-jsx` blocks into `styled-components`.

Because we can use `styled-components` and `styled-jsx` together in the app, we _should_ be able to completely adopt `styled-components` over time. As we work on files that use `styled-jsx`, one refactor commit should be made to convert the file to use `styled-components`. This will probably start with replacing the global styles in the `_document.js` page and the `<Header>` component with an [`injectGlobal`](https://www.styled-components.com/docs/api#injectglobal) declaration and a [theme](https://www.styled-components.com/docs/advanced#theming) with our common colors, font sizes, spacing values, etc.
