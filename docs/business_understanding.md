# Business Understanding

## The Business Objectives

It is essential to first thoroughly understand what the customer really wants to accomplish. From a productivity standpoint, this implies that with a well defined goal, it is easy to go searching for the correct questions and, as follows, the correct answers. As such, there are a few key aspects to take in consideration when first handling this project.

### Customer Background

In this project, we are dealing with a banking company. The bank managers wish to improve the services of their bank, and make better decisions alongside it, improving customer satisfaction. This not only drives profits for the bank, but good clients can be rewarded more often, leading them to visit the bank even more.

The most pressing issue is that the bank cannot tell with reasonable certainty who is a good client and who is not. This is important, for example, when issuing loans, as they need to be paid back to make it a sound business decision. When issuing loans to the wrong people, there are a load of problems associated that a bank would rather avoid altogether in the first place.

### Business objectives

The first and most important goal is to reliably distinguish between a good and a bad client. With this in mind, a more concrete statement that the bank wishes to be fulfilled is the prediction of wether some loans will end up successfuly or not.

Ideally, the bank would not lose a single customer with this new system, but it is very likely that customers identified as bad can be drawn away from visiting the service, as their loan requests would be denied.

While the bank did not present any success criteria, it is a good starting point to try and get to a 90% success rate on loan prediction, with this number increasing as the system is refined. As such, a good statement to sum up the objectives of the customer would be:

> The bank wishes to succesfully predict wether a loan will be sucessful or not with at least a 90% accuracy in the results.


## Assessing the current situation

It is important to do a small analysis of what the status quo is before creating a plan, as the available resources may condition or drive the plan moving forward.

### Inventory of resources

The only resource offered by the customer was a dataset with their customers data, ranging from 1993 to 1996. It was anonimized but it still includes key information about the customers, as well as their transactions and loan histories. We were free to choose which tools we ould use to explore this dataset.

### Requirements, assumptions and constraints

#### Requirements

The main requirement provided was the completion date, which was set to be on the 29th of October, 2022. Besides that, no other requirement was put forward beside the creation of a final report, in the form of a presentation, describing all of these tasks.

#### TODO: Assumptions

- [ ] Clarify all assumptions (including implicit ones) and make them explicit (e.g., to address the business question, a minimum number of customers with age above 50 is necessary)  
- [ ] List assumptions on data quality (e.g., accuracy, availability)  
- [ ] List assumptions on external factors (e.g., economic issues, competitive products, technical advances)  
- [ ] Clarify assumptions that lead to any of the estimates (e.g., the price of a specific tool is assumed to be lower than $1,000)  
- [ ] List all assumptions regarding whether it is necessary to understand and describe or explain the model (e.g., how should the model and results be presented to senior management/sponsor)

List the assumptions made by the project. These may be assumptions about the data, which can be verified during data mining, but may also include non-verifiable assumptions related to the project. It is particularly important to list the latter if they will affect the validity of the results.

#### Constraints

There are no foreseeable constraints in the development of this project.

## Output of the project

A business goal states objectives in business terminology; a data mining goal states project objectives in technical terms. For example, the business goal might be, “Increase catalog sales to existing customers,”  
while a data mining goal might be, “Predict how many widgets a customer will buy, given their purchases over the past three years, relevant demographic information, and the price of the item.”

The Data Mining Goals section states the results of the project that enable the achievement of the business objectives. As well as listing the probable data mining approaches, the success criteria for the results in data mining terms, should also be listed.

### Data Mining Goals

Describe the intended outputs of the project that enable the achievement of the business objectives. Note that these are normally technical outputs.

- [ ] Translate the business questions to data mining goals (e.g., a marketing campaign requires segmentation of customers in order to decide whom to approach in this campaign; the level/size of the segments should be specified).  
- [ ] Specify data mining problem type (e.g., classification, description, prediction, and clustering). For more details about data mining problem types, see Appendix 2.

### Success criteria

Define the criteria for a successful outcome to the project in technical terms, for example a certain level of predictive accuracy or a propensity-to-purchase profile with a given degree of “lift.” As with business success criteria, it may be necessary to describe these in subjective terms, in which case the person or persons making the subjective judgment should be identified.

- [ ] Specify criteria for model assessment (e.g., model accuracy, performance and complexity)  
- [ ] Define benchmarks for evaluation criteria  
- [ ] Specify criteria which address subjective assessment criteria (e.g., model explain ability and data and marketing insight provided by the model

## Project Plan

List the stages to be executed in the project, together with their duration, resources required, inputs, outputs, and dependencies. Wherever possible, make explicit the large-scale iterations in the data mining process— for example, repetitions of the modeling and evaluation phases. As part of the project plan, it is also important to analyze dependencies between time schedule and risks. Mark results of these analyses explicitly in the project plan, ideally with actions and recommendations for actions if the risks are manifested. Although this is the only task in which the project plan is directly named, it nevertheless should be consulted continually and reviewed throughout the project. The project plan should be consulted at minimum whenever a new task is started or a further iteration of a task or activity is begun.

This section lists the stages to be executed in the project, together with their duration, resources required, inputs, outputs, and dependencies. Where possible, it should make explicit the large-scale iterations in the data mining process—for example, repetitions of the modeling and evaluation phases.

- [ ] Define the initial process plan and discuss the feasibility with all involved personnel  
- [ ] Combine all identified goals and selected techniques in a coherent procedure that solves the business questions and meets the business success criteria  
- [ ] Estimate the effort and resources needed to achieve and deploy the solution. (It is useful to consider other people’s experience when estimating timescales for data mining projects. For example, it is often postulated that 50-70 percent of the time and effort in a data mining project is used in the Data Preparation Phase and 20-30 percent in the Data Understanding Phase, while only 10-20 percent is spent in each of the Modeling, Evaluation, and Business Understanding Phases and 5-10 percent in the Deployment Phase.)  
- [ ] Identify critical steps  
- [ ] Mark decision points  
- [ ] Mark review points  
- [ ] Identify major iterations

### Tools and techniques

As our tool of choice, the programming language R was chosen, as it provides an incredible out of the box API for data understanding, with its  built-in charting features and Data Frame structures. When trying to figure out how the data is structured and seeing some patterns emerge, having a programming language like R, which allows us to do this seamlesly, is a great advantage.

As a backup tool, we may end up using RapidMiner, for its ease of use and simplicity by being a no-code tool, and for its ability to quickly generate some predictive analysis on the dataset, without a lot of work from its user. While we will try to stick to R only during this project, RapidMiner may be a valuable asset in the future.
