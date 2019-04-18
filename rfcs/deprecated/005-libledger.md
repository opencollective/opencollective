# REQUEST FOR COMMENTS 005 - API to interact with the ledger

## Example Transaction

All the code snippets shown in this document will reference the
following example transaction:

|             from |               to |   hostId |   type | amount | currency | fromAmount | fromCurrency | fromCurrencyRate |
| ---------------: | ---------------: | -------: | -----: | -----: | -------: | ---------: | -----------: | ---------------: |
|             User |       Collective | USD-HOST |  DEBIT |  -5000 |      USD |     -92150 |          MXN |          0.05426 |
|       Collective |             User | USD-HOST | CREDIT |  +5000 |      USD |     +92150 |          MXN |          0.05426 |
|       Collective |             Host | USD-HOST |  DEBIT |   -500 |      USD |            |              |                  |
|             Host |       Collective | USD-HOST | CREDIT |   +500 |      USD |            |              |                  |
|       Collective |         Platform | USD-HOST |  DEBIT |   -250 |      USD |            |              |                  |
|         Platform |       Collective | USD-HOST | CREDIT |   +250 |      USD |            |              |                  |
|       Collective | Payment Provider | USD-HOST |  DEBIT |   -175 |      USD |            |              |                  |
| Payment Provider |       Collective | USD-HOST | CREDIT |   +175 |      USD |            |              |                  |

## Ledger API (`lib/ledger.js`)

The Ledger API provides the following tools:

- `Promise<Array<models.Transaction>> rows(string transactionGroup)`

  Return an array of transactions in the same group (from the same
  charge).

  ```javascript
  > await libledger.rows('d3e36baa-69a2-4f6e-ac44-f93981e51c97')
  [
    { fromCollective: 10165, collective: 90000, amount: -5000... }, // from User to Payment Provider
    { fromCollective: 90000, collective: 1, amount: 250... },       // from Payment Provider to Platform
    { fromCollective: 90000, collective: 11004, amount: 4575... },  // from Payment Provider to Host
    { fromCollective: 11004, collective: 58, amount: 4325... },     // from Host to Collective
  ]
  ```

- `Promise<Object> summary(Array<Transaction> transactions)`

  Return an object describing all the rows related to a single
  transaction.

  ```javascript
  > libledger.summary(await libledger.rows('d3e36baa-69a2-4f6e-ac44-f93981e51c97'))
  { usd: { user: -5000, collective: 4075, host: 500, platform: 250, paymentProvider: 175 } }
  ```

- `Promise<Object> fees(Array<Transaction> transactions)`

  Return an `Object` with keys containing the names of the fees and
  their respective values.

  ```javascript
  > libledger.fees(await libledger.rows('d3e36baa-69a2-4f6e-ac44-f93981e51c97'))
  { usd: { platform: -25, host: -25, paymentProvider: -45 } }
  ```

- `number balance(number collectiveId, Array<Transaction> transactions)`

  Return the balance of the transaction for a given collective.

  ```javascript
  > const rows = await libledger.rows('d3e36baa-69a2-4f6e-ac44-f93981e51c97');
  > libledger.balance(userCollective.id, rows);
  -5000
  ```

- `string formattedBalance(number collectiveId, Array<Transaction> transactions)`

  Return output of `balance()` with currency identifier.

  ```javascript
  > const rows = await libledger.rows('d3e36baa-69a2-4f6e-ac44-f93981e51c97');
  > libledger.formattedBalance(userCollective.id, rows);
  '-5000 USD'
  ```

- `number balanceFromCurrency(number collectiveId, Array<Transaction> transactions)`

  Return the same as `balance(collectiveId, transactions)` for
  transactions between the same currency. Otherwise, it returns the
  amount in the original currency of the purchase (`fromAmount * fromCurrencyRate`) with the currency identifier concatenated.

  ```javascript
  > const rows = await libledger.rows('d3e36baa-69a2-4f6e-ac44-f93981e51c97');
  > libledger.balanceFromCurrency(userCollective.id, rows);
  -92150
  ```

- `string formattedBalanceFromCurrency(number collectiveId, Array<Transaction> transactions)`

  Return output of `balanceFromCurrency()` with currency identifier.

  ```javascript
  > const rows = await libledger.rows('d3e36baa-69a2-4f6e-ac44-f93981e51c97');
  > libledger.balanceFromCurrency(userCollective.id, rows);
  '-92150 MXN'
  ```

- `Promise<Object> accumulatedBalance(number collectiveId)`

  Return the amount of funds for each currency ledger of a given
  collective.

  ```javascript
  > await libledger.accumulatedBalance(collective.id)
  4325
  ```

- `Promise<Object> accumulatedHostBalance(number hostCollectiveId)`

  Return the amount of funds of all the collectives hosted by
  `hostCollectiveId`.

  ```javascript
  > await libledger.accumulatedHostBalance(collective.id)
  1044325
  ```
