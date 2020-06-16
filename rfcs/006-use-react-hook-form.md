# Affected projects

Frontend

# Motivation

Building forms with React is often:

- Verbose & painful, because for each new form we need to re-implement a new logic to:
  - Save/load values
  - Do the validation, generate errors
  - Define form states (loading, valid, touched, submitting, submitted, errored...etc)
- Not performant, because when using controlled fields or local state we often end up updating
  the whole form each time a key is pressed.

Because React doesn't provide a clear pattern to do everything mentioned above, a lot of our forms are lacking proper validations and there are a lot of differences in code style between them. Just compare the following forms:

- https://github.com/opencollective/opencollective-frontend/blob/261c93c8ebf8c236b68e2a81eac856a5cf0b3d6a/components/contribution-flow/StepDetails.js#L136
- https://github.com/opencollective/opencollective-frontend/blob/df46e1b410cf800870741816816792a77413f088/components/EditWebhooks.js
- https://github.com/opencollective/opencollective-frontend/blob/da8efef3f23bbf651a548a1f85d296d82d4b91aa/components/CreateProfile.js

This [last example](https://github.com/opencollective/opencollective-frontend/blob/da8efef3f23bbf651a548a1f85d296d82d4b91aa/components/CreateProfile.js) is in my opinion a good representation of why we need to have a "framework" to constrain the way we build them, so that the form complexity doesn't translate to a code that is difficult to read and maintain.

To outline the fact that it's a systemic problem (and not a developer developer problem) I'd like to add that some of the forms I have implemented share the exact same issues, see https://github.com/opencollective/opencollective-frontend/blob/1d83298a0cff4a014c9c8d6028824210b15b0548/components/CreateVirtualCardsForm.js for example.

# Solution & Alternatives

In the past I've used [Formik](https://github.com/jaredpalmer/formik) that I was pretty happy with. It's flexible enough to fit the most complex requirements and provide a clear API that make forms more structured.

I've since discovered [React Hook Form](https://react-hook-form.com/), a young library that got huge traction over the last few months.

From what I've seen it has all the features we would need from Formik today, with the following benefits:

- Easier to learn: the API is small and simple.
- Validations: supports HTML5 validations natively, while it's still possible to add custom validation strategies.
- Performance: because the library's default behavior is to use not-controlled components, there's no unnecessary renders
- Bundle size: 5.5kb GZipped VS 14.7kB for Formik
- Documentation: The docs are in my experience **way** clearer for React Hook Form

Bonus: React Hook Form has [a very nice GUI tool](https://react-hook-form.com/form-builder) to quickly build forms.

👉️ [The official website](https://react-hook-form.com/) provides an in-depth comparison of popular libraries that I strongly recommend to check.

_Note: Both Formik and React Hook Form are on Open Collective._

# Proof of concept

See https://github.com/opencollective/opencollective-frontend/pull/2983 as an example of moving an existing form to React Hook Form.

# Adoption / Transition strategy

- The use of **React Hook Form** should be enforced for all new forms.
- We should update our developer documentation accordingly, with links to the docs and utils.
- Old forms may be migrated when they're complex/hard to maintain, but this is not a requirement.
