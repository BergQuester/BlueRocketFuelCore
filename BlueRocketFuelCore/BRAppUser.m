//
//  Created by Shawn McKee on 1/21/15.
//
//  Copyright (c) 2015 Blue Rocket, Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "BRAppUser.h"

NSString *const BRAppUserRecordIdPreference = @"BRAppUserRecordIdPreference";
NSString *const BRAppUserTypePreference = @"BRAppUserTypePreference";
NSString *const BRAppUserNamePreference = @"BRAppUserNamePreference";
NSString *const BRAppUserFirstNamePreference = @"BRAppUserFirstNamePreference";
NSString *const BRAppUserLastNamePreference = @"BRAppUserLastNamePreference";
NSString *const BRAppUserEmailPreference = @"BRAppUserEmailPreference";
NSString *const BRAppUserWebsitePreference = @"BRAppUserWebsitePreference";
NSString *const BRAppUserPhonePreference = @"BRAppUserPhonePreference";
NSString *const BRAppUserAddressPreference = @"BRAppUserAddressPreference";
NSString *const BRAppUserPasswordPreference = @"BRAppUserPasswordPreference";
NSString *const BRAppUserAuthenticationTokenPreference = @"BRAppUserAuthenticationTokenPreference";

@implementation BRAppUser

+ (BRAppUser *)currentUser {
    static dispatch_once_t pred = 0;
    __strong static id currentUser = nil;
    dispatch_once(&pred, ^{
        
        // if the app provides a custom user class, use that...
        Class c = NSClassFromString(@"AppUser");
        if (c) {
            currentUser = [[c alloc] init];
        }
        // otherwise, use the default implementation...
        else {
            currentUser = [[self alloc] init];
        }
    });
    return currentUser;
}

- (void)initializeWithDictionary:(NSDictionary *)dictionary {
    self.recordId = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"id"] intValue]];
    self.email = [dictionary objectForKey:@"email"];
    self.name = [dictionary objectForKey:@"name"];
    self.firstName = [dictionary objectForKey:@"first_name"];
    self.lastName = [dictionary objectForKey:@"last_name"];
    self.phone = [dictionary objectForKey:@"phone"];
    self.website = [dictionary objectForKey:@"website"];
    self.address = [dictionary objectForKey:@"address"];
    if ([dictionary objectForKey:@"password"]) self.password = [dictionary objectForKey:@"password"];
    if ([dictionary objectForKey:@"token"]) self.authenticationToken = [dictionary objectForKey:@"token"];
}

- (void)clear {
    self.recordId = nil;
    self.type = nil;
    self.email = nil;
    self.name = nil;
    self.firstName = nil;
    self.lastName = nil;
    self.password = nil;
    self.website = nil;
    self.address = nil;
    self.phone = nil;
    self.authenticationToken = nil;
}

#pragma mark - Identification

- (void)setRecordId:(NSString *)recordId {
    [self setPreferencesValue:recordId forKey:BRAppUserRecordIdPreference];
}

- (NSString *)recordId {
    return [self preferencesValueForKey:BRAppUserRecordIdPreference];
}

- (void)setType:(NSString *)type {
    [self setPreferencesValue:type forKey:BRAppUserTypePreference];
}

- (NSString *)type {
    return [self preferencesValueForKey:BRAppUserTypePreference];
}


- (void)setName:(NSString *)name {
    [self setPreferencesValue:name forKey:BRAppUserNamePreference];
}

- (NSString *)name {
    return [self preferencesValueForKey:BRAppUserNamePreference];
}

- (void)setFirstName:(NSString *)firstName {
    [self setPreferencesValue:firstName forKey:BRAppUserFirstNamePreference];
}

- (NSString *)firstName {
    return [self preferencesValueForKey:BRAppUserFirstNamePreference];
}

- (void)setLastName:(NSString *)lastName {
    [self setPreferencesValue:lastName forKey:BRAppUserLastNamePreference];
}

- (NSString *)lastName {
    return [self preferencesValueForKey:BRAppUserLastNamePreference];
}

- (void)setEmail:(NSString *)email {
    [self setPreferencesValue:email forKey:BRAppUserEmailPreference];
}

- (NSString *)email {
    return [self preferencesValueForKey:BRAppUserEmailPreference];
}

- (void)setWebsite:(NSString *)website {
    [self setPreferencesValue:website forKey:BRAppUserWebsitePreference];
}

- (NSString *)website {
    return [self preferencesValueForKey:BRAppUserWebsitePreference];
}

- (void)setPhone:(NSString *)phone {
    [self setPreferencesValue:phone forKey:BRAppUserPhonePreference];
}

- (NSString *)phone {
    return [self preferencesValueForKey:BRAppUserPhonePreference];
}

- (void)setAddress:(NSString *)address {
    [self setPreferencesValue:address forKey:BRAppUserAddressPreference];
}

- (NSString *)address {
    return [self preferencesValueForKey:BRAppUserAddressPreference];
}



- (void)setPassword:(NSString *)password {
    [self setPreferencesValue:password forKey:BRAppUserPasswordPreference];
}

- (NSString *)password {
    return [self preferencesValueForKey:BRAppUserPasswordPreference];
}

#pragma mark - Authentication

- (BOOL)newUser {
    return ([self preferencesValueForKey:BRAppUserRecordIdPreference] == nil);
}

- (BOOL)authenticated {
    return !([self authenticationToken] == nil);
}

- (void)setAuthenticationToken:(NSString *)authenticationToken {
    [self setPreferencesValue:authenticationToken forKey:BRAppUserAuthenticationTokenPreference];
}

- (NSString *)authenticationToken {
    return [self preferencesValueForKey:BRAppUserAuthenticationTokenPreference];
}

#pragma mark - Preferences Management

- (void)setPreferencesValue:(id)value forKey:(NSString *)key {
    if ([value isKindOfClass:[NSNull class]]) value = nil;
    if (!key) return;
    if (!value) [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    else [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)preferencesValueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}


@end
