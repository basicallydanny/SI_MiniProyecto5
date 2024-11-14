# SI_MiniProyecto5

[contributors-shield]: https://img.shields.io/github/contributors/basicallydanny/SI_MiniProyecto5.svg?style=for-the-badge
[contributors-url]: https://github.com/basicallydanny/SI_MiniProyecto5/graphs/contributors
[![Contributors][contributors-shield]][contributors-url]

<div align="left">
Presented by Daniela Gómez and Santiago Peña
</div>

<!-- PROJECT -->

<h3 align="center">MINI PROJECT #5</h3>
  <p align="center">
    README in regards to the project #5 for Interaction Systems 2472 - A
  </p>
</div>

## About The Project

Using OpenMusic (OM), they must develop an algorithm that generates a musical piece for a video game.Create a data sonifier that integrates data visualization and sound generation using Processing for the graphical part and Pure Data for the sound, having as a data source a dataset that contains significant data to represent visually.

### Limitations

* Pure Data and Processing must be used.
* A visualization and sonification of the data must be obtained according to the inserted data.
* A public dataset/database must be used.
* It must be shown how the visual and sound changes according to the data.

### Built With

* PureData-Extended
* Processing
* Dataset: https://www.kaggle.com/datasets/PromptCloudHQ/imdb-data

## Roadmap

- [X] Learn the use of Processing.
- [X] Choose a Dataset.
- [X] Work the Dataset inside Processing. 
- [X] Stablish a connection with PureData-Extended.
- [X] Publish.

## Decision Overview

*  Dataset: The project loads movie data from a dataset (data.csv), which includes attributes like title, rating, revenue, runtime, and genre.
* Movie Representation: movies are represented as bubbles positioned randomly on the screen. The bubble size represents the movie rating, and the bubble color intensity corresponds to the revenue. The movie's title and rating are displayed when the user hovers over the bubble.
* Genre-Based Color Coding: Each movie genre is associated with a unique color, making it easy to visually differentiate between genres.
* Mouse Interactions: When the user clicks on a movie bubble, a visual effect is triggered around the bubble, and an OSC (Open Sound Control) message is sent to Pure Data to trigger corresponding sounds.