//
//  AccSampleHandler.h
//  Swedsleep
//
//  Created by Mats Berggrund on 10/11/13.
//  Copyright (c) 2013 SwirlySpace AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>


@interface AccSampleHandler : NSObject

+ (AccSampleHandler*)sharedInstance;

-(void)addSampleNow:(NSTimeInterval)now sampleTime:(NSTimeInterval)sampleTime x:(double)x y:(double)y z:(double)z;
-(void)addSampleNow:(NSTimeInterval)now sampleTime:(NSTimeInterval)sampleTime gx:(double)x gy:(double)y gz:(double)z;
-(void)addSampleNow:(NSTimeInterval)now location:(CLLocation*)location;
-(void)queueAllNow;

@end
