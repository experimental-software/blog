---
layout: post
title:  "Building Mini Webapps with Dart/HTML"
date:   2020-11-08
categories: dart html
---

In the day-to-day work it is sometimes necessary to build small tools for repeated calculations,
e.g. expected tax values or UI design dimensions.
This can be done e.g. with Excel spreadsheets or Python scripts.
The disadvantage of these two options for low-end programming tasks is that when you want to share those tools with colleagues,
they require that every user has the respective toolchain installed on their computer.

The purpose of this blog post is to present yet another approach for such small tools:
tiny HTML pages with a little bit of JavaScript attached to it.

## Overview

The Dart programming language is well suited to build such kind of tools.
Dart programs can be compiled to JavaScript.
So, they can do everything that can be done with JavaScript.
Further, they provide strong type safety and a syntax which is quite close to Java.

## Example

➡️  [https://experimental-software.github.io/mini_webapp/](https://experimental-software.github.io/mini_webapp/)

For example, you can have a look at the solution for the "Simple Math" challenge from the [Exercises for Programmers](https://pragprog.com/titles/bhwb/exercises-for-programmers/) book.

![Simple Math app](/assets/2020/11/08/simple-math.png)

### Business logic

The following snippet shows an outline of the Dart code which calculates the business logic for the example mini webapp:

_main.dart_:

```dart
void main() {
  firstNumberInput = querySelector('#firstNumberInput'); // <1>
  secondNumberInput = querySelector('#secondNumberInput');

  firstNumberInput.onInput.listen(handleKeystrokeEvent); // <2>
  secondNumberInput.onInput.listen(handleKeystrokeEvent);

  resultContainer = querySelector('#result');
  resultPlaceholderContainer = querySelector('#resultPlaceholder');

  resultList = querySelector('#result .list-group');
}

void handleKeystrokeEvent(Event e) {
  bool firstNumberValid = validate(firstNumberInput);
  bool secondNumberValid = validate(secondNumberInput);

  if (!firstNumberValid || !secondNumberValid) {
    resultContainer.hidden = true;
    resultPlaceholderContainer.hidden = false;
    return;
  }

  resultContainer.hidden = false; // <3>
  resultPlaceholderContainer.hidden = true;

  resultList.nodes = calculateResults(parseNumber(firstNumberInput), parseNumber(secondNumberInput)).map((s) => LIElement()
      ..text = s
      ..setAttribute("class", "list-group-item")
    ).toList(); // <4>
}
```

1. We can get access to the DOM elements with CSS selectors.
2. Then we can register callback functions for input events.
3. In the event handler, we can manipulate the DOM elements.
4. The last step in the event handling is adding the new list elements with the calculation results into the DOM.

### Layout

The following code snippet shows a reduced version of the HTML code which is required for this.
In order to make it visually appealing, it uses CSS from [Bootstrap](https://getbootstrap.com/).

_index.html_:

```html
<html>
<head>
    <link rel="stylesheet" href="styles.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
    <script defer src="main.dart.js"></script>
</head>

<body>

  <div class="container">
    <h1>Simple Math</h1>

    <div class="card">
      <h5 class="card-header">Input</h5>
      <div class="card-body">
        <form>
          <div class="form-group">
            <label for="firstNumberInput">First number</label>
            <input type="text" class="form-control" id="firstNumberInput" placeholder="Enter first number">
          </div>
          <div class="form-group">
            <label for="secondNumberInput">Second number</label>
            <input type="text" class="form-control" id="secondNumberInput" placeholder="Enter second number">
          </div>
        </form>
      </div>
    </div>

    </br>

    <div id="resultPlaceholder" class="card">
      <h5 class="card-header">Result</h5>
      <div class="card-body">
        n/a
      </div>
    </div>
  </div>

</body>
</html>
```


## Getting started

If this approach looks like something you would like to try for yourself, let's have a look at the necessary steps.
To make it easy to try it out, the build commands are using [Docker](https://www.docker.com/) [^1] .
Please refer to the [Dart documentation](https://dart.dev/get-dart) if you want to install the Dart toolchain directly on your computer.

### Copy the template

The [mini_webapp](https://github.com/experimental-software/mini_webapp) repository can be used as a template repository on GitHub.

![Template Button](/assets/2020/11/08/template-button.png)

### Implement business logic

For the development of Dart programs, it is recommended to use IntelliJ or VS Code with the respective "Dart" plugin.
To get an overview of the Dart language, you can refer to the [language tour](https://dart.dev/guides/language/language-tour).
Third-party packages for Dart programs can be found at [pub.dev](https://pub.dev/).

![IntelliJ Config](/assets/2020/11/08/dart-settings-intellij.png)

The `index.html` and `main.dart` file can be found in the `web/` directory of the example app.

### Run the watchdog

During development, by running this command the generated code gets updated everytime you change a file:

```
docker run --rm -it -v $PWD:/app -p 8080:8080 -w /app experimentalsoftware/dart-webdev webdev-serve
```

### Build and release

Once you are done you can create the final build of the mini webapp with the `webdev build` command:

```bash
docker run --rm -it -v $PWD:/app -p 8080:8080 -w /app experimentalsoftware/dart-webdev
pub get
webdev build -o web:docs
```

It might be a good idea to commit the generated HTML and JavaScript code into the source code repository.
In this way, you can publish the mini webapp to GitHub pages or give your colleagues the possibility to just download the repository to be able to use your tool.

Alternatively, you might want to publish the generated mini webapp to your own webserver:

```
rsync -r docs/* root@${HOST}:${DIRECTORY}
```

## References

[^1]: The Docker image used for those commands is an updated build of [https://github.com/martingregoire/docker-dart-webdev](https://github.com/martingregoire/docker-dart-webdev).
