//
//  main.m
//  BasicAppTemplate
//
//  Created by Matt on 24/08/15.
//  Copyright (c) 2015 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BRCocoaLumberjack/BRCocoaLumberjack.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
	@autoreleasepool {
		BRLoggingSetupDefaultLogging();
	    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
	}
}