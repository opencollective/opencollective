# RFC 015 - Adopting a Utility-First CSS approach with TailwindCSS

---

# Affected projects

- [opencollective/opencollective-frontend](https://github.com/opencollective/opencollective-frontend)
- [opencollective/discover](https://github.com/opencollective/discover) (already using TailwindCSS to some degree)
- [opencollective/opencollective-frontend-template](https://github.com/opencollective/opencollective-frontend-template)
- [opencollective/opencollective-pdf](https://github.com/opencollective/opencollective-pdf)

# Motivation

Our current approach to CSS and styling using styled-components presents several challenges:

- It usually requires less code to write the same thing with Tailwind. With styled-components, custom CSS is often required.
- A lack of established standards (and those we have are difficult to use)
  - We do have `styled-system` with our predefined config of spacing, colors, breakpoints, etc. Biggest drawback to me is the need to define and extend this ourselves.
  - We also have "utility components" (Flex/Grid/Box/P/H1/etc) - see example and more on these below
- Naming things is hard - and `styled-components` require you to name (and break out from the jsx return statement) a lot of elements just to apply styling. See example below.
- Currently lack an approach to utilize already styled components from external sources (except for Material UI - which has it's own drawbacks)
- Performance - processing styled components has substantial cost, especially for dynamic components
- Tailwind has gained a lot of traction in the last few years and is now a [more popular](https://ossinsight.io/analyze/styled-components/styled-components?vs=tailwindlabs%2Ftailwindcss#overview) option than styled-components. It has a rich ecosystem.
- Filtering style props on components has been [historically difficult](https://styled-components.com/docs/api#shouldforwardprop). Even though a new pattern appeared since that filters props starting with a `$` (e.g. `<P $marginTop={8} />`) automatically, this problem simply doesn't exist with Tailwind.
- Tailwind provides some [accessibility helpers](https://tailwindcss.com/docs/screen-readers) out of the box

## Code example/comparison

### Styled Components

First, an example using just `styled-components` (without our utility components and styled-system), showing the need to break out any element from the component return statement just to apply styling.

```jsx
import React, { useState } from "react";
import styled from "styled-components";

const Container = styled.div`
  background: #f3f4f6;
  padding: 32px;
  max-width: 512px;
`;

const ScrollingContainer = styled.div`
  overflow-y: scroll;
`;

const Grid = styled.div`
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  grid-gap: 16px;
`;

const Title = styled.h3`
  font-size: 24px;
  line-height: 32px;
  font-weight: 500;
`;

const Sidebar = styled.div`
  background: #fff;
  border-radius: 8px;
`;
const ItemList = styled.ul`
  > * + * {
    margin-top: 8px;
  }
`;
const Item = styled.li`
  font-weight: 700;
  color: ${(props) => (props.selected ? "#1d4ed8" : "#6b7280")};
`;

const ItemButton = styled.button`
  border: none;
`;

export default function ListWidget({ items = [] }) {
  const [selectedId, setSelectedId] = useState(null);
  return (
    <Container>
      <Grid>
        <ScrollingContainer>
          <Title>Items</Title>
          <ItemList>
            {items.map((item) => (
              <Item key={item.id}>
                <ItemButton
                  selected={selectedId === item.id}
                  onClick={() => setSelectedId(item.id)}
                >
                  {item.title}
                </ItemButton>
              </Item>
            ))}
          </ItemList>
        </ScrollingContainer>
        <Sidebar>Info</Sidebar>
      </Grid>
    </Container>
  );
}
```

### A little bit better adding our utility components and styled-system

By importing our pre-defined utility components (Container/Grid/H3/Flex/etc) we reduce the amount of Styled components we need to define. But we still need to import them.

And the CSS they apply is unclear, both the components themselves, but also the variables you provide.

For exmaple, the container accepts `p` for padding which I can either set to a string `8px` or a number, in which case it refers to our own pre-defined spacing config, which is hiding the fact that it is non-linear fairly well, having to find the file where the spacing is defined to find that out.

```jsx
import React from "react";
import styled from "styled-components";
import { themeGet } from "styled-system";

import Container from "./Container";
import { Grid } from "./Grid";
import { H3 } from "./Text";

const ItemList = styled.ul`
  > * + * {
    margin-top: 8px;
  }
`;
const Item = styled.li`
  font-weight: 700;
  color: ${(props) =>
    props.selected ? themeGet("blue.700") : themeGet("black.600")};
`;

const ItemButton = styled.button`
  border: none;
`;

export default function ListWidget({ items = [] }) {
  const [selectedId, setSelectedId] = React.useState(null);
  return (
    <Container maxWidth="512px" p={4} bg="black.100">
      <Grid gridGap={2} gridTemplateColumns="repeat(3, minmax(0, 1fr))">
        <Container overflowY="scroll">
          <H3 fontSize="24px" lineHeight="32px" fontWeight={500}>
            Items
          </H3>
          <ItemList>
            {items.map((item) => (
              <Item key={item.id}>
                <ItemButton
                  selected={selectedId === item.id}
                  onClick={() => setSelectedId(item.id)}
                >
                  {item.title}
                </ItemButton>
              </Item>
            ))}
          </ItemList>
        </Container>
        <Container bg="white.full" borderRadius="8px">
          Info
        </Container>
      </Grid>
    </Container>
  );
}
```

### With TailwindCSS

If we were to use instead TailwindCSS - we remove the need to break out of the component return statement to apply styles (while still having that option when needed for reusability), resulting in a shorter more condensed file. The
The design system is also working on any html element by default - not having to import any special utility components that accept the styled-system props.
Another benefit is easily seeing the styles they apply by hovering over the class name.

```jsx
import React from "react";

import { cn } from "../lib/style";

export default function ListWidget({ items = [] }) {
  const [selectedId, setSelectedId] = React.useState(null);
  return (
    <div className="max-w-lg bg-gray-100 p-8">
      <div className="grid grid-cols-3 gap-2">
        <div className="col-span-2 overflow-y-scroll">
          <h3 className="text-2xl font-medium">Items</h3>
          <ul className="space-y-2">
            {items.map((item) => (
              <li
                key={item.id}
                className={cn(
                  "font-bold",
                  selectedId === item.id ? "text-blue-700" : "text-gray-500"
                )}
              >
                <button onClick={() => setSelectedId(item.id)}>
                  {item.title}
                </button>
              </li>
            ))}
          </ul>
        </div>
      </div>
    </div>
  );
}
```

## Performance

Styled-components computes styles dynamically, in Javascript. There's an overhead on the time to first render (estimated to 5-10%) and re-renders (estimated to 10-20%). We can expect Tailwind to completely drop this overhead.

Styled-components is also affected by an issue where, when dynamic props are used inside of styles (e.g. to set a background image that depends on an profile URL), it can end up generating many CSS classes - one each time a new value is found for a prop. This adds an extra scripting + CSS overhead (the infamous `Over 200 classes were generated for component` warning).

For a complete analysis of performances and how we can expect Tailwind to impact the metrics, see [this appendix](./appendix/015/styled-components-performance.md).

## Solution

Adopting [TailwindCSS](https://tailwindcss.com/) - a utility-first css framework - as our main approach to styling.

### What is Utility-first CSS?

A good introduction is this article from the Tailwind docs: [Utility-First Fundamentals](https://tailwindcss.com/docs/utility-first).

Summary of the article by GPT-4:

> Utility-first CSS is an approach that involves using predefined utility classes to build custom designs without writing custom CSS. This method offers benefits such as reducing time spent on inventing class names, limiting CSS file growth, and making changes with a lower risk of breaking other elements. Despite some similarities with inline styles, utility classes provide advantages in designing with constraints, responsive design, and handling hover, focus, and other states.

Extra reading/listening:

- [Why I Love Tailwind](https://mxstbr.com/thoughts/tailwind/) from the creator of Styled Components
- [Diana Mounter on using utility classes at GitHub](https://fullstackradio.com/75), podcast interview

### Suggested packages/tools for a full utility-first styling solution

- [TailwindCSS](https://tailwindcss.com/) - utilify-first CSS framework
- [`class-variance-authority`](https://cva.style/docs) - library to help create CSS class compositions and variants of components (e.g button sizes, colors, intents)

### Expected results

- More consistent styling
  - TailwindCSS by itself provides a predefined set of of font sizes, widths, breakpoints, colors (which all can be modified)
- Higher overall quality of UI
  - Having to write less custom CSS through TailwindCSS, and having to build fewer basic components ourselves by using Tailwind UI should result in a overall higher quality of components, including better accessibility
- Increased efficiency of building and maintaining UI
  - Less naming things, less writing fully custom css, less importing of packages (styled-components, styled-system), less importing of abstracted "utility" components (<Grid />, <Flex/>)
  - Easier to maintain, read and understand existing UI code (with utility classes being present directly in the composition of html elements)
- @opencollective/design and @opencollective/developers can focus less on making sure that basic components like Buttons, Dropdowns, Modals, Forms, etc, look good and function well - and focus more on domain-specific design challenges that are unique to Open Collective - and have access to more consistent primitives while doing so

## Proof of concept

[PR that adds TailwindCSS](https://github.com/opencollective/opencollective-frontend/pull/9092) and some additional changes including:

- OC primary color added to tailwind config
  - With a workaround to set the `primary` palette colors dynamically (for the Collective Theme) using styeld jsx in `DefaultPaletteStyle.tsx` used in `_app.js` and `CollectiveThemeProvider.js`, so that it can be with Tailwind
- Some global styling removed from `app.css`
  - Removed the global font-size rules (was set to 62.5%, and 55% on smaller screens)
    - Tailwind CSS expects this to be default (16px)
    - Replaced all `rem` values with a new value that is divided by 1.6 (and rounded to nearest 0.05 rem)

## Adoption / Transition strategy

- Since there is a lot of components and UI built with styled-components, we have to accept that we would live with both libraries for a while.
- We propose to adopt Tailwind and the utilify-first suite as the new main approach to styling - while slowly building new components and replacing old stuff using the new suite.
- To allow for a smoother transition, new development using `styled-components` is accepted but discouraged.

### Suggested steps

- [ ] Merge RFC and Tailwind PR
- [ ] Host team workshop on Tailwind and the entire suite of tools
- [ ] Quick wins
  - [ ] Switch out all "utility" styled components (`<Grid />`, `<Box />`, `<Flex />` etc) with divs with utility classes
  - [ ] Continue removing all global styles in `app.css`
- [ ] Build new components using Tailwind
- [ ] Track progress through counting styled-components import counts compared to before adopting RFC
