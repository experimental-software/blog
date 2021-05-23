---
title: Layered Architecture for Java projects
subtitle: Your subtitle here
draft: true
publishedAt: YYYY-MM-DD
---

"Traditional layers architecture"

- Motivation
- Guidelines for contents in the layers

## Layers

### User interface layer

TBD

### Application layer

Application services (14), Subscribers to Domain Events (8), controll transactions, security, "Kepp Application Services thin, using them only to coordinate tasks on the model." (p. 521). "The Application Service depends on the Repository interface from the domain model but uses the implementation class from infrastructure." (p. 533)

### Domain layer

Domain services (7), "We should strive to push all business domain logic into the domain model, whether that be in Aggregates, Value Objects, or Domain Services." (p. 521)

### Infrastructure layer

TBD

## Dependencies

TBD


## ArcUnit

Like there are unit tests for the business logic, there should be unit tests for the architectural constraints. For Java projects ArcUnit can be used for that purpose.

- The "domain" package doesn't contains any Spring dependencies
- No outside dependencies from "util"
- The package structure is conforming to the layer with DI concept, e.g. "domain" doesn't depend on "rest"

## References

### Books

- Implementing Domain-Driven Design (Vaughn Vernon)
- Clean Architecture (Robert Martin)
- Evolutionary Architecture?

### Websites

- https://github.com/xmolecules/jmolecules
- https://github.com/hschwentner/dddbits-java
- https://www.oreilly.com/library/view/software-architecture-patterns/9781491971437/ch01.html
