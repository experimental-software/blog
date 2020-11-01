---
layout: post
title:  "Dart Libraries"
date:   2020-10-31
categories: dart
---

This blog post describes how to implement as use Dart libraries.

## Introduction

Whenever a class from another Dart [package](https://dart.dev/guides/packages) is being used, it needs to be included with an `import` statement.

e.g.

```dart
import 'package:uuid/uuid.dart';

void main() {
  print(Uuid().v4());
}
```

## Libraries

Libaries can be defined at the root of the `lib` directory of a package.
There all the classes which should be available when importing the library can be exported.

```dart
/// Exports any libraries intended for clients of this package.
library random_name;

export 'src/api.dart';
export 'src/domain/domain.dart';
```
_~/src/example_library/lib/example_library.dart_

Then all the exported classes are available after the import of the `example_library`.

```dart
import 'package:example_library/example_library.dart';

void main() {
  initApplicationContext();

  var patientRepository = getIt<PatientRepository>();
  patientRepository.save(Patient.create("Joe"));
  print(patientRepository.findAll());
}
```
_~/src/example_library_client/example/example.dart_

### Sub-libraries

Actually, every `*.dart` file is a library. So it is also possible to export and import sub-libraries.

```dart
library random_name;

export 'patient.dart';
export 'patient_repository.dart';
```
_~/src/example_library/lib/src/domain/domain.dart_


```dart
import 'package:example_library/src/domain/domain.dart';

void main() {
  print(Patient.create("Joe"));
}
```
_~/src/example_library_client/example/example.dart_


## Parts

The `part` keyword in an alternative for the `export` keyword for the description of what should be included in a library [^1].
However, the official Dart documentation recommends not to use it [^2].
There are even discussions amonst the Dart developers whether this feature should be dropped from the language [^3].
It might be useful for generated code, though [^4].


## Further Reading

- [Language Tour / Libraries and Visibility @ dart.dev](https://dart.dev/guides/language/language-tour#libraries-and-visibility)
- [Organizing a library package @ dart.dev](https://dart.dev/guides/libraries/create-library-packages#organizing-a-library-package)
- [Dart library / package keyword meaning? @ StackOverflow.com](https://stackoverflow.com/questions/31736890/dart-library-package-keyword-meaning)

## Footnotes

[^1]: [Answer @ StackOverflow](https://stackoverflow.com/a/27763900/2339010)
[^2]: [Organizing a Library Package @ dart.dev](https://dart.dev/guides/libraries/create-library-packages#organizing-a-library-package)
[^3]: [Issue with list of related discussions @ github.com](https://github.com/dartsome/serializer/issues/24)
[^4]: [Answer @ StackOverflow](https://stackoverflow.com/a/27764138/2339010)

