# Event-based scaling of CloudHub Workers

## Introduction

Mule applications or APIs are deployed into Anypoint CloudHub (CH) with an initial number of workers. From time-to-time, business demands or external events may cause increased workload to these CH workers. For example, 
- a retailer may anticipate increased product inquiries during a promotional campaign launching in the next few days, or 
- a utility may expect higher incident reports when a storm is forecasted to move into an area in the next few hours. 

In anticipation of such events that will bring adidtional workload/traffic to relevant Mule apps, operations may want to prepare these Mule apps with additional workers to handle extra workload *before* the event occurs. Hence the solution for Event-based Scaling was created to address such scenarios.

## Scope

Event-based Scaling is only currently designed for scaling CH workers horizontally, i.e. increasing or decreasing the number of workers for Mule apps. Although it is possible to enhance the solution to include vertical scaling of CH workers (changing worker's CPU or memory allocations), that is currently not in scope. The HTTP listeners can be modified to HTTPS by including your SSL keystore and trust stores. 

## Audience

The audience of this solution includes Operations personnel responsible for Mule apps deployed in production VPC of CH.

# Background on CloudHub Worker scaling

Event-based Scaling addresses different use cases than the CH's Auto-Scaling feature. The latter is made available to certain MuleSoft customers. CH's Auto-Scaling feature scales the number of workers when CPU or memory exceeds certain pre-set thresholds. This means worker scaling takes place *after* an event has occurred which caused the spikes in CPU/memory usage by workers. There is an asset that provides solution for customers who do not have CH's Auto-Scaling enabled but still desire similar features: https://knowledgehub.mulesoft.com/s/article/Custom-Framework-for-Autoscaling-in-CloudHub

# Solution

The Event-based Scaling API solution gives control to customers in determining when to scale Mule app workers horizontally (in either direction), and how to affect a group of such apps instead of doing so one-by-one.

The following Message Sequence Diagram illustrates the features in the solution grouped as followed:
1. Group operations: Provides the ability to group a number of Mule apps in group names. Multiple groups can be created and maintained through their own lifecycles. Group is a useful way to collect a number of Mule apps that can be scaled together in response to an external event.
2. Worker scaling: One or more Mule apps to be scaled horizontally, either to an exact number of workers, or by incremental numbers (both add or remove). Group is supported.
3. Worker lifecycle: In addition to worker scaling, this solution includes lifecyle operations for Mule apps. This is useful to work on a list of Mule apps or by their associated groups. Currently supported actions for workers include START, STOP, RESTART and DELETE.


![Solution Sequence Diagram](/src/main/resources/images/worker-scaling-poc.jpeg) 

## Configurations
### `src/main/resources/properties.yaml`: 
- properties used by this API.
### `src/main/resources/secure-props.yaml`:
- The encryption key is stored under `mule.encryption.key` in `global.xml`
- Provide Organization and Environment IDs for this API to work with.
- Create a Connected Appss entry `WorkerScaler` under Anypoint Access Management, with scopes of `Runtime Manager > Manage Settings` and `Runtime Manager > Read Applications`  

```
cloudhub:
 envId: "![tWePvMWeSyltCtYlK3qgWxbbYO8pv+gpN7DcSnih7rRorHN3slQIqusDvDePZl1s]"
 orgId: "![H+G8IANjpUg1OCyx5pz+cF8NuwSOaTayK25C8KKd1camprh9XPKxtZ5sihTHBQuZ]"
connectedApp:
 workerScaler:
  client_id: "![qLYywtIrVJ2y35ldVxp4WKFEq5pkE5DiFd+CQWJ+VxfDk7L1yQXZsb5eeklJo6WF]"
  client_secret: "![4OQhWxuWwbMydxI7YSLeGn8V7mO3Zup0wBcTwQ2pWUe3c8g0SWxx7S8RE05wNnxa]"
```

## Postman Collection
- A collection of helpful Postman HTTP invocations to the API is available under `src/main/resources/postman-collection`
- The following diagram illustrates the `groups` and their members to demonstrate group-related operations:

![Group diagram](/src/main/resources/images/groups-postman.jpeg)
