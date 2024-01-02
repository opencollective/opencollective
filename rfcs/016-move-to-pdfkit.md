# RFC: Transition from React + html-pdf to PDFKit for PDF Generation

## Affected Projects

- [PDF service](https://github.com/opencollective/opencollective-pdf)

## Motivation

The primary motivation behind this transition is to move away from the deprecated and less-maintained React + `html-pdf` library in favor of [PDFKit](https://github.com/foliojs/pdfkit) and its [PDFKit Table plugin](https://www.npmjs.com/package/pdfkit-table). It is also about moving away from any PhantomJS-based or Selenium-based solutions which rely on rendering the content then converting the HTML to PDF.

The expected benefits:

- Improved performance: rendering HTML then converting to PDF means some kind of browser emulation, which is necessarily slow.
- Improved maintenance: it relies on maintained technology and standard NextJS API routes (rather than hacking into `getInitialProps`).
- Improved deployment options: it works with Vercel, Heroku, and probably any hosting service out of the box.
- Improved PDF-related logic handling (e.g., page addition when content grows).
- Improved style consistency: custom fonts work, and what you see while developing is what you get in production. No more surprises with the HTML version looking different from the PDF version.

## Drawbacks

- Inability to reuse frontend React components as PDFKit does not rely on Web/CSS technologies.

## Developer experience

The developer experience rests mostly unchanged. Start the local server, and call the endpoint to generate the PDF. The only difference is that the endpoint will be prefixed with `/api`. We'll probably want to implement some test pages to easily test the PDF generation. Screenshot testing is also a possibility: generate the PDF, send send it to a service like [Percy](https://percy.io/) or use a local comparison tool in CI.

Another benefit is that we'll be able to rely on Vercel preview deployments to test the PDF generation. This is not possible with the current solution as it relies on PhantomJS, which is not available on Vercel.

## Alternatives

During our exploration phase, we considered [JSPDF](https://github.com/parallax/jsPDF) as an alternative due to its better support for tables. However, it posed challenges, particularly regarding image handling, and exhibited lower maintenance compared to PDFKit (no update in 1 year).

## Proof of Concept

- [PR for gift card generator migration](https://github.com/opencollective/opencollective-pdf/pull/977)
- [Preview deployment of a simple table generation on Vercel](https://opencollective-pdf-git-feat-pdfkit-demo-table-opencollective.vercel.app/api/test-table)

## Adoption / Transition Strategy

The proposed transition strategy involves a phased approach where both `html-pdf` and PDFKit coexist temporarily. The new endpoints leveraging PDFKit functionalities will be prefixed with `/api`.

The migration of the gift card generator indicates a straightforward transition process. Once all functionalities are migrated, `html-pdf` will be deprecated and removed from the codebase.
