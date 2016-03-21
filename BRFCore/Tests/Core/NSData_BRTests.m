//
//  NSData_BRTests.m
//  BRFCore
//
//  Created by Matt on 21/10/15.
//  Copyright © 2015 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BaseTestingSupport.h"

#import "NSData+BR.h"
#import "NSString+BR.h"

@interface NSData_BRTests : BaseTestingSupport

@end

@implementation NSData_BRTests

- (void)testHexStringValue {
	const char bytes[4] = {4, 8, 12, 24};
	NSMutableData *data = [[NSMutableData alloc] initWithCapacity:3];
	[data appendBytes:bytes length:4];
	NSString *str = [data hexStringValue];
	assertThat(str, equalTo(@"04080c18"));
}

- (void)testMD5DigestEmptyValue {
	NSData *data = [[NSData alloc] init];
	NSString *string = [[data MD5DigestValue] hexStringValue];
	assertThat(string, equalTo(@"d41d8cd98f00b204e9800998ecf8427e"));
}

- (void)testMD5Digest {
	const char bytes[4] = {4, 8, 12, 24};
	NSMutableData *data = [[NSMutableData alloc] initWithCapacity:3];
	[data appendBytes:bytes length:4];
	NSString *string = [[data MD5DigestValue] hexStringValue];
	assertThat(string, equalTo(@"623edca41c8071ada535895091acf2e5"));
}

@end
