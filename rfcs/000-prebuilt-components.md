# Adopt a set of pre-built components

## Affected projects

- frontend
- discover
- frontend-template

## Motivation

Given the constraints of our team size, creating and maintaining a bespoke design system poses some challenges for us in terms of efficiency, consistency and user experience.

By furnishing our engineers with pre-crafted components, we can achieve multiple benefits:

1. **Efficiency:** The development lifecycle can be substantially shortened, enabling quicker turnarounds. Instead of allocating time to create components from scratch, engineers can divert their focus to other critical aspects of development.
2. **Consistency:** Ready-made components ensure a unified look and feel across our applications, promoting a consistent brand image.
3. **Adaptability:** With the groundwork laid by these components, modifications can be introduced with relative ease, ensuring our applications remain adaptive to changing needs.
4. **Familiarisation:** Utilising a popular component design will create a familiar feel for users, making interfaces more intuitive. Engineers can utilise this too, as they will share those expectations and be able to prototype designs that are consistent with our design.
5. **Standardisation:** Using a popular component design will help us expand the engineering and designs teams with lower onboarding costs as these libraries become more pervasive and have their own community and documentation etc.

The overarching goal is to harness the potential of pre-built components to simplify our workflow, enhance productivity, and deliver great user experiences.

## Solution

There is a new type of component "library" that is gaining a lot of popularity, one where you don't import a library in your code, but rather copy-paste the component definitions over to your own code base so that you are free to customize and evolve them on your own, which means that you start owning the components and their look. The library serves as a starting point to build your own component library.

Right now, the most popular of these is probably [shadcn/ui](https://ui.shadcn.com/), an open source set of components built with TailwindCSS and Radix UI.

Since we've recently adopted Radix UI and are in the process of discussing TailwindCSS, an initial proposed solution in this RFC is to pick [shadcn/ui](https://ui.shadcn.com/).

## Alternatives

- Tailwind Catalyst
  - [Tailwind is working on their own version](https://youtu.be/CLkxRnRQtDE?t=3509) of this type of component library which is looking promising. However, it is not yet launched and unclear whether it will be free and open source or a paid product. It's also built with React Aria and not Radix UI.

## Proof of concept

<!-- If applicable, add a link to a PR or an example that demonstrate the change -->

## Adoption / Transition strategy

### Level of customization

Before we proceed, we should determine the extent of customization we wish to apply.

#### High Customization

- **Pros**
  - **Unique Identity:** Tailoring components to our vision gives our app a distinctive look and brand voice.
  - **Legacy Consistency:** It allows us to maintain or mirror the aesthetic of our previous work, ensuring a seamless transition for existing users.
- **Cons**
  - **Increased Effort:** Crafting a customized design system requires a significant time and resource investment.
  - **Evolution Challenges:** As design trends evolve, it may become challenging to ensure our custom components remain consistent and contemporary.

#### Low Customization

- **Pros**
  - **Uniformity:** Adopting pre-built components ensures a high level of consistency and reduces the risk of design inconsistencies.
  - **Efficiency:** The adoption process is streamlined, reducing the time and effort required.
  - **Familiarity for Users:** Adhering closely to recognized standards means our app will feel intuitive and user-friendly.
- **Cons**

  - **Lack of Distinction:** While our app might be easy to use, it might blend in with the multitude, potentially lacking a unique character or personality.

- [ ] Decide on how to reach desired level of customization (little by little vs all at once?)
- [ ] Adopt TailwindCSS and shadcn/ui
- [ ] Add shadcn/ui components as they are needed in `components/ui` folder to distinguish them as the common design system building blocks
