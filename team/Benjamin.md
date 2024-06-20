# Benjamin Piouffle

I'm a full-time, paid core developer at Open Collective.

Email: benjamin @ opencollective.com

## Bio

I'm a French developer born in 1991. I grew up in the south of France and came back to live there in my late 20s after a few years in New Caledonia.
I studied at Epitech in Marseille and 1 year at CSU Long Beach (USA).

My favorite sport is hiking/trekking, and I like to play some music (guitar, saxophone).

## Schedule

Based in La Ciotat, I'm in the [CET](https://en.wikipedia.org/wiki/Central_European_Time) time zone.

I'm on a 36h/week schedule and usually start my day between 8h and 9h to finish between 16h30 and 18h. On Wednesdays, I finish between 12h and 14h (not working the afternoon).

## Open Source

I created and still maintain [CaptainFact](https://github.com/CaptainFact), an open-source (AGPL3) set of tools for collaborative and real-time fact-checking.

I also maintain a few small libraries for Elixir, a language I really enjoy:

- [Burnex](https://github.com/Betree/burnex), a burner email (temporary address) detector
- [Atomex](https://github.com/Betree/atomex), an RSS/ATOM feed builder with a focus on standards compliance, security and extensibility

## Links

- GitHub: [@betree](https://github.com/betree)
- Twitter (not really active): [@Betree83](https://twitter.com/Betree83)
- Website: https://benjamin.piouffle.com

## Favorite dev tips

### Browser bookmarks to quickly login on `dev`/`staging`

I have these two bookmarks in my browsers that allow me to login in one click on dev, staging and deploy previews (Vercel). Big time saver when you have to switch
environments multiple times per day. Just create a new bookmark and copy/paste the code below in the "URL" field, replacing `YOUR_TOKEN_HERE` with the content of your `localStorage.accessToken` (you need to be logged in with the account you want to save):

```es6
javascript: (function () {
  localStorage.accessToken = "YOUR_TOKEN_HERE";
  window.location.reload();
})();
```

![image](https://user-images.githubusercontent.com/1556356/105514937-5ee7be00-5cd4-11eb-98dc-f9efba5ac5ba.png)

### Commonly used Chrome extensions

While I use Firefox as my main browser, I mostly dev on Chrome. I find these extensions pretty helpful:

- [Smart page ruler](https://chrome.google.com/webstore/detail/smart-page-ruler/nmibbjghlmdiafjolcphdggihcbcedmg): to easily measure things & compare with design
- [Whatfonts](https://chrome.google.com/webstore/detail/whatfont/jabopobgcpjmedljpbcaablpmlmfcogm): to quickly change font styles
- [Grid ruler](https://chrome.google.com/webstore/detail/grid-ruler/joadogiaiabhmggdifljlpkclnpfncmj): mainly to check alignments
- [headingsMap](https://chrome.google.com/webstore/detail/headingsmap/flbjommegcjonpdmenkdiocclhjacmbi): to check titles hierarchy
- [Apollo Client Developer Tools](https://chrome.google.com/webstore/detail/apollo-client-developer-t/jdkknkkbebbapilgoeccciglkfbmbnfm): to see what's in that nasty Apollo cache
- [React Developer Tools](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi)

### Snippet to quickly generate `FormattedMessage`

Working with internationalization can be tedious. This VSCode snippet makes my life easier:

```json
{
  "Formatted Message (react-intl)": {
    "scope": "javascript",
    "prefix": "formatted-message",
    "body": "<FormattedMessage id=\"$TM_FILENAME_BASE.$0\" defaultMessage=\"$1\"/>",
    "description": "Put the given string in a FormattedMessage"
  }
}
```

![Preview](https://user-images.githubusercontent.com/1556356/105513345-79b93300-5cd2-11eb-8a12-eaedfad60402.gif)

### GitHub notifications

I use the following filters to catch up with GH notifications:

#### OC - Followed PRs

Description: Activity on PRs that I follow (as an author, reviewer, assignee or because I was mentioned)

```
repo:opencollective/opencollective-frontend repo:opencollective/opencollective-changelog repo:opencollective/opencollective-api repo:opencollective/opencollective-pdf repo:opencollective/opencollective-bot repo:opencollective/opencollective-taxes repo:opencollective/opencollective-zapier repo:opencollective/opencollective-security repo:opencollective/opencollective-workers is:issue-or-pull-request reason:assign reason:author reason:comment reason:manual reason:mention reason:review-requested reason:team-mention
```

#### OC - Followed issues

Description: Activity on PRs that I follow (as an author, assignee or because I was mentioned)

```
repo:opencollective/opencollective reason:assign reason:author reason:comment reason:mention reason:manual  reason:team-mention
```
