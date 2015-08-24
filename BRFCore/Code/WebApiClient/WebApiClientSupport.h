//
//  WebApiClientSupport.h
//  BlueRocketFuelCore
//
//  Created by Matt on 12/08/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "WebApiClient.h"

@protocol WebApiDataMapper;
@protocol BRUserService;
@class BREnvironment;

NS_ASSUME_NONNULL_BEGIN

/** The HTTP header name to put the @c appApiKey value in. */
extern NSString * const WebApiClientSupportAppApiKeyDefaultHTTPHeaderName;

/** The HTTP header name to put the @c appId value in. */
extern NSString * const WebApiClientSupportAppIdDefaultHTTPHeaderName;

@interface WebApiClientSupport : NSObject <WebApiClient>

/** An API key to add as a header value to each request. */
@property (nonatomic, strong, nullable) NSString *appApiKey;

/** The HTTP header name to use for the API key. */
@property (nonatomic, strong) NSString *appApiKeyHTTPHeaderName;

/** An application ID to add as a heder value to each request. */
@property (nonatomic, strong, nullable) NSString *appId;

/** The HTTP header name to use for the application ID. */
@property (nonatomic, strong) NSString *appIdHTTPHeaderName;

/** A user service to use for authorization support. */
@property (nonatomic, weak, nullable) id<BRUserService> userService;

/**
 Init with a custom environment.
 
 @param environment The environment to use.
 @return The new instance.
 */
- (id)initWithEnvironment:(BREnvironment *)environment;

/**
 Configure default routes in the receiver. Extending classes can override to customize the instance.
 
 @param environment The environment to configure the routes from.
 */
- (void)loadDefaultRoutes:(BREnvironment *)environment;

/**
 Configure the base API URL in the receiver. Extending classes can override to customize the instance.
 
 @param environment The environment to configure the base API URL from.
 @return The base API URL to use.
 */
- (NSURL *)setupBaseApiURL:(BREnvironment *)environment;

/**
 Register a new route.
 
 Extending classes can override this to customize the route registration process, but they should
 invoke this method at some point of their implementation.
 
 @param route The route configuration.
 @param name The name of the route. Names are unique for a given instance @c WebApiClientSupport.
 */
- (void)registerRoute:(id<WebApiRoute>)route forName:(NSString *)name;

/**
 Get a previously registered route by its name.
 
 @param name The name of the route to get.
 @param error An error if the route is not registered. Pass @c nil if you don't need the error.
              The localized message @c web.api.missingRoute will be returned.
 @return The route associated with @c name, or @c nil if not registered.
 */
- (nullable id<WebApiRoute>)routeForName:(NSString *)name error:(NSError * __autoreleasing *)error;

/**
 Get a base URL for the routes managed by this client.
 
 @return The base URL, wich is composed of the URL protocol, host, and port.
 */
- (NSURL *)baseApiURL;

/**
 Turn an arbitrary parameters object into a @c NSDictionary.
 
 This implementation will return the @c parameters instance if that is already a dictionary. Otherwise
 it will look at the properties defined on the object and return a dictionary of the values associated
 with those properties.
 
 @param parameters A parameters object, such as a dictionary or arbitrary model object.
 */
- (NSDictionary *)dictionaryForParametersObject:(id)parameters;

/**
 Get a @c URL instance for a route.
 
 @param route The route.
 @param pathVariables An optional path variables object. All path variables will be resolved against this object.
 @param parameters An optional parameters object to encode as the query component of the request URL.
 @param error An error if the route has no associated path. Pass @c nil if you don't need the error.
              The localized message @c web.api.missingRoutePath will be returned.
 @return The URL instance.
 */
- (NSURL *)URLForRoute:(id<WebApiRoute>)route
		 pathVariables:(nullable id)pathVariables
			parameters:(nullable id)parameters
				 error:(NSError * __autoreleasing *)error;

/**
 Get a data mapper for a specific route.
 
 @param route The route to get a data mapper for.
 @return The configured data mapper, or @c nil if no data mapper configured for the given route.
 */
- (nullable id<WebApiDataMapper>)dataMapperForRoute:(id<WebApiRoute>)route;

/**
 Add authorization headers to a request for a given route.
 
 This method will populate the @c appApiKeyHTTPHeaderName and @c appIdHTTPHeaderName, if the @c appApiKey and @c appId properties are non-nil.
 If a @c userService is configured and that returns an authenticated active user, an @c Authorization header will be added using a @c token
 scheme with a the user's @c authenticationToken value.
 
 @param request The request to add headers to.
 @param route The route.
 */
- (void)addAuthorizationHeadersToRequest:(NSMutableURLRequest *)request forRoute:(id<WebApiRoute>)route;

@end

NS_ASSUME_NONNULL_END
