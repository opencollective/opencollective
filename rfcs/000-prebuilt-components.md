# Adopt a set of pre-built components through `shadcn/ui`

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

Since we've recently adopted Radix UI and TailwindCSS, an initial proposed solution in this RFC is to pick [shadcn/ui](https://ui.shadcn.com/).

## Alternatives

- There are many types of styled component libraries, but within the space of TailwindCSS and this type of "copy-paste" library there are not many options yet
- Notably [Tailwind is working on their own version](https://youtu.be/CLkxRnRQtDE?t=3509) of this type of component library which is looking promising. However, it is not yet launched and unclear whether it will be free and open source or a paid product. It's also built with React Aria and not Radix UI.

## Proof of concept

<!-- If applicable, add a link to a PR or an example that demonstrate the change -->

## Adoption / Transition strategy

### Level of customization

We need to consider the extent of customization we wish to apply.

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

#### Proposal

Given the benefits highlighted in the Motivation section, the recommendation is to start with a low level of customization when adopting the new component library. The rationale behind this approach is as follows:

1. **Immediate Efficiency Gains:** By starting with a low level of customization, we can immediately leverage the pre-crafted components of [shadcn/ui](https://ui.shadcn.com/). This allows for quicker turnarounds on projects and frees up engineering resources. Over-customizing from the outset can negate this benefit, as substantial time and effort might be spent on tailoring the components rather than on the core functionalities of our projects.

2. **Maintain Consistency:** One of the primary reasons for adopting a component library is to ensure consistency across applications. Starting with a low level of customization ensures that we adhere to a standardized look and feel, thereby reinforcing our brand image.

3. **Gradual Evolution:** Beginning with a foundational layer of pre-built components provides a stable platform upon which customizations can be incrementally introduced. This means that as we get a better grasp of our specific needs and user feedback, we can tailor the components without undergoing a massive overhaul.

4. **Reduced Risk:** Initiating with minimal customization allows us to assess the compatibility and flexibility of the component library with our existing systems. If any issues arise, it becomes easier to backtrack or pivot without having invested too much time into extensive customizations.

5. **Focus on Learning and Integration:** By not diving deep into customization from the get-go, the team can focus on familiarizing themselves with the new library, its nuances, and best practices. This ensures smoother integration with our projects and sets the stage for more sophisticated customizations in the future if needed.

6. **Retaining Familiarity:** As mentioned in the Motivation section, utilizing popular component designs provides users with an intuitive experience. By sticking close to the original designs initially, we can provide an interface that many users might already be familiar with.

In conclusion, while customization is undoubtedly a powerful tool, in the initial stages of adoption, the focus should be on integration, learning, and leveraging the efficiency gains of the component library. As our familiarity with the library grows and as we gather more user feedback, we can then introduce customizations in a more informed and strategic manner.
