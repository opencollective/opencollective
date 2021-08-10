# Affected projects

Frontend

# Motivation

We've introduced ReactHookForm (RHF) a few weeks ago. The resulsts for building simple forms like
`CreateConversationForm` were pretty good, but the recent experience with the new expense flow
was terrible. I spent a lot of time working around inconsistent behaviors and incomplete features
(see below), detailing the issues and [contributing](https://github.com/react-hook-form/react-hook-form/pull/1011) to
the library to try to add the pieces that were missing for us. I now think that we should change our
strategy and review the decision made in [006-use-react-hook-form](./006-use-react-hook-form.md).

## Bad support for array fields and nested fields

The new expense flow has a dynamic form with nested fields and RHF turned out not being suited for that. See:

- https://github.com/react-hook-form/react-hook-form/issues/979
- https://github.com/react-hook-form/react-hook-form/issues/961
- https://github.com/react-hook-form/react-hook-form/issues/456

## No willingness to make the library universal

A recurring answer on feature requests is that they prefer to keep the library simple and have complex
use cases being handled outside of the library (which arguably is a legit choice). Messages like
[this one](https://github.com/react-hook-form/react-hook-form/issues/456#issuecomment-549685119) from the
main maintainer tends to show that we shouldn't expect from the library to cover complex use cases:

> to be honest, I am even doubting `react-hook-form` is the right lib for those components and it's a pretty bad pattern to `getValues()` on each render. Honestly, formik or those controlled form lib would be a better fit for the job, I am not devaluing react-hook-form here but the right tool for the right job.

## Lack of clarity about the roadmap & decision processes

Feature requests are [not tracked in an open way](https://github.com/react-hook-form/react-hook-form/issues/979#issuecomment-582843971) and issues are systematically closed without being implemented, which creates a
lot of duplicates and uncertainty about wether or not issues will be addressed.

A [GitHub project](https://github.com/react-hook-form/react-hook-form/projects/1)
supposedly addresses that, but it's only a bunch of cards with a short descriptions and it's unclear how
things end up there (it may be somehow transparent, but it's not open).

## Single maintainer syndrome

Part of the above may be attributed to the single maintainer syndrome. The library is mostly
the work of [Bill](https://github.com/bluebill1049) (see the [contribution graph](https://github.com/react-hook-form/react-hook-form/graphs/contributors)) and if you look at the closed issues, you'll see that
often no one else is involved in the discussion of "should we implement that".

This maintainer is doing a great job, leading the work for such a popular library alone is a
huge challenge and the overall reactions are good - the person is not to blame!

But we know that having a single maintainer is not a sign of good health in an open source project.

# Solution & Alternatives

Despite of all these issues, I believe that the motivation from [006-use-react-hook-form](./006-use-react-hook-form.md)
still stands: **we need a framework to simplify our forms and enforce good practices** for validation, handling
events and displaying error messages.

In the previous RFC [Formik](https://github.com/jaredpalmer/formik) was mentioned. You can see the arguments
of why we went with react-hook-form (RHF) in [the RFC document](./006-use-react-hook-form.md), but basically the reason was
that RHF seemed lighter, easier to get started with and supposedly more performant.

While it is still true that Formik is heavier (~+ 5kb), it's also the cost for having something flexible
that can fit all use cases. The performance argument stands for simple forms, but in my experience
complex Formik forms are easier to optimize with simple React technics.

Formik has the advantage of being mature (it's being there for almost 3 years), popular (20k+ stars) and adopted
by major actors (Airbnb, Booking.com, the NASA...etc) which gives it credibility.

**Proposal:**
Use Formik for new developments, including the expense flow.

**Alternative:**
Don't use any library. I'd be ok to do that if we don't have a consensus on Formik.

# Adoption / Transition strategy

- [006-use-react-hook-form](./006-use-react-hook-form.md) is now invalidated
- Use Formik to build new forms when you think it adds value to the code
- Because ReactHookForm is very light, it's not a problem if we don't remove it today but we should have a plan to migrate the 3 existing forms. All of them are really simple, so the migration should be fast:
  - CreateCollectiveMiniForm
  - CreateConversationForm
  - CommentForm
