# MovieSearchVIPER

A modern iOS movie search app built with VIPER architecture, UIKit, Alamofire, and OMDB API.

## About

MovieSearchVIPER is a sample iOS application that demonstrates the VIPER architecture using UIKit and Alamofire.
The app allows users to search for movies via the OMDB API, view results in a modern grid layout, and see detailed movie information.
The codebase is organized for clarity, modularity, and best practices in iOS development.

## Features

- VIPER architecture (View, Interactor, Presenter, Entity, Router)
- UIKit & Programmatic UI
- Networking with Alamofire
- SOLID principles & clean code
- Movie search with OMDB API
- Grid view for results
- Movie detail screen with poster, year, genre, IMDB rating, and plot
- Error handling and user-friendly alerts

## Folder Structure

```
MovieSearch/
├── View/
├── Interactor/
├── Presenter/
├── Entity/
├── Router/
└── Service/
```

## Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/ceylanramazan/MovieSearchVIPER.git
   ```
2. Open the project in Xcode.
3. Run `pod install` or use Swift Package Manager for Alamofire.
4. Get a free API key from [OMDB API](http://www.omdbapi.com/apikey.aspx) and add it to `BaseService.swift`.
5. Build and run on a simulator or device.

## Screenshots

> _You can add screenshots here for a more professional README!_

## License

MIT

---

> Developed by [ceylanramazan](https://github.com/ceylanramazan) 