# Business Understanding

This is a report detailing our understanding of the project we are about to embark in, as well as the planned course of action through it all. It details the major questions and issues that arise when dealing with a Data Mining problem like this one.

This report was created by:
- Miguel Amorim - up201907756@up.pt
- Rita Mendes - up201907877@up.pt
- Tiago Rodrigues - up201907021@up.pt

## The Business Objectives

It is essential to first thoroughly understand what the customer wants to accomplish. From a productivity standpoint, this implies that with a well-defined goal, it is easy to go searching for the correct questions and, as follows, the correct answers. As such, there are a few key aspects to take into consideration when first handling this project.

### Customer Background

In this project, we are dealing with a banking company. The bank managers wish to improve the services of their bank and make better decisions alongside it, improving customer satisfaction. This not only drives profits for the bank but good clients can be rewarded more often, leading them to visit the bank even more.

The most pressing issue is that the bank cannot tell with reasonable certainty who is a good client and who is not. This is important, for example, when issuing loans, as they need to be paid back to make it a sound business decision. When issuing loans to the wrong people, there are a lot of problems associated that a bank would rather avoid altogether in the first place.

### Business objectives

The first and most important goal is to reliably distinguish between a good and a bad client. With this in mind, a more concrete statement that the bank wishes to be fulfilled is the prediction of whether some loans will end up successful or not.

Ideally, the bank would not lose a single customer with this new system, but customers identified as bad can likely be drawn away from visiting the service, as their loan requests would be denied.

While the bank did not present any success criteria, it is a good starting point to try and get to a 90% success rate on loan prediction, with this number increasing as the system is refined. As such, a good statement to sum up the objectives of the customer would be:

> The bank wishes to successfully predict whether a loan will be successful or not, such that, for every 100 clients that request a loan, at least 90 will pay it back fully and without complications.

## Assessing the current situation

It is important to do a small analysis of what the status quo is before creating a plan, as the available resources may condition or drive the plan moving forward.

### Inventory of resources

The only resource offered by the customer was a dataset with their customers' data, ranging from 1993 to 1996. It was anonymized but it still includes key information about the customers, as well as their transactions and loan histories. We were free to choose which tools we could use to explore this dataset.

### Requirements, assumptions and constraints

#### Requirements

The main requirement provided was the completion date, which was set to be on the 28th of November, 2022. Besides that, no other requirement was put forward besides the creation of a final report, in the form of a presentation, describing all of these tasks.

#### Assumptions

The following presents a few assumptions that will be made to make the development of a solution easier:

- All clients of the bank are present in the dataset
- All transactions of said clients are also present
- There are no impossible balances in the dataset (all are positive)
- Each client can have more than one account, and each account can have several people managing it
- No more than one loan can be granted per account
- Several credit cards can be issued to an account

The first 3 assumptions are made without looking at the data, and they exist to ensure data validity when exploring the set. All others are true after looking at the set, and they allow us to draw a better picture of the model behind the data.

#### Constraints

There are no foreseeable constraints in the development of this project.

## Output of the project

Without a defined output to the project, it is easy to derail and start to look for the wrong things. Clearly defining the end goal allows us to keep on track when other problems emerge, and to steer the project in the right direction in the face of unexpected issues.

### Data Mining Goals

The problem described in this project fits into the metrics of a predictive data mining problem, that is, the prediction of whether a loan will end up successfully.

### Success criteria

The success criteria are, essentially, equivalent to those of the business at hand, which are successfully determining if a given loan will end up successful with a higher than 90% accuracy. This system should try to create a profile from the available data for what makes a good client and determine if the bank should issue a loan or not.

## Project Plan

This project will mostly follow a [CRISP-DM](https://moodle.up.pt/pluginfile.php/106197/mod_resource/content/1/Ncr%20et%20al.%20-%202000%20-%20Crisp-dm%201.0.pdf) approach, and as such our plan revolves a lot around the same stages as the ones detailed in the guides. It is to note that, for now, these stages are crude and only overall descriptions. More concrete steps can only be obtained as the stages advance and it is clear what to do next.

The first and most important step is to understand the data at hand. This not only allows us to get a better understanding of the issues faced, but it can give rise to new insights and alter the project's course entirely. This stage will be tightly integrated with every stage, as finding new things about the data can change the entire perspective of the project.

With the data thoroughly analyzed, we can proceed to select a good subset and clean it, removing any values deemed outliers in the process. These will contribute little to the research and they can skew the results in the wrong direction. New attributes are also built in this stage, to make it easier for further iterations to operate on the data. With the data prepared, it is possible to move on.

The final stage is a simpler one since most of the work is automated. It entails using the acquired subset and running it through a series of models, continuously improving it until a satisfying value is achieved. More importantly, it is necessary to be cautious about overfitting the model to the data, so testing with different subsets of the data is important. When the values are tweaked and the metrics match our business and data mining goals, the solution can be considered obtained and deployed to the customer, who can now use it to its benefit.

With this final stage we can, if the time constraints allow, try and improve the existing model and boost the accuracy even more. Running this process iteratively and going through each of the stages several times, like the traditional Agile processes of Software Engineering, help us get a better vision of the final product, and course-correct many more times than with a traditional Waterfall methodology.

### Tools and techniques

As our tool of choice, the programming language R was chosen, as it provides an incredible out-of-the-box API for data understanding, with its built-in charting features and Data Frame structures. When trying to figure out how the data is structured and seeing some patterns emerge, having a programming language like R, which allows us to do this seamlessly, is a great advantage.

As a backup tool, we may end up using RapidMiner, for its ease of use and simplicity by being a no-code tool, and for its ability to quickly generate some predictive analysis on the dataset, without a lot of work from its user. While we will try to stick to R only during this project, RapidMiner may be a valuable asset in the future.
