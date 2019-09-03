# Misused JWT secret

## Summary

We rely on JWT tokens for our authentication system. We recently discovered a legacy [code snippet](https://github.com/opencollective/opencollective-api/blob/0c2aaa25f41122c3b4e30b1aa739d9bf97bdf6d9/server/lib/email.js#L60-L64) that was
putting our JWT secret (that is basically the key of the authentication mechanism) in a MD5-encoded hash,
next to predictable variables, making it theoretically _possible_ to locally bruteforce the secret.

**To reproduce**

- I know that my unsubscribe token is generated with `${email}.${slug}.${type}.${jwtSecret}`
- I know `email`, `slug` and `type`
- I know the final token
- So I can bruteforce until:

```es6
md5(`my@email.com.my-collective.all.${generateJWT()}`) === token;
```

**Cost of a bruteforce attack**

Though theoretically possible, a bruteforce attack would have been actually impossible in practice because our JWT secret is more than 512bit. Let's make a quick estimation with a 60 characters key (we use something longer than that) -let's assume that the attacker knows the exact length of our secret key- with alphanum (62 characters):

> nb_possibilities = 62 ^ 60 = 3,495436122×10¹⁰⁷

Assuming that you have access to some solid hardware that can compute 10 billion hashs per seconds, it would still require:

> 3,495436122×10¹⁰⁷ / 10000000000 / 60 / 60 / 24 / 365 = 1,1084×10⁹⁰ years

## Impact

Based on the previous results we estimated that it's impossible that anyone, even given a period of multiple
months or years (the key was less than 6 months old) and extremely sophisticated hardware may have cracked our JWT secret. Our analysis is that **no one was impacted by this issue**.

## Timeline

(Paris, UTC+1)

- **2019-06-17 14:00**:
  Issue is discovered and reported internally. It gets properly documented but we decide not to prioritize it because there's not exploit possible.
- **2019-08-28 15:40**:
  A user report the issue to us by email along with other recommendations to better secure our JWT authentication. We confirm the reception 45 minutes after.
- **2019-08-28 16:30**:
  We review the report and categorize all issues.
- **2019-08-29/30**:
  Engineering team makes deeper analysis and prepares a reply for reporter.
- **2019-08-30 19:00**:
  First PR to mitigate the issue by separating `JWT_SECRET` from `EMAIL_UNSUBSCRIBE_SECRET`: https://github.com/opencollective/opencollective-api/pull/2482
- **2019-09-03 12:00**:
  A second PR is deployed with a few security enhancements: https://github.com/opencollective/opencollective-api/pull/2503. JWT secret is rotated, invalidating all authentication tokens generated before this time.

## Root Cause

- Misuse of JWT secret in a place where it had nothing to do.
- Hashing with a weak algorithm (MD5).

## Resolution

- **API**: Separating `JWT_SECRET` from `EMAIL_UNSUBSCRIBE_SECRET`
- **API**: Rotating JWT secret - We've decided to rotate our secret anyway to ensure that the issue will never be exploitable in the future.

## Next steps

Our priority was to secure the JWT secret. While we still generate an MD5 hash for the email unsubscribe token, we don't see it as a priority because:

- There's no exploit currently feasible that would allow to crack the token.
- The potential impact of cracking emails unsubscribe links is lower.

We've however created [an issue](https://github.com/opencollective/opencollective/issues/2392) to improve this behavior in the mid-term.

## What went well?

- Ability to invalidate tokens by rotating JWT secret.
- Fast communication / analysis and decision making processes.
- The (not merged yet) [security policy](https://github.com/opencollective/opencollective/pull/2235) gave us a framework to organize the different steps following the report. It was a good opportunity to try it.
