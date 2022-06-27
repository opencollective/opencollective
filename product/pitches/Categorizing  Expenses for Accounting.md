# Campaign: Categorizing Expenses for Accounting

## Origins
This proposal emerged from research into open-source projects hosted by OSC about what can be done to make it easier for corporate funders to fund open-source projects. One of the core needs that were identified was to gradually provide funders with more information about the impact of their investments.

The research included an interview with Nicholas Zakas of the [ESLint project](https://opencollective.com/eslint) who has done rigorous work on tending to corporate funding and has been able to provide the project with reliable and consistent funding. The project recently launched a new website that includes a [donate page](https://eslint.org/donate/) with the following graphic:

![a01](https://github.com/opencollective/opencollective/blob/main/product/pitches/assets/CategorizingExpenses_A01_ESLintExample.png)

During the interview Nicholas expressed a wish to be able to organize their expenses on the platform into these categories in order to be able to produce such a graph directly baed on the actual expenses. **The original intent of this proposal was to embrace this request as an enhancement to expenses that would make this kind of reporting possible for all collectives on the platform based on real data while inheriting from and reinforcing the platform trustworthiness**

![a02](https://github.com/opencollective/opencollective/blob/main/product/pitches/assets/CategorizingExpenses_A02_Aspiration.png)

  *in the above wireframe categorized expenses are aggregated for a selected year, or all years since the beginning of the collective's financial history and the graph mode can be toggled between pie/bar*

## Unexpected Discoveries
The capability that we currently have that approximates this behavior is expense-tags. these are currently used in two ways:
1. As contextual metadata for an expense that different people use in different ways eg:
	1. @nathan track a certain kind of expense for our tax filing, for example, political lobbying spending.
	2. @alina using tags to monitor compliance again certain policies - like cash assistance
	3. @pia collective admins who want to quickly see how much is being spent per category
	4. @pia fiscal host admins, fundraisers or advocates who want to point sponsors to an easy way to show how their dollars are spent
2. As a basis for accounting within fiscal hosts:
	1. @pia we want to know from a budget how much has been spent on engineering, food&bev, events, hardware, etc
	2. @Lauren On the OSC side, this drives the report breakouts in [Metabase](https://opencollective-metabase.herokuapp.com/question/753-osc-expenses-not-inc-platform-fees)
	3. @alanna OCF tags all ops expenses by the accounting code category our accountants use in Quickbooks + accounting tags are valid for accounting, and any other tag can also be present but will be ignored for accountancy coding purposes
	4. @pia fiscal host admins who want to be able to see how much a collective is spending in one category + download the csv and filter by tag to see expenses of an event / category.

Tags are fine when used for contextual metadata but fail when it comes to accounting.

When used as a basis for accounting, tags introduce problems. For accounting purposes each expense needs to be assigned exclusively to one and only one category. Because this is not the case with the current tag implementation, any aggregation of expenses based on tags can provide some information, but not information that is  complete or reliable for accounting purposes:
1. @leo True, tags are not mutually exclusive. But this doesn't necessarily mean it is wrong, just that the sum of the collectives of tags does not correspond to the total of tags.
2. @alanna We use the tag that matches an accounting code and ignore any others. In practice, I manually go through all the ops expenses once a month and make sure each one has at least one, and only one, accounting code tag.
3. @alanna Querying tags in metabase is a disaster so I just don’t do it.


## Redirected (Preparatory) Scope of this Proposal
Given the above discoveries the intended scope of this proposal has been postponed to make way for the preparatory work that is required for it. Instead this scope is redirected towards improving the payments infrastructure by introducing accounting categories:
1. Enable each **collective to create their own accounting categories** in order to document, manage and communicate their expenses in a way that makes sense to them and to their funders.
2. Enable **fiscal hosts to offer an initial set of categories** (that collectives can adapt to their own needs) as guidance to collectives.
3. Enable **each fiscal host to create its own set of accounting categories** and to correlate them to categories used by collectives.
4. Provide **fiscal hosts semi-automated accounting categorizing** by: a) relying on the correlation between collective accounting categories and fiscal host accounting categories; b) enabling fiscal host admins to review and confirm the automated tagging.

The impact of this effort will:
1. Create an accounting infrastructure that will make it possible to achieve the seed intention of this proposal: converting the raw financial data that we accumulate into meaningful reporting for everyone involved (collectives, funders and fiscal hosts).
2. Enable collectives to better manage their finances (and in the future to easily report to funders).
3. Establish a reliable accounting infrastructure in the platform that will make it easier for fiscal host admins to interface and reconcile with accounting systems.
4. Ease the workload of fiscal host admins that are currently doing a lot of manual labor within an implementation that introduced uncertainty and vulnerabilities.
5. Create a potential for more detailed and reliable reporting through Metabase.
6. Retain tags as a meta-data layer that can continue to be used as is and perhaps refined in the future. 

##  Excluded from the Scope of this Proposal

Given the discovered expanded scope of this proposal it excludes the following:
1. Implementing graphic visualizations on collective pages based of categorized expense charts (this will be tended to in future proposals that will be aligned and timed with an overhaul of profile page and specifically of collective profile pages).
2. Any additional administrative features required to create such graphic visualizations (such as color-coding categories within collectives).
3. Integrating data at a platform level of accounting by aggregating information from all fiscal hosts. The potential and value of this will become more clear once fiscal host accounting is implemented and adopted.

## Scopes
The scopes are presented here in a narrative sequence that lends itself to understanding the campaign as a whole. The implementation sequence may be different:

1. Establishing accounting categories for fiscal hosts.
2. Fiscal hosts create default expense categories for hosted collectives.
3. Collectives shape their own  expense categories.
4. Collective administrators categorize approved expenses.
5. Fiscal host adminstrators set accounting categories for approved expenses.
6. Increased efficiency by linking fiscal host accounting categories with collective expense categories. 


### Scope1: Fiscal Host Accounting Categories
Enable a fiscal host admin to setup accounting categories for expenses:

![b01](https://github.com/opencollective/opencollective/blob/main/product/pitches/assets/CategorizingExpenses_B01_FiscalHost_AccountingCategories.png)

*hamburger menu button gives access to additional operations such as delete and assignment to collective expense categories (described below)*

### Scope2: Fiscal Host Default Expense Categories for Collectives
Enable a fiscal host to:
1. create a default/recommended set of categories for its hosted collectives 
2. and to associate the default collective categories with the fiscal host accounting categories.

![b02](https://github.com/opencollective/opencollective/blob/main/product/pitches/assets/CategorizingExpenses_B02_FiscalHost_DefaultCollectiveCategories.png)

This suggested list can be modified freely even after it has been used by collectives since each collective has an independently managed set of categories (collectives can choose which categories they wish to use, ignore other categories and create their own categories).

### Scope3: Collective  Expense Categories
Each collective can choose which categories they wish to use, they can rename categories and add their own categories. 

![b03](https://github.com/opencollective/opencollective/blob/main/product/pitches/assets/CategorizingExpenses_B03_Collective_CustomizedExpenseCategories.png)

In the future there may be an option to add default colors to each category (for charting purposes) that inherits defaults from the fiscal host global definitions andcan be modified by collective admins.

### Scope4:  Collective Admins Categorize Expenses
Collective admins need to be able to assign an expense to an expense category. A minimal implementation for this is to add a collective expense category selection field in existing expense flows (when a collective admin approves an expense). 

However there are two other usage scenarios that introdue a UI pattern that may have numerous uses:
1. A monthly (or periodic) categorization of expenses - this can be to catch expenses that were not categorized or to re-organize expenses if their context has changed. 
2. Tending to historic expenses (all expenses that have accumulated in a collective and have not been properly categorized). This may also be useful if collective categories are changed (eg: add a new category) and there is a wish to review/reorganize historic expenses.

#### Assigning Expenses to Categories
A list of expenses can be filtered by status (all/unassigned/assigned) and date range (current month, previous month, selection of past months, date range) and each expense can be assigned to the collectivei expense category.

![b04](https://github.com/opencollective/opencollective/blob/main/product/pitches/assets/CategorizingExpenses_B04_Collective_AssignExpenses.png)

#### Assist Mode: Categorizing a History of Expenses
When assist mode is active, an interface is activated to help the collective admin effectively sort historically unassigned expenses. This will be a crucial features when expense categorization is first rolled out. 

In assist mode, when an unassigned expense is placed into an expense category, an assistive modal interface surfaces "similar expenses" that can also be added to the selected category. Similar expenses can be expenses submitted by the same person and an amount that has a similar order-of-magnitude (eg a $200 payment will bring up other payments that are  in the hundreds of dollars) or, if there are already tags, that have the same tag.

![b05](https://github.com/opencollective/opencollective/blob/main/product/pitches/assets/CategorizingExpenses_B05_Collective_AssignExpenses_Assist.png)

In the future, if necessary and justified, assist capability can be expanded to allow re-assignment of expenses from one category to another: when one expense is moved, the assist interface can suggest moving other expenses from the category.

### Scope5: Fiscal Host Admin Set Accounting Categories for Expenses
At the end of every fiscal month a fiscal host admin reviews all the expenses from all hosted collectives and assigns them to accounting categories. A minimal implementation for this is to add a fiscal host expense category selection field in existing expense flows. 

However, fiscal hosts require an additional review process due to:
1. The legal and fiscal accountability requirements (and interfacing with external accoutants).
2. The fact that numerous fiscal host admins may be performing the day-to-day categorizing (as expenses are approved and paid) and that there may be one person who does a comprehensive monthly review to ensure an overall integrity and accountability.

Here, one person (a fiscal host admin) reviews all monthly expenses and either confirms the already assigned accounting categories or reassigns to correct accounting categories.:

![b06](https://github.com/opencollective/opencollective/blob/main/product/pitches/assets/CategorizingExpenses_B06_FiscalHost_AssignExpenses.png)

If the list is filtered to show only unreviewed expenses and the checklist is auto-saving, then this UI will act as a checklist and expenses will disappear off the screen until the review work is done. 


### Scope6: Linking Fiscal Host Accounting Categories to Collective Expense Categories

This efforts fiscal host admins need to make in order to categorize expenses can be somewhat alleviated  with partial automation. 

The categories that a fiscal host uses are separate and isolated from the considerations that dictate collective category expenses. However by linking collective categories to fiscal host categories, default fiscal host categories can be assigned to expenses when they are submitted. 

There are three pathways to establishing links between fiscal host accounting categories and collective expense categories:
1. Through a primary and dedicated fisal host user interface.
2. Tweaking through the fiscal host accounting categories UI.
3. Encountering new expense categories created by collectives while reviewing expenses.


#### 1: Dedicated Fiscal Host User Interface 
Here a fiscal host admin can review all collective expense categories and link them to accounting categories. 

![b07](https://github.com/opencollective/opencollective/blob/main/product/pitches/assets/CategorizingExpenses_B07_FiscalHost_Linking_Basic.png)

*The list can be filtered to show unassigned expense categories (that have been created or modified by collective admins) so that they can be linked to accounting categories.*

#### 2: Tweaking via Accounting Categories
Here a fiscal host admin can edit an accounting category and review which expense categories have been assigned to it (default categories created by the fiscal host and additional categories created by collective admins). The fiscal host can remove expense categories or move them to another accounting category:

!b08](https://github.com/opencollective/opencollective/blob/main/product/pitches/assets/CategorizingExpenses_B08_FiscalHost_Linking_ViaCategories.png)

*this wireframe is displayed as a modal (accessed through the hamburger menu) on top of the accountinc category interface described in scope1 - however it can also be designed to be in-line by showing expanded information onthe main page for a selected accounting category.*

#### 3: Encountering New Collective Expense Categories 
A fiscal host administrator who reviews expenses and categorizes them for accounting (see scope 5) may encounter a collective expense category that is not linked to an accounting category.   

When such an expense is assigned to an accounting category the fiscal host admin is prompted and given an option to link the expense category to the accounting category:

![b09](https://github.com/opencollective/opencollective/blob/main/product/pitches/assets/CategorizingExpenses_B07_FiscalHost_Linking_InlineExpenses.png)
