# DoclerTestTask
App shows list of top popular movies from https://www.themoviedb.org and allows to open detailed info for any of it

VIPER was chosen as a base architecture which allows to scale the app easily.

Networking was done with Moya framework, there is basic NetworkService that executes requests and some services that use it 
devided by which kind of data they work with (e.g. MoviewNetworkService is used to get movies info, ConfigurationNetworkService os used to get api config variables)

UI was done with XIBs, navigation was done with code, no storyboards. SDWebImage framework is used to download and show images

App uses SwiftLint with some basic rules to control code style and quality

App does not provide visual error handling yet the design allows to add it easily.
