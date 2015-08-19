# Blue Rocket Fuel Core

This project provides core modules to help kick start iOS applications. It works in tandem with the [BlueRocketFuelAppp][brfa] starter project. Each module is available as a Cocoapod _subspec_ and can be imported into projects like

```ruby
pod 'BlueRocketFuelCore/Core'
```

By default all modules will be imported if your `Podfile` contains just

```ruby
pod 'BlueRocketFuelCore'
```


# Module: Core

The **Core** module provides basic support for the following areas:

 * a _user_ domain object
 * a simple [keychain service](https://github.com/Blue-Rocket/BlueRocketFuelCore/blob/msm/Code/Core/BRKeychainService.h) for saving sensitive information in the OS keychain
 * a localization framework based on a JSON strings file format
 * a configuration framework based on [BREnvironment][brenv] and a JSON configuration file format
 * various utilities, such as date formatting and validation
 
# Module: UI

The **UI** module provides UI components and support for the following areas:

 * NIB object and view localization based on the `Core` module localization framework
 * an _options tray_ view controller for application navigation
 * various utilities, such as image manipulation and effects
 
# Module: WebApiClient

The **WebApiClient** module provides a HTTP client framework based on _routes_ configured via the `Core` module configuration framework with support for _object mapping_ for transforming requests and responses between native objects and serialized forms, such as JSON. This module provides just a protocol based API and some scaffolding classes to support the API, but does not provide an actual full implementation itself, so that different HTTP back-ends can be used as needed.

## Client

The [WebApiClient](https://github.com/Blue-Rocket/BlueRocketFuelCore/blob/msm/Code/WebApiClient/WebApiClient.h) protocol defines the main HTTP client entry point for applications to use. The API is purposefully simple and based on asynchronous block callbacks:

```objc
- (void)requestAPI:(NSString *)name 
 withPathVariables:(id)pathVariables 
        parameters:(id)parameters 
              data:(id)data
		  finished:(void (^)(id<WebApiResponse> response, NSError *error))callback;
```

An example invocation of this API might look like this:

```objc
// make a GET request to /documents/123
[client requestAPI:@"doc" withPathVariables:@{@"uniqueId" : @123 } parameters:nil data:nil 
          finished:^(id<WebApiResponse> response, NSError *error) {
	if ( !error ) {
		MyDocument *doc = response.responseObject;
	} else if ( response.statusCode == 422 ) {
		// handle 422 (validation) errors here...
	}
}];
```

## Routing

The [WebApiRoute](https://github.com/Blue-Rocket/BlueRocketFuelCore/blob/msm/Code/WebApiClient/WebApiRoute.h) protocol defines a single API endpoint definition, assigned a unique name. Routes are typically configured when an application starts up. Each route defines some standardized properties, such as a HTTP `method` and URL `path`. For convenience, routes support arbitrary property access via Objective-C's keyed subscript support, so the following is possible:

```objc
id<WebApiRoute> myRoute = ...;

// access the path property
NSString *path1 = myRoute.path;

// access the path property using keyed subscript notation
NSString *path2 = myRoute[@"path"];

// access some arbitrary property not defined in WebApiRoute specifically
id something = myRoute[@"extendedProperty"];
```

For even more convenience, WebApiRoute provides [extensions](https://github.com/Blue-Rocket/BlueRocketFuelCore/blob/msm/Code/WebApiClient/NSDictionary%2BWebApiClient.h) to `NSDictionary` and `NSMutableDictionary` so that they conform to `WebApiRoute` and `MutableWebApiRoute`, respectively. That means you can use dictionaries directly as routes, like this:

```objc
// define a route
id<WebApiRoute> myRoute = @{ @"name" : "login", @"path" : @"user/login", @"method" : @"POST" };

// create a mutable copy and extend
id<MutableWebApiRoute> mutableRoute = [myRoute mutableCopy];
mutableRoute[@"extendedProperty"] = @"special";
```

## Object mapping

The [WebApiDataMapper](https://github.com/Blue-Rocket/BlueRocketFuelCore/blob/msm/Code/WebApiClient/WebApiDataMapper.h) protocol defines an API for _encoding_ native objects into HTTP requests and _mapping_ HTTP responses into native objects. Routes can be configured with a `dataMapper` property to support this feature. 

# Module: WebApiClient-AFNetworking

The **WebApiClient-AFNetworking** module provides a full implementation of the `WebApiClient` API, based on [AFNetworking][afn] and `NSURLSession`.

## Route configuration

Routes can be configured in code via the `registerRoute:forName:` method, but more conveniently they can be configured via the standard BRFC `config.json` file. The `webservice.api` key will be inspected by default, and can be an object representing all the routes that should be registered for the application. For example, the following JSON would register two routes, `login` and `register`:

```json
{
	"webservice" : {
		"api" : {
			"register" : {
				"method" : "POST",
				"path" : "user/register",
			},
			"login" : {
				"method" : "POST",
				"path" : "user/login",
			}
		}
	}
}
```


# Module: WebApiClient-RestKit

The **WebApiClient-RestKit** module provides an _object mapping_ implementation for the `WebApiClient` API based on the [RestKit][rk]. It provides a way to transform native objects into JSON, and vice versa. This module only makes use of the `RestKit/ObjectMapping` module, so it does not conflict with AFNetworking 2. In fact, part of the motivation for WebApiClient was to be able to use AFNetworking 2 with RestKit's object mapping support because RestKit's networking layer is based on AFNetworking 1. In some respects the WebApiClient API provides some of the same scaffolding that the full RestKit project provides.

## Mapping configuration

The `RestKitWebApiDataMapper` class supports a shared singleton pattern that your application can configure when it starts up with any required `RKObjectMapping` objects. You configure it like this:

```objc
RestKitWebApiDataMapper *dataMapper = [RestKitWebApiDataMapper sharedDataMapper];

// get RestKit mapper for user objects
RKObjectMapper *userObjectMapper = ...;

// register user mapper for requests and responses
[dataMapper registerRequestObjectMapping:[userObjectMapper inverseMapping] forRouteName:@"login"];
[dataMapper registerResponseObjectMapping:userObjectMapper forRouteName:@"login"];
```

The [BRRestKitDataMapping](https://github.com/Blue-Rocket/BlueRocketFuelCore/blob/msm/Code/WebApiClient-RestKit/BRRestKitDataMapping.m) class is a good starting point for applications to extend: it registers object mappers for the [BRAppUser](https://github.com/Blue-Rocket/BlueRocketFuelCore/blob/msm/Code/Core/BRAppUser.h) domain object for the standardized `login` and `register` route names.

## Route configuration

To use RestKit-based object mapping with a route, you configure the `dataMapper` property of the route with `RestKitWebApiDataMapper` like this:

```JSON
{
	"webservice" : {
		"api" : {
			"login" : {
				"method" : "POST",
				"path" : "user/login",
				"dataMapper" : "RestKitWebApiDataMapper"
			}
		}
	}
}
```

Sometimes the request or response JSON needs to be nested in some top-level object. For example imagine that the register endpoint expects the user object to be posted as JSON like this:

```JSON
{
  "user" : { "email" : "joe@example.com", "name" : "Joe" }
}
```

This can be done by adding a `dataMapperRequestRootKeyPath` property (or `dataMapperResponseRootKeyPath` for mapping responses), like this:

```JSON
{
	"webservice" : {
		"api" : {
			"login" : {
				"method" : "POST",
				"path" : "user/login",
				"dataMapper" : "RestKitWebApiDataMapper",
				"dataMapperRequestRootKeyPath" : "user"
			}
		}
	}
}
```

# Module: WebRequest

The **WebRequest** module provides a HTTP client framework based on `NSURLConnection` that can be configured via the `Core` module configuration framework along with some simple conventions.

## Configuration

Web service configuration and support is managed via three areas:

### The config.json file

This JSON file is where you define all the endpoints that your web service provides. You will need to specify the path and method (GET, POST, PUT, etc.) for each end point here.

### BREnvironment settings

The URL, port and protocol of your web service are configured via [BREnvironment][brenv].

### Web service endpoint classes

For each endpoint in your web service you will want to implement a class. Name the class using a naming convention of `{EndPoint}WebServiceRequest`, where `{EndPoint}` is the name of the endpoint you defined in the **config.json** file with the first letter capitalized.

Your custom web service endpoint class should then subclass one of the following built-in BRFC classes, depending on which one best fits the endpoint:

#### BRWebServiceRequest

For public, non-restricted endpoints that do not require an authenticated user token to access.

#### BRAuthenticatedWebServiceRequest

For endpoints that require an authenticated user token (passed in the "USER-AUTHORIZATION" HTTP header) to access.

##### BRUserWebServiceRequest

For endpoints that not only require an authenticated user token to access, but also require the user's record ID appended to the path of the end point. Subclasses of this would typically be for endpoints that provide user-specific details, such as a user profile endpoint.


 [brfa]: https://github.com/Blue-Rocket/BlueRocketFuelApp
 [cocoapods]: https://cocoapods.org/
 [brenv]: https://github.com/Blue-Rocket/BREnvironment
 [afn]: https://github.com/AFNetworking/AFNetworking
 [rk]: https://github.com/RestKit/RestKit
