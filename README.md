# Event-based scaling of CloudHub Workers

## Introduction

Mule applications or APIs are deployed into Anypoint CloudHub (CH) with an initial number of workers. From time-to-time, business demands or external events may cause increased workload to these CH workers. For example, 
- a retailer may anticipate increased product inquiries during an upcoming promotional campaign to be launched in the next few days, or 
- a utility may expect higher incident reports when a storm is forecasted to move into an area in the next few hours. 

In anticipation of such events that will bring adidtional workload/traffic to relevant Mule apps, operations personnel may want to prepare these Mule apps with additional workers to handle extra workload *before* the event occurs. Hence the solution for Event-based Scaling was created to address such scenarios.

## Scope

The Event-based Scaling API solution is currently designed to scale CH workers horizontally only, i.e. increasing or decreasing the number of workers for Mule apps. Although it is possible to enhance the solution to include vertical scaling of CH workers (i.e. changing worker's CPU or memory allocations), that is currently not in scope. The HTTPS listeners can be modified by replacing the TLS context with your SSL keystore and trust stores. 

## Audience

The audience of this solution includes Operations personnel responsible for Mule apps deployed in production Virtual Private Cloud (VPC) of CH.

# Background on CloudHub Worker scaling

The Event-based Scaling API solution addresses a different set of use cases than the CH's Auto-Scaling feature. The latter is made available to certain MuleSoft customers. CH's Auto-Scaling feature scales the number of workers horizontally when CPU or memory usage exceeds certain pre-set thresholds. This means worker scaling takes place *after* an event has occurred which caused the spikes in CPU/memory usage by workers. 

There is another asset that provides a custom solution for customers who do not have CH's Auto-Scaling enabled but still desire similar features: [Custom Autoscaling](https://knowledgehub.mulesoft.com/s/article/Custom-Framework-for-Autoscaling-in-CloudHub)

# Solution

The Event-based Scaling API solution gives control to customers to determine when to scale Mule app workers horizontally (in either direction), and how to affect a group of such apps instead of working on them one-by-one.

The following Message Sequence Diagram illustrates the features in the solution grouped as followed:
1. Group operations: Provides the ability to group a number of Mule apps in group names. Multiple groups can be created and maintained through their own lifecycles. Group is a useful way to collect a number of Mule apps that can be scaled together in response to an external event.
2. Worker scaling: One or more Mule apps to be scaled, either to an exact number of workers, or by incremental numbers (both add or remove). Scaling by group is also supported.
3. Worker lifecycle: In addition to worker scaling, this solution includes lifecyle operations for Mule apps. This is useful for working on a list of Mule apps, or through their associated groups. Currently supported actions for workers include START, STOP, RESTART and DELETE.

**NOTE: Only approved-personnel or app be given access to the Event-based Scaling API -- as the lifecycle of Mule Apps can be changed through this API.**

![Solution Sequence Diagram](/src/main/resources/images/worker-scaling-poc.jpeg) 

## Configurations
### `src/main/resources/properties.yaml`: 
- properties used by this API.
### `src/main/resources/secure-props.yaml`:
- All entries here are encrypted. The encryption key is stored under `mule.encryption.key` in `global.xml`
- For more information on how to encrypt values see here: [Encrypt text strings](https://docs.mulesoft.com/mule-runtime/4.3/secure-configuration-properties#encrypt-text-strings)
- Provide Organization and Environment IDs for this API to work with.
- Create a `Connected Apps` entry `WorkerScaler` under Anypoint Access Management, with scopes of `Runtime Manager > Manage Settings` and `Runtime Manager > Read Applications`. Once the `Connected App` entry is created, get the associated `client_id` and `client_secret` and enter them here.

```
cloudhub:
 envId: "![your-encrypted-environment-id]"
 orgId: "![your-encrypted-organization-id]"
connectedApp:
 workerScaler:
  client_id: "![your-encrypted-connected-apps-client-id]"
  client_secret: "![your-encrypted-connected-apps-client-secret]"
```

## Postman Collection
- A collection of helpful Postman HTTP invocations to the API is available under `src/main/resources/postman-collection`
- The Postman collection makes use of the Environment Variables of Postman. The variables used and to be replaced with your own values are: `client_id`, `client_secret`, and `work-scaler-host`
- The following diagram illustrates the `groups` and their members that are used to demonstrate group-related operations:

![Group diagram](/src/main/resources/images/groups-postman.jpeg)
