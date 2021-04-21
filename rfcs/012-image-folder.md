# RFC 012 - Keep Images in a Centralized Location

# Affected projects

- Frontend

# Motivation

As discussed in this issue, https://github.com/opencollective/opencollective-frontend/pull/6158#pullrequestreview-640718161,
we tend to keep images in any folder. So for example we have image files in components folder;

```
./components/collective-page/images/ContributorsGridBackground.svg
./components/collective-page/images/HeroBackgroundMask.svg
./components/collective-page/images/EmptyCollectivesSectionImage.svg
./components/icons/PrivateLockIcon.png
./components/tier-page/Bubbles.svg
./components/contribution-flow/fees-on-top-illustration.png
./components/contribution-flow/success-illustration.jpg
```

It's best to avoid putting images in folders such as `components` which is normally the place for React components,
and to keep all images in a dedicated folder.

# Solution

We currently have `public/static/images` folder which has the majority of the images. Suggest putting all images in this
folder.

# Alternatives

Keep things as it is and let user decide where to put the images.

# Proof of concept

The following PR has part of the work, but we can do a global search and add all images to `public/static/images`;

https://github.com/opencollective/opencollective-frontend/pull/6158

# Adoption / Transition strategy

It's simple to search for images in other folders and migrate those images to the `public/static/images` folder.
