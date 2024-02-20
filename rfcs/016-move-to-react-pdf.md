# RFC: Transition from `html-pdf` to `react-pdf` for PDF generation

## Affected Projects

- [PDF service](https://github.com/opencollective/opencollective-pdf)

## Motivation

The primary motivation behind this transition is to move away from the deprecated and less-maintained `html-pdf` library in favor of [react-pdf](https://github.com/diegomura/react-pdf) [PDFKit](https://github.com/foliojs/pdfkit). It is also about moving away from any PhantomJS-based or Selenium-based solutions that rely on rendering the content then converting the HTML to PDF.

`react-pdf` offers similar benefits to PDFKit, including maturity and active maintenance, while introducing a simpler React-based syntax for PDF generation. The expected benefits:

The expected benefits:

- Improved performance: rendering HTML then converting to PDF means some kind of browser emulation, which is necessarily slow.
- Improved maintenance: it relies on maintained technology and standard NextJS API routes (rather than hacking into `getInitialProps`).
- Improved deployment options: it works with Vercel, Heroku, and probably any hosting service out of the box.
- Improved PDF-related logic handling (e.g., page addition when content grows).
- Improved style consistency: custom fonts work, and what you see while developing is what you get in production. No more surprises with the HTML version looking different from the PDF version.
- Simplified setup: cutting our reliance on HTML/CSS technologies, we could end up moving to simpler/faster web server frameworks like [Nitro](https://nitro.unjs.io/) or [Fastify](https://www.fastify.io/).

## Drawbacks

- Inability to reuse frontend React components as PDFKit does not rely on Web/CSS technologies.
- Lack of proper support for tables. **This is currently a blocker for this RFC**. The status is:
  - `react-pdf` does not support tables out of the box (see https://github.com/diegomura/react-pdf/issues/2343)
  - The [`ag-media/react-pdf-table`](https://github.com/ag-media/react-pdf-table) plugin has some issues with mutipage tables see (https://github.com/ag-media/react-pdf-table?tab=readme-ov-file#limitations--known-issues).

## Developer experience

The developer experience rests mostly unchanged. Start the local server, and call the endpoint to generate the PDF. The only difference is that the endpoint will be prefixed with `/api`. We'll probably want to implement some test pages to easily test the PDF generation. Screenshot testing is also a possibility: generate the PDF, send send it to a service like [Percy](https://percy.io/) or use a local comparison tool in CI.

Another benefit is that we'll be able to rely on Vercel preview deployments to test the PDF generation. This is not possible with the current solution as it relies on PhantomJS, which is not available on Vercel.

## Alternatives

- During our exploration phase, we considered [JSPDF](https://github.com/parallax/jsPDF) as an alternative due to its better support for tables. However, it posed challenges, particularly regarding image handling, and exhibited lower maintenance compared to PDFKit (no update in 1 year).
- Using PDFKit directly is also an option (it was actually the first proposal made with this RFC) but it is not as developer-friendly as `react-pdf`.

## Proof of Concept

- [PR for gift card generator migration](https://github.com/opencollective/opencollective-pdf/pull/983)
- [Legacy PR for gift card generator migration with PDFKit](https://github.com/opencollective/opencollective-pdf/pull/977)

## Adoption / Transition Strategy

The proposed transition strategy involves a phased approach where both `react-pdf` and `html-pdf` coexist temporarily. The new endpoints leveraging PDFKit functionalities will be prefixed with `/api`.

The migration of the gift card generator indicates a straightforward transition process. Once all functionalities are migrated, `html-pdf` will be deprecated and removed from the codebase. We will redirect all requests to the new endpoints.
