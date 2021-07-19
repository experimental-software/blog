---
title: Adding links to a REST resource without the resource's notice
subtitle: How to add HATEOAS links to a REST resource from a module about which it doesn't know about
draft: true
publishedAt: YYYY-MM-DD
---

#java #spring #showdev

This blog post contains a description of a concept how to add a link to a REST resource provided by module A to a resource provided by module B without a module dependeny from A to B. The example implementation uses Spring Boot and Spring HATEOAS.

## Context

The final goal is to render a screen about patient details. Beside editing the actual patient details like the patient's name and address, it should be possible to perform certain patient-related actions. Which actions can be performed depends the application state. For example, patients can only be discharged if they are currently admitted and they have paid their bills.

![Screen concept](img/screen-concept.png)


## REST API

When the app opens the patient details page it executes the following HTTP request to receive the required data:

```
GET /patients/{patientId}
```

Beside the properties with the patient details, the response body contains a `_links` property which informs the frontend what actions can be done next. For example, after a patient has been created, the "start-visit" link can be used to start a new visit.

```json
{
    "_id": "0a3949db-b2c4-4a8e-8ec4-5470f9a3e89e",
    "age": null,
    "gender": "MALE",
    "name": "John Doe",
    "patientCategory": "GENERAL",
    "patientNumber": "10-1002",
    "phoneNumber": "0123456789",
    "residentialAddress": "Guesthouse",
		"_links": {
				"self": {
						"href": "http://localhost:8080/api/patients/0a3949db-b2c4-4a8e-8ec4-5470f9a3e89e"
				},
				"start-visit": {
						"href": "http://localhost:8080/api/patients/0a3949db-b2c4-4a8e-8ec4-5470f9a3e89e/visits"
				}
		}
}
```

After executing a `POST` request on the "start-visit" link, this action is not applicable anymore, so it won't be included anymore in the `_links`. Assuming that there are no open bills for the patient, he can now be discharged by executing a `POST` request on the "discharge" link.

```json
{
    "_id": "0a3949db-b2c4-4a8e-8ec4-5470f9a3e89e",
    "age": null,
    "gender": "MALE",
    "name": "John Doe",
    "patientCategory": "GENERAL",
    "patientNumber": "10-1002",
    "phoneNumber": "0123456789",
    "residentialAddress": "Guesthouse",
		"_links": {
				"self": {
						"href": "http://localhost:8080/api/patients/0a3949db-b2c4-4a8e-8ec4-5470f9a3e89e"
				},
				"discharge": {
						"href": "http://localhost:8080/api/patients/0a3949db-b2c4-4a8e-8ec4-5470f9a3e89e/visits"
				}
		}
}
```

## Module structure

This scenario requires an interaction between three modules of the hospital application: the patient management, visit, and billing. The _patient management_ module takes care of the patient's master data, the _visit_ module takes care of the patient's journey through the hospital, and the _billing_ module takes care of all payment related things.

In order to keep the system's complexity low, circular dependencies should be avoided. So to support the requirements described above, the _visit_ module knows about the _patient management_ module and the _billing_ module. However, the _patient management_ module must not know neither about the _visit_ module nor about the _billing_ module.

![Dependencies](img/dependencies.png)

## Dependency inversion

The way in which this can be achieved is that the class which takes care to create the `PatientsResource` - the `PatientsResourceAssembler` doesn't need to how _which_ links need to be added to the `PatientResource`, but only needs to know _that_ links need to be added. So the `PatientResourceAssembler` requests from a central registry which links are needed for the given `Patient` instance - the `ResourceExtensionsRegistry`.

```java
var result = PatientModel.from(patient);
var selfLink = linkTo(PatientController.class).slash(patient.getId()).withSelfRel();
result.add(selfLink);
result.add(resourceExtensionsRegistry.getLinks(Patient.class, patient));
return result;
```

So the _visit_ module needs to register a callback function in the `ResourceExtensionsRegistry`.

```java
private Optional<Link> createStartVisitLink(Patient patient) {
		if (visitRepository.hasActiveVisit(patient.getId())) {
				return Optional.empty();
		} else {
				var link = linkTo(methodOn(VisitController.class).startVisit(patient.getId())).withRel("start-visit");
				return Optional.of(link);
		}
}
```


One of the design ideas of the K.S.C.H. Workflows application is to structure its backend as a modular monolith, so that it is both fairly easy to operate and fairly easy to understand the source code.

On the other hand, the screens of the app usually require information from many places in the system.

Let's have a look at the following example: a screen which show the details of a patient and allows to trigger certain actions which are connected to the patient details. So for example a patient could be discharged by clicking on the "Discharge" button. However, the discharging a patient is only possible once they have paid their bill.

So the app shows the details of a patient which resides in the "Patient Management" module. But it wants to trigger an action in the "Visit" module which depends on a state managed by the "Billing" module. However, since circular dependencies between modules, how can the state-dependent links be added to the `/patients` resource? - with inversion of control.

The Patients resource doesn't need to know which links can be added to it, depending on the state of the rest of the application. It only needs to know that links can be added to it. So it can request the required links from a central link repository. All the modules which are interested in registering links to the patients resource can depend on the Patient Management module and then register a callback function which is then called with the actual patient resource, so that the state


## Tradeoffs

One module knows about the types of another, so that the `Patient` interface will be tranformed into a patient resource. This allows foreign modules to hook into the patient resource without being able to see it. On the other hand it allows one module to interact with the data structures of another which is not recommended by the Domain-Driven Design ideas which the K.S.C.H. Workflows project tries to follow. However, this should be okay since the other modules only have access on the getters can cannot modify the entities or call any non-official business logic.

## References

- [What is HATEOAS? and Why it is important for the REST API?](https://www.youtube.com/watch?v=_-vglnEttLI) | Ram N Java | youtube.com
- https://restfulapi.net/hateoas/
- https://www.baeldung.com/spring-hateoas-tutorial
