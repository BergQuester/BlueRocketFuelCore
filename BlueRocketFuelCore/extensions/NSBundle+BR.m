//
//  NSBundle+BR.m
//  BlueRocketFuelCore
//
//  Created by Matt on 10/08/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import "NSBundle+BR.h"

@implementation NSBundle (BR)

+ (NSDictionary *)appStrings {
	static NSDictionary *appStrings = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		appStrings = [NSBundle mainBundle].appStrings;
	});
	return appStrings;
}

- (NSDictionary *)appStrings {
	NSString *path = [self pathForResource:@"strings" ofType:@"json"];
	NSData *data = [[NSData alloc] initWithContentsOfFile:path];
	// FIXME: why is this using mutable containers
	return [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves) error:nil];
}

@end
