//
//  BRFCRestKitDataMapping.m
//  BlueRocketFuelCore
//
//  Created by Matt on 13/08/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRFCRestKitDataMapping.h"

#import "BRAppUser.h"
#import "WebApiRoute.h"

static Class kAppUserClass;

@implementation BRFCRestKitDataMapping

+ (Class)appUserClass {
	Class c = kAppUserClass;
	if ( !c ) {
		c = [BRAppUser class];
		kAppUserClass = c;
	}
	return c;
}

+ (void)setAppUserClass:(Class)theClass {
	NSParameterAssert([theClass conformsToProtocol:@protocol(BRUser)]);
	kAppUserClass = theClass;
}

+ (void)registerObjectMappings:(RestKitWebApiDataMapper *)dataMapper {
	RKObjectMapping *appUserMapping = [self appUserMapping];
	[dataMapper registerRequestObjectMapping:appUserMapping forRouteName:WebApiRouteLogin];
	[dataMapper registerResponseObjectMapping:appUserMapping forRouteName:WebApiRouteLogin];
	[dataMapper registerRequestObjectMapping:appUserMapping forRouteName:WebApiRouteRegister];
	[dataMapper registerResponseObjectMapping:appUserMapping forRouteName:WebApiRouteRegister];
}

+ (RKObjectMapping *)appUserMapping {
	RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[self appUserClass]];
	[mapping addAttributeMappingsFromArray:@[
											 NSStringFromSelector(@selector(recordId)),
											 NSStringFromSelector(@selector(type)),
											 NSStringFromSelector(@selector(name)),
											 NSStringFromSelector(@selector(firstName)),
											 NSStringFromSelector(@selector(lastName)),
											 NSStringFromSelector(@selector(website)),
											 NSStringFromSelector(@selector(phone)),
											 NSStringFromSelector(@selector(address)),
											 NSStringFromSelector(@selector(email)),
											 NSStringFromSelector(@selector(password)),
											 ]];
	[mapping addAttributeMappingsFromDictionary:@{
												  @"passwordAgain" : @"password_confirmation",
												  }];
	return mapping;
}

@end
