To add a translation to a new language, copy paste the en.json from frontend/src/lang and rename the copy using the 2 or 4 letter code for your country/language (e.g. fr-BE.json or fr.json).

You will also need to copy paste the last line in frontend/scripts/translate.js:

fs.writeFileSync(LANG_DIR + 'ja.json', JSON.stringify(translatedMessages('ja'), null, 2));
and replace ja with your 2-4 letter locale code.

Then you can submit a pull request, like this one :-) https://github.com/opencollective/frontend/pull/119