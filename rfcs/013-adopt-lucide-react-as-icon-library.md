# Affected projects

- [opencollective/opencollective-frontend](https://github.com/opencollective/opencollective-frontend)
- [opencollective/discover](https://github.com/opencollective/discover)
- [opencollective/opencollective-frontend-template](https://github.com/opencollective/opencollective-frontend-template)

# Motivation

We're currently using styled-icons which provides access to multiple icon libraries, which has been a benefit since finding a singular icon library that provides all icons you want can be difficult.

The downside is that we end up using a bunch of different icon libraries with slightly different looks, sometimes using the same type of icon from several libraries in different places causing inconsistency in the UI and also confusion for developers in not knowing which one to pick.

We're currently using 171 icons from 12 icon libraries.

# Solution

Proposing to adopt [Lucide Icons](https://lucide.dev/) as our single icon library (perhaps some exception for brand icons needed). It is a icon library with 1143 icons, that is actively developed and popular, and it contains replacements for all our current icons except a handful of brand icons.

See https://icons-test-gustav-opencollective.vercel.app/ for an overview of icons used in `opencollective-frontend` and a possible Lucide Icons replacement. The 171 icons from 12 libraries can be replaced by 97 Lucide icons, since there is a lot of duplicate icon imports.

The icons from Lucide should technically work out of the box as replacements for the styled-icons, accepting the `size` property and be styleable using styled-components, although there might be some places where some positioning or sizing fixes would be needed.

The icons also accept strokeWidth and a prop to enforce absoluteStrokeWidth instead of a scaled stroke, which is a nice benefit when working with smaller or bigger icons than usual.

They have a fairly large set of "Money" icons which is useful for Open Collective being a money management platform.

# Alternatives

<!-- What are the alternatives? What are their drawbacks? -->

# Proof of concept

Overview of Lucide icon replacements: https://icons-test-gustav-opencollective.vercel.app/

# Adoption / Transition strategy

- Replace all icons in one go
- Either keep using `@styled-icons/fa-brands` for certain brand icons, or use another approach.
