//
//  WebApiClientUserService.h
//  WebApiClientUserService
//
//  Created by Matt on 11/08/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <WebApiClient/WebApiClient-Core.h>
#import "BRUserService.h"


/** A standard route name for user registration. */
extern NSString * const WebApiRouteRegister;

/** A standard route name for user login. */
extern NSString * const WebApiRouteLogin;

/** A standard route name for getting a user profile (account details). */
extern NSString * const WebApiRouteGetUser;

/** A standard route name for updating a user profile (account details). */
extern NSString * const WebApiRouteUpdateUser;

/**
 Implementation of @c BRUserService using @c WebApiClient for login and registration requests.
 This class also conforms to @c WebApiAuthorizationProvider so that it can act as an authentication
 provider for client requests.
 */
@interface WebApiClientUserService : NSObject <BRUserService, WebApiAuthorizationProvider>

/** The class of the app user; must conform to @c BRUserRegistration. This defaults to @c BRAppUser. */
@property (nonatomic, strong) Class appUserClass;

/** The @c WebApiClient implementation to use. */
@property (nonatomic, strong) id<WebApiClient> client;

@end
