# Localize

To add a translation to a new language, copy paste the [en.json](https://github.com/opencollective/frontend/blob/master/src/lang/en.json) from [frontend/src/lang](https://github.com/opencollective/frontend/tree/master/src/lang) and rename the filename using the 2 or 4 letter code for your country/language (e.g. `fr-BE.json` or `fr.json`).

You will also need to copy paste the last line in [frontend/scripts/translate.js](https://github.com/opencollective/frontend/blob/master/scripts/translate.js#L47)

```javascript
fs.writeFileSync(LANG_DIR + 'ja.json', JSON.stringify(translatedMessages('ja'), null, 2));
```

and replace `ja` with your 2-4 letter locale code.

Then you can submit a pull request, like this one :-)
https://github.com/opencollective/frontend/pull/119
