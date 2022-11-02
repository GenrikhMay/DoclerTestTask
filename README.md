# DoclerTestTask
App shows list of top popular movies from **https://www.themoviedb.org** and allows to search and view detailed info for any of it

## Stack 
* **Xcode 13.4.1**
* **Architecture**: VIPER
* **Networking**: Moya
* **UI**: Interface builder + navigation with code
* **Images**: SDWebImage
* **Dependencies**: Cocoapods
* **Unit tests:** XCTest
* **Code quality control**: Swiftlint

VIPER was chosen as a base architecture which allows to scale the app easily.

Networking was done with Moya framework, there is basic NetworkService that executes requests and some services that use it 
devided by which kind of data they work with (e.g. MoviewNetworkService is used to get movies info, ConfigurationNetworkService os used to get api config variables)

UI was done with XIBs, navigation was done with code, no storyboards. SDWebImage framework is used to download and show images

App uses SwiftLint with some basic rules to control code style and quality

App does not provide visual error handling yet the design allows to add it easily.

Unit tests were written for MovieListInteractor and MovieListPresenter because they contain most of the logic

## Project structure
* **Application** - Files used to start the app
* **Architecture** - Files that can be used for all viper modules
* **Network** - Network layer of the app
	* **Core** - Core networking files used by all services
	* **Services** - Exact services split by what kind of data it works with
	* **Endpoints** - Endpoints that conform to Moya's TargetTypes and used by MoyaProvider
	* **NetworkResponses** - Network response models
	* **DTOs** - Models that come from API
* **MoviListModule** - Files refering to movie list VIPER module
* **MovieDetailsModule** - Files refering to movie details VIPER module
* **UI** - Files used to work with UI layer of the app
* **Extensions** - Some useful extensions 
* **Supporting** - Non-code project files
	

## Improvments
App was designed to be scaleable, yet it still is an MVP so there're some improvemts that can be done

* Common VIPER modules properties/methods can be moved to separate protocol 
(smth like ViperPresenterProtocol) that will allow to build viper module with generic approach
* App Configuration was designed as a singletone but it can be moved to be a UIAplication part
* App's appearance should be a separate entity so it could be replaced or vary due to testing/redesign needs
* Core Network layer can be refactored to be more pure and reusable. Moya framework does give 
possibility to setup networking easily but it also sets some constrictions because it uses enums and generics
* Since the app is simple, intercator and presenter are so close that in some cases 
there's not much sense in unit testing their methods cause it's impossible to check exact outcome from 
calling tested method. Unit tests can test presenter and interactor together in that case it will
be possible to test a results/side effects of calling methods, not just checking smthWasCalled == true 
