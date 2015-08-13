//
//  BRFCRestKitDataMapping.h
//  BlueRocketFuelCore
//
//  Created by Matt on 13/08/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "RestKitWebApiDataMapper.h"

#import <RestKit/ObjectMapping.h>

/**
 Utility class to generate RestKit object mapping instances for domain objects.
 */
@interface BRFCRestKitDataMapping : NSObject

/**
 Register all supported object mappings with a specific @c RestKitWebApiDataMapper.
 
 @param dataMapper The @c RestKitWebApiDataMapper to register request and response mappings for.
 */
+ (void)registerObjectMappings:(RestKitWebApiDataMapper *)dataMapper;

/**
 Get a mapping for the @c BRAppUser class.
 
 @return An object mapping instance.
 */
+ (RKObjectMapping *)appUserMapping;

@end