# REQUEST FOR COMMENTS 004 - Multi Currency v2.0

## Overview

There's currently a bug in the way we process transactions involving
multiple currencies. More specifically, the problem happens when the
host currency is different from the collective currency. In that
situation the system converts the amount from the user's currency to
the collective's currency but stores it host currency.

## Goals

1. Store amounts in Host Currency
2. Define storage for ledger
3. Document where currency conversion happens
4. Multi Wallets

### Store amounts in Host Currency

The host is the entity that stores money in their bank account. The
collective's currency should stop being used in currency conversions
and should be used only for display purposes.

If a Collective changes to a different host, the old transactions
won't be changed. They will still reference the old host. That's
important to keep the historical information. A new transaction will
be created between the two Collectives to reflect the transfer.

#### Use case example (Order)

Given a transaction that represents moving \$50 USD from User to
Collective with 5% of platform fee, 10% of host fee and 2.9%+30c of
payment processor fee and the Host account receiving it is in MXN and
the exchange rate is 1 USD to 18.43 MXN.

##### How it is currently stored

Collective Ledger (CREDIT)

- **amount**: Store the value in the received currency (USD)
- **amountInHostCurrency**: Store the amount converted to the Host
  currency (MXN)
- **netAmountInCollectiveCurrency**: Store the amount in the
  Collective currency (which could be different from the Host & the
  User).
- **hostCurrencyFxRate**: Store the rate between the **amount** and
  **amountInHostCurrency**.

##### How it should look like after this change

To document the purchase of an amount of a different currency, the
following changes are necessary:

The following fields will be renamed

- **amountInHostCurrency** replaced by **amount**
- **hostCurrency** replaced by **currency**
- **hostCurrencyFxRate** deleted

- **fromAmount** store the amount in the original currency
- **fromCurrency** store the original currency
- **fromCurrencyRate** store the rate between **fromAmount** and **amount**

And the following fields are going to be deleted:

- **netAmountInCollectiveCurrency**

Here's how a transaction of a user donating 921.50 MXN to a host in
USD with the rate of ~0.05.

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

The following expression is always true for all the rows:

```javascript
amount == fromAmount * fromCurrencyRate;
```

A helper will be added to the `libledger` to retrieving the value in the original currency:

```javascript
> const rows = await libledger.rows('d3e36baa-69a2-4f6e-ac44-f93981e51c97');
> libledger.formattedBalanceFromCurrency(userCollective.id, rows);
'-92150 MXN'
> libledger.formattedBalanceFromCurrency(collective.id, rows);
'92150 MXN'
```

### Where currency conversion happens

Stripe's policy on multi-currency

- If there is a bank account for that currency, no conversion occurs
- If there are multiple bank accounts available for a given currency,
  Stripe uses the one set as =default_for_currency=
- If there is not a bank account for that currency, we automatically
  convert those funds to your default currency

PayPal's Policy on multi-currency

- ??

### Multi Wallets

### Use Cases

#### Donation to the `USD` wallet in `USD`

##### Transaction

|             from |               to |   hostId |   type | amount | currency | fromAmount | fromCurrency | fromCurrencyRate |
| ---------------: | ---------------: | -------: | -----: | -----: | -------: | ---------: | -----------: | ---------------: |
|             User |       Collective | USD-HOST |  DEBIT |  -5000 |      USD |            |              |                  |
|       Collective |             User | USD-HOST | CREDIT |  +5000 |      USD |            |              |                  |
|       Collective |             Host | USD-HOST |  DEBIT |   -500 |      USD |            |              |                  |
|             Host |       Collective | USD-HOST | CREDIT |   +500 |      USD |            |              |                  |
|       Collective |         Platform | USD-HOST |  DEBIT |   -250 |      USD |            |              |                  |
|         Platform |       Collective | USD-HOST | CREDIT |   +250 |      USD |            |              |                  |
|       Collective | Payment Provider | USD-HOST |  DEBIT |   -175 |      USD |            |              |                  |
| Payment Provider |       Collective | USD-HOST | CREDIT |   +175 |      USD |            |              |                  |

##### Balance

|      User | Collective |     Host | Platform | Payment Provider |
| --------: | ---------: | -------: | -------: | ---------------: |
| -5000 USD |  +4075 USD | +500 USD | +250 USD |         +175 USD |

#### Donation to the `USD` wallet in `MXN`

This one is almost the same as the above. The exception is that the
fields **fromAmount**, **fromCurrency** and **fromCurrencyRate** will
be filled in with the meta data about the original amount of `MXN`
used to buy that amount of `USD`.

##### Transaction

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

##### Balance

|                 User |           Collective |     Host | Platform | Payment Provider |
| -------------------: | -------------------: | -------: | -------: | ---------------: |
| -5000 USD/-92150 MXN | +4075 USD/+92150 MXN | +500 USD | +250 USD |         +175 USD |

#### Donation to the `MXN` wallet in `MXN` but fees in `USD`

|             from |               to |   hostId |   type | amount | currency | fromAmount | fromCurrency | fromCurrencyRate |
| ---------------: | ---------------: | -------: | -----: | -----: | -------: | ---------: | -----------: | ---------------: |
|             User |       Collective | MXN-HOST |  DEBIT | -92150 |      MXN |            |              |                  |
|       Collective |             User | MXN-HOST | CREDIT | +92150 |      MXN |            |              |                  |
|       Collective |             Host | MXN-HOST |  DEBIT |  -9215 |      MXN |       -500 |          USD |            18.43 |
|             Host |       Collective | MXN-HOST | CREDIT |  +9215 |      MXN |       +500 |          USD |            18.43 |
|       Collective |         Platform | MXN-HOST |  DEBIT |  -4608 |      MXN |       -250 |          USD |            18.43 |
|         Platform |       Collective | MXN-HOST | CREDIT |  +4608 |      MXN |       +250 |          USD |            18.43 |
|       Collective | Payment Provider | MXN-HOST |  DEBIT |  -2702 |      MXN |       -175 |          USD |            18.43 |
| Payment Provider |       Collective | MXN-HOST | CREDIT |  +2702 |      MXN |       +175 |          USD |            18.43 |

##### Balance

|       User |           Collective |     Host | Platform | Payment Provider |
| ---------: | -------------------: | -------: | -------: | ---------------: |
| -92150 MXN | +4075 USD/+92150 MXN | +500 USD | +250 USD |         +175 USD |
