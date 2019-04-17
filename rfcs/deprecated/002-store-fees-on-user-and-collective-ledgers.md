# REQUEST FOR COMMENTS 001 - Store fees on the User & Collective ledgers

## Overview

Every operation of moving funds from one ledger to another is
currently represented as two rows in the `Transactions` table. One to
add up to the Collective ledger (CREDIT) and the other to subtract
from the User's ledger (DEBIT).

Before this change, the fees were only stored in the CREDIT
transaction. Now the fees are stored in both transaction rows as
negative numbers.

The change was applied to all the types of fees:

- Host Fees (`Transaction.hostFeeInHostCurrency` field)
- Platform Fees (`Transactions.platformFeeInHostCurrency` field)
- Payment Processor Fees
  (`Transactions.paymentProcessorFeeInHostCurrency` field)

## Verification

The following operation is being used to validate each transaction
row:

```
netAmountInCollectiveCurrency === Math.round(amountPlusFees * hostCurrencyFxRate)
```

And `amountPlusFees` is:

```
amountPlusFees = (
  amountInHostCurrency +
  hostFeeInHostCurrency +
  platformFeeInHostCurrency +
  paymentProcessorFeeInHostCurrency
);
```

## Use case example

Given a transaction that represents moving \$50 dollars from User to
Collective

### How it was stored

|            | User Ledger | Collective Ledger |
| ---------- | ----------: | ----------------: |
| Type       |       DEBIT |            CREDIT |
| Amount     |       -4075 |              5000 |
| Host Fee   |           0 |               500 |
| Plat Fee   |           0 |               250 |
| PP Fee     |           0 |               175 |
| Net Amount |       -5000 |              4075 |

### How it is stored now

|            | User Ledger | Collective Ledger |
| ---------- | ----------: | ----------------: |
| Type       |       DEBIT |            CREDIT |
| Amount     |       -4075 |              5000 |
| Host Fee   |        -500 |              -500 |
| Plat Fee   |        -250 |              -250 |
| PP Fee     |        -175 |              -175 |
| Net Amount |       -5000 |              4075 |

## Overview of the next step

This was done because fees represent debit from the transaction pair
and a credit in a yet to be created Payment Method ledger, which is a
dependency to create a double entry ledger system that includes User,
Collective, Host, and Payment Method.
