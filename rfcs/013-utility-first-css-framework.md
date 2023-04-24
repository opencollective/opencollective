# RFC 013 - Adopting a Utility-First CSS approach

## Affected projects

- [opencollective/opencollective-frontend](https://github.com/opencollective/opencollective-frontend)
- [opencollective/discover](https://github.com/opencollective/discover) (already using TailwindCSS to some degree)

## Motivation

Our current approach to CSS and styling using styled-components presents several challenges:

- Custom CSS is often required
- A lack of established standards
  - We do have `styled-system` for some of this but arguably cumbersome to use (and having to define the system ourselves)
- Naming things is hard
- Currently lack an approach to get prebuilt components from a library
- Performance - processing styled components has substantial cost

## Solution

Adopting [TailwindCSS](https://tailwindcss.com/) - a utility-first css framework - as our main approach to styling, together with complementary libraries to handle accessibility, transitions and styling/variants composition, and a license to a component library (Tailwind UI) built with these tools.

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
- See Modal.tsx in the POC below for an example
- [Headless UI](https://headlessui.com/) - unstyled fully accessible (screen reader support, keyboard interactions etc) component primitives (Dropdowns, Modals, Switches, Comboboxes etc)
- [Tailwind UI](https://tailwindui.com/)
  - Component library built with TailwindCSS, Headless UI and Heroicons
  - Requires a license. I have an individual license, but a team license is a one-time fee of $500 (discounted from $799 from already owning a license) which includes up to 25 seats
  - The major benefit of something like Tailwind UI is that these components are not imported as a npm library, but rather copy/pasted from examples - so that we are then free to evolve and modify the component as we see fit - seems to be ideal for both getting ready made components for basic things - as well as not being constrained in the design language
- [Heroicons](https://heroicons.com/)
  - Icon library from the Tailwind creators - looks good and used in Tailwind UI components
  - styled-icons depend on styled-components, and if we're looking for a replacement I'd suggest a single icon library to better ensure consistent iconography. This is from the creators of TailwindCSS/Headless UI, and is used in Tailwind UI components as well.

### Expected results

- More consistent styling
  - TailwindCSS by itself provides a predefined set of of font sizes, widths, breakpoints, colors (which all can be modified)
- Higher overall quality of UI
  - Having to write less custom CSS through TailwindCSS, and having to build fewer basic components ourselves by using Tailwind UI should result in a overall higher quality of components, including better accessibility
- Increased efficiency of building and maintaining UI
  - Less naming things, less writing fully custom css, less importing of packages (styled-components, styled-system), less importing of abstracted "utility" components (<Grid />, <Flex/>)
  - Easier to maintain, read and understand existing UI code (with utility classes being present directly in the composition of html elements)
  - Tailwind UI provides a great starting point for a lot of components - not having to reinvent the wheel for a lot of basic things
- Increased developer happiness
  - I've personally found working with Tailwind and it's ecosystem a lot easier and more fun than say styled-components
- Design and Engineering can focus less on making sure that basic components like Buttons, Dropdowns, Modals, Forms, etc, look good and function well - and focus more on domain-specific design challenges that are unique to Open Collective - and have access to more consistent primitives while doing so

## Alternatives

- Stick with Styled-Components
- Adopt a component library like Material UI

## Proof of concept

- [PR with POC including all the tools listed above](https://github.com/opencollective/opencollective-frontend/pull/8827)
- Two new/updated components as examples:
  - [InputSwitch.js](https://github.com/opencollective/opencollective-frontend/blob/ad360b3c1f3e83e618f29e9a5900967c90283087/components/InputSwitch.js)
    - starting point from Tailwind UI
    - removing Material UI as a result
  - [Modal.tsx](https://github.com/opencollective/opencollective-frontend/blob/ad360b3c1f3e83e618f29e9a5900967c90283087/components/Modal.tsx)
    - starting point from Tailwind UI
      - accessible by default from using Headless UI (which also makes it use a portal by default so that it won't suffer any layout hierarchy problems)
      - has nicer transitions than before through using `<Transition>` from Headless UI
    - added `class-variance-authority`/CVA to handle setting different modal widths
    - used in `ApplyToHostModal` and `NewsAndUpdatesModal`
- OC color palette added to tailwind config
  - With a workaround to set the `primary` palette colors dynamically (for the Collective Theme) using styeld jsx in `DefaultPaletteStyle.tsx` used in `_app.js` and `CollectiveThemeProvider.js`, so that it can be with Tailwind
- Some global styling removed from `app.css`
  - Removed the global font-size rules (was set to 62.5%, and 55% on smaller screens)
    - Tailwind CSS expects this to be default
    - Replaced all `rem` values with `px` values in the code. `1rem` => `10px` since 62.5% of `16px` is `10px`
    - Adjustments made in some places - need to find all places that suddenly have too big font sizes now

## Adoption / Transition strategy

Since there is a lot of components and UI built with styled-components, we'd have to accept that we would live with both libraries for a while. We could adopt Tailwind and the utilify-first suite as the new main approach to styling - while slowly building new components and replacing old stuff using the new suite - motivated by new and better looks, improved dx, and better accessibility for the end user.

### Suggested steps

- [ ] Merge POC
- [ ] Buy a team license for Tailwind UI (one-time fee, discounted from $799 to $500, allowing up to 25 team members)
- [ ] Host team workshop on Tailwind and the entire suite of tools
- [ ] Quick wins
  - [ ] Switch out all "utility" styled components (<Grid />, <Box />, <Flex /> etc) with divs with utility classes
  - [ ] Continue removing all global styles in `app.css`
  - [ ] Continue replacing all modals with new Modal.js
  - [ ] Switch out all icons to use Heroicons
- [ ] Build new components using Tailwind - and use Tailwind UI components as a starting point
- [ ] Track progress through counting styled-components import counts compared to before adopting RFC
