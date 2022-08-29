# Funder Basic Dashboard 

## Background & Context

This proposal emerged from research into open source projects hosted by OSC about what can be done to make it easier for corporate funders to fund open-source projects. 

One of the challenges that corporate open-source funders encounter is how to relate to their "investment portfolio" - the entirety of their funding to many open-source projects. There are a few notable aspects to this challenge:
1. Current scale - within current funding levels, organizational funding reaches typically tens of open-source projects (in some rare cases this may cross over into the low hundreds).
2. Future scale - the number of dependencies within organizations can be one or two orders of magnitude larger - thousands of direct dependencies. That number can grow by another order of magnitude (or more) if it includes transitive dependencies (dependencies on dependenncies). 
3. Coverage - the open-source collectives that are hosted on the platform and through OSC are a subset of "the world of open-source" and since it is difficult to measure "the world of open source" as a whole it is difficult to assess what coverage we do have. 
4. Other Funding Channels - OpenCollective is one of numerous funding channels (eg. GitHub Sponors & Tidelift) and typically funders utilize numerous channels.

All this is to say that from a funders perspective, any funding overview tools we provide on the Open Collective platform are going to be, by definition, incomplete (at least initially). 

However, currently NO ONE is addressing this need (aside from spreadhsheets or in some cases internally developed tools) and funders I have spoken to have spoken about this need. 

## Appetite

This pitch is offered as a large (4 week) project.


## Proposal

This proposal is an MVP created as a low cost (and correspondingly, at least initially, moderate impact) tool **based primarily on data that is already available on the platform**. It does however serve as a gravitational center that will expand as we advance on the OSC product roadmap. Ultimately it is designed to become a tool where funders can formulate, execute and monitor the impact of their funding strategy.  

### Basic Dashboard

