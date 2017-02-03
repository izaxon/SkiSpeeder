//
//  SettingsDb.h
//  Traffic
//
//  Created by Mats Berggrund on 2011-04-28.
//  Copyright 2011 SwirlySpace AB. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SettingsDb : NSObject {
    NSUserDefaults* defaults;
}
+ (SettingsDb*)sharedInstance;

- (void)synchronize;

@property NSString* deviceId;
@property NSString* userCode;


@end
