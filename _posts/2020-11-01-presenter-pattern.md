---
layout: post
title:  "What is a Presenter?"
date:   2020-10-31
categories: software design pattern
---

The Presenter is a part of the Model-View-Presenter (MVP) design pattern.
It contains all the logic for the View.
When an event takes place in the user interface, it is passed on to the Presenter for processsing what needs to be done with this.
This may include updating the Model and updating the View.

## Visualization

[This StackOverflow answer](https://stackoverflow.com/a/17507611/2339010) contains a block diagram for the MVP pattern:

![MVP Block Diagram](/assets/img/mvp-block-diagram.png)

## References

- [Model–view–presenter @ Wikipedia](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93presenter)
- [What are MVP and MVC and what is the difference? @ StackOverflow](https://stackoverflow.com/questions/2056/what-are-mvp-and-mvc-and-what-is-the-difference)