#### Open Source Collective Example
![funders_dashboard_osc_02a](https://user-images.githubusercontent.com/8337819/185387962-3e1e06d6-e6f8-4790-b790-1abe53a2586d.jpg)


#### Open Collective Foundation Example
![funders_dashboard_ocf_02a](https://user-images.githubusercontent.com/8337819/185388003-41019de9-d6bc-41c6-b35c-fb1559197809.jpg)


The dashboard provides a funder with information aggregated per collective (~open-source project):
1. A set of icons that indicate relationship with the collective (the possible relationships may be expanded/elaborated over time)
	1. Funding - a collective to which the funder has given / is giving funding.
	2. Following - a collective that the funder is watching but has not yet funded.
	3. Contributing - a collective to which the funder is contributing other resources (not funding). 
2. An "investment category" that can be modified by the funder to group collectives into meaningful (to the funder) funding contexts.
3. The total amount of money the funder has contributed to this collective.
4. The most recent monthly-recurring contribution with an indicator if there is currently an active recurring contribution.
	1. If there is a current recurring contribution than it is shown. 
	2. If there isn't an active recurring contribution but there was a recurring contribution (that is no longer active) then it is shown.
	3. If there isn't and never was a recurring contribution then nothing is displayed
5. The total amount of money that the collective has raised during the last 30 days with a trend indicator of how it has changed relative to the yearly (last 365 days) average.
6. The total amount of money that the collective has spent during the last 30 days with a trend indicator of how that changed relative to the yearly (last 365 days) average.
7. A yearly goal indicator:
	1. If the collective has a yearly goal, what percentage of it has beem met.
	2. If the collective does not have a yearly goal nothing is displayed.

An aggregate ot total and current recurring contributions is also shown.

### Investment Categories
A funder can assign collectives to investment categories as a basic way of both interacting with the information and for giving the tool funder-specific context. Investment categories are an initial gesture towards being able to manage and organize contributions to formulate, execute and monitor a funding strategy (that will be explored in future product iterations). 

### Filters
![funders_dashboard_filtered_02a](https://user-images.githubusercontent.com/8337819/185388103-67662ef3-af73-4e6e-b905-8cc596559d10.jpg)


The dashboard can be filtered by:
1. Year - all contributions / selected year
2. Investment category
3. Funding - All contributions / one-time only / recurring-only
4. Relationship - funding / following / supported (non-funding)


### Grouping

The dashboard can also be grouped by investment category or relationship:
![funders_dashboard_grouped_02a](https://user-images.githubusercontent.com/8337819/185388154-66201678-872f-4e9d-8572-de6a7862effd.jpg)


When grouping is activated intermediate summaries are also presented. 

### Expand Collective

A collective can be clicked to show more detailed information.

The first view that is offered is a detailed list of funding contributions to the collective.
![funders_dashboard_modal_myfundinghistory_02a](https://user-images.githubusercontent.com/8337819/185388245-7bde36ae-510a-4c0e-9441-80dbb32fe3af.jpg)


The second view shows all the historical funding the collective has received with an added emphasis on the funder's contribution relative to all other contributions. 
![funders_dashboard_modal_allfundinghistory_02a](https://user-images.githubusercontent.com/8337819/185388277-98723362-ba6b-4721-a86f-f42326a6f86e.jpg)

This modal view can gradually be populated with more information/context to support the effort to formulate and perceive a funding strategy.

### Integration in the Platform 
Initially this should be rolled out in the admin-section of collectives, funds and organizations who handle and contribute funds. For now, this is NOT a public facing feature.

## Challenges & Open Questions
1. Should this interface be hidden from  organizations/collectives who do not make contributions? 


## Future Potentials 

The following are list of potential capabilities that may be incorporated into the dashboard. They are briefly presented here to communicate the potential impact and value of making this investment in the platform. They are not included in the scope of this proposal, but they do offer insight into how this dashboard can evolve over time.


### UI Enhancements
1. Hovering in place on financial pieces of information for expanded information/context.
2. From hovering modals, introducing links that transport the user directly into a collective ledger to view detailed historical transactions.

### Open Source Collective Strategic Potentials
Within the context of OSC (and depending on how the basic dashboard will be received) we can currently identify some strategic future potentials: 
1. Impact Reporting - as we work to enhance and expand the information that open-source projects make available to funders, this tool may become a foundation for collecting and integrating impact-related information and using it to generate impact reports (that allies of open-source in the corporate world can utilize in their funding efforts within their organizations).
2. Manually Adding Off-Platform funding - enabling funders to use this dashboard to manage open-source contributions that are executed off-platform by manually adding contributions - enabling the funders to use this interface for a more whole view of their "investment portfolios" in open-source (this may partially tend to the "coverage" challenge mentioned in the context section of this pitch).
3. Full Dependency Set - there is a potential path that this tool expands to the point where open-source funders can uploads their full dependency sets. This is a major shift from tens of contributions to potentially thousands and will come with additional strategizing tools.
4. Open-Source Dependency Revenue Sharing - if OC implements tools for revenue sharing between open source projects (to dependencies) this can be indicated on this dashboard & the dashboard itself may become useful for the open source collectives themselves (to monitor, as funders can, their own conributions to open-source).  
5. Summoning Open-Source projects - there is a potential for this to become a mechanism for inviting onto the Open Collective platform open-source project that are not currently on the platform. If funders elect to use this tool to manage off-platform funding they may be motivated to ask off-platform open-source projects to come to the platform to receive and transparently utilize funding ... and we may be motivated to help them do so.
6. Work attribution - We are contemplating a mechanism for submitting work attributions (code and non-code) that goes into open-source projects. While this is primarily targeted at the open-source projects themselves it can impact funders in two ways. First, it may reveal information about unfunded work that goes into open source projects that should be funded. Second, it enables funders to also express their own non-funding contributions to open-source (dedicated employees, events, computing resources, etc.) ... and this too can be integrated into the dashboard and overall funding strategy.
7. Employee Managed Funds - we are contemplating a capability for funders to allocate funds that employees (or small teams) can distribute independently to open source projects they value. Those contributions can also be integrated into this dashboard. 


### Open Collective Strategic Potentials
The challenges of managing funds, investment strategies, and impact reporting are issues for funders beyond open-source.  Investing in fund-management tools that address challenges in these domains may make the OC platform more appealing for funders and may support fiscal hosts in inviting funders onto the platform. 


