# Funder Basic Dashboard 

## Background & Context

This proposal emerged from research into open-source projects hosted by OSC about what can be done to make it easier for corporate funders to fund open-source projects. 

One of the challenges that open-source funders (inside corporations) encounter is how to relate to their "investment portfolio" - the entirety of their funding to many open-source projects. There are a few notable aspects to this challenge:
1. Current scale - currently (within current funding levels) organizational funding reaches typically tens of open-source projects (in some rare cases this may cross over into the low hundreds).
2. Future scale - the number of dependencies within organizations can be one or two orders of magnitude larger - thousands of direct depencies. That can grow by anothe rorder of magnitude if it includes deeper dependencies (depencies on depenencies). 
3. Coverage - the open-source collectives that are hosted on the platform and through OSC are a subset of the world of open-source (and since it is difficult to measure "open source" as a whole it is difficult to assess what coverage we do have). 
4. Other Funding Channels - OpenCollective is one of numerous funding channels (eg. GitHub Sponors & Tidelift) and typically funders utilize numerous channels.

All this is to say that from a funders perspective, any funding overview tools we provide on the platform are going to be, by definition, incomplete. 

However, currently NO ONE is addressing this need (aside from spreadhsheets or in rare cases internally developed tools) and funders I have spoken to have spoken about this need. 

## Appetite

This pitch is offered as a large (4 week) project.


## Proposal

This proposal is to provide open-source funders on Open Collective with a basic dashboard experience that gives them an overview of their funding efforts and strategy. It is reliant primarily on information that we already have on the platform. 

### Basic Dashboard

![FundingDashboard_Basic](https://user-images.githubusercontent.com/8337819/179219798-73b7fb22-e2f0-4fe1-9945-4b82d05cac97.png)


The dashboard provides a funder with information aggregated per collective (~open-source project):
1. The open-source ecosystem with which the collective is associated.
2. An "investment category" that can be modified by the funder.
3. The total amount of money the funder has contributed to this collective.
4. The most recent monthly-recurring contribution. 
	1. If there is a current recurring contribution than it is shown. 
	2. If there isn't an active recurring contribution but there was a recurring contribution that is no longer
	3. If there isn't and never was a recurring contribution than nothing is displayed
5. The total amount of money that the collective has raised during the last 30 days with a trend indicator of how it has changed relative to the previous 30 days.
6. The total amount of money that the collective has spend during the last 30 days with a trend indicator of how that changed relative to the previous 30 days.
7. A yearly goal indicator:
	1. If the collective has a yearly goal, what percentage of it has beem met.
	2. If the collective does not have a yearly goal nothing is displayed.

An aggregate ot total and current recurring expenses is also shown.

### Investment Categories
The funder can assign collectives to investment categories as a most basic way of both interacting with the information and for giving the tool funder-specific context and usability. Investment categories are a gesture towards being able to manage and organize contributions to form some kind of strategy. 

In future iterations we may explore evolving and expanding the ability to formulate, express and manage a strategy for contributing to open-source.

### Filters
![FundingDashboard_Basic_Filters](https://user-images.githubusercontent.com/8337819/179219871-44f85b72-c712-4ec5-af1e-1c12d6b3adc3.png)


The dashboard can be filtered by:
1. Time - all contributions / selected year
2. Ecosystem 
3. Investment category
4. All contributions / one-time only / recurring-only


### Grouping

The dashboard can also be grouped by ecosystem or investment category:
![FundingDashboard_Basic_Grouped](https://user-images.githubusercontent.com/8337819/179219909-877d082b-79cf-4a43-878d-9ec1a0bc9751.png)


When group-by is activated intermediate summaries are also presented. 

### Collapse Collective
![FundingDashboard_Basic_Collapsed](https://user-images.githubusercontent.com/8337819/179219945-67a9f4bf-8519-4e51-b434-74473e002d40.png)


A collective can be collapsed to show more detailed information. The collapsed area has two sections:
1. The section on the left shows the details of contributions made to the collective. It includes both one-time and recurring contributions on an integrated timelilne.
2. The section on the right communicates "my part in the whole" - it shows me what part my contribution plays in the overall funding of the collective. I can switch between viewing this across all contributions, one time contributions, current recurring contributions and past (no longer active) recurring contributions.


### Integration in the Platform UI
This proposal has been formed with OSC funders in mind. However, it can be useful at the platform level for other funders (with the exception of the Ecosystem field which is unique to open-source - but possibly also useful in other funder contexts).

Initially this should be rolled out in the admin-section of collectives and organizations who handle and contribute funds. For now, this is NOT a public facing feature.

## Challenges & Open Questions
1. Will this interface make sense if it shows up for organizations/collectives who do not make contributions? If not how should this be mitigated?
2. Performance - how to implement this so that the user interface is fluent, responsive and usable?
3. How do we populate the "ecosystem" field?


## Future Potentials 

All of the following potentials are outside the scope of this proposal. They are presented here to:
1. Give the design and engineering teams context about where this can go.
2. Communicate the potential impact and value of this investment in the context or prioritization.


### UI Enhancements
1. Clicking on financial pieces of information for expanded information.
2. Clicking on financial pieces of information as links that transport the user directly into a collective ledger to view detailed transactions.

### Open Source Collective Strategic Potentials
Within the context of OSC (and depending on how the basic dashboard will be received) we can currently identify some strategic future potentials: 
1. Impact Reporting - as we work to enhance and expand the information that open-source projects make available to funders, this tool may become a foundation for collecting and integrating impact-related information and using it to generate impact reports (that allies of open-source in the corporate world can utilize in their funding efforts within their organizations).
2. Manuall Adding Off-Platform funding - enabling funders to use this dashboard to manage open-source contributions that are executed on other platforms by manually adding contributions - enabling them to use this for a more whole view of their contributions to open-source (this partially tends to the "coverage" challenge mentioned in the context section of this pitch).
3. Importing Contributions - the same, but automated and in larger numbers.
4. Full Dependency Set - there is a potential path that this tool expands to the point where open-source funders can manage their full dependency set. This is a major shift from tens of contributions to thousands. There are many unknowns on the way to this potential. 
5. Open-Source Project Dependency Fuding - there is a conversation in open-source around projects directly funding their own dependencies (which often do not have access to funding because they are not directly used by funders). This dashboard may come into play should we invest in making it possible for open-source projects to fund their dependencies. 
6. Summoning Open-Source projects - there is a potential for this to become a mechanism for inviting in open-source project that are not currently on the platform. If funders elect to use this tool to manage off-platform funding they may be motivated to ask off-platform open-source projects to come to the platform to receive funding ... and we may be motivated to help them do so. 


### OC Strategic Potentials
The challenges of managing funds, investment strategies, and impact reporting are issues for funders beyond open-source.  Investing in fund-management tools that address challenges in these domains may make the OC platform more appealing for funders and may support fiscal hosts in inviting funders onto the platform. 


