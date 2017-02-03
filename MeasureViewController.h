//
//  MeasureViewController.h
//  Swedsleep
//
//  Created by Mats Berggrund on 09/11/13.
//  Copyright (c) 2013 SwirlySpace AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import "AccSampleHandler.h"

@interface MeasureViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) CMMotionManager* motionManager;
@property (strong, nonatomic) CLLocationManager* locationManager;

- (void)setQueuedMessages:(NSNumber*)queuedMessages;
- (void)enableMeasure;
- (void)disableMeasure;
- (void)say:(NSString*)text;
- (bool)isMeasureEnabled;

@end
