//
//  AccSampleHandler.m
//  Swedsleep
//
//  Created by Mats Berggrund on 10/11/13.
//  Copyright (c) 2013 SwirlySpace AB. All rights reserved.
//

#import "AccSampleHandler.h"
#import "SettingsDb.h"

@implementation AccSampleHandler {
    NSMutableArray* arr;
    NSMutableArray* garr;
    NSMutableArray* parr;
}

+ (AccSampleHandler*)sharedInstance
{
    static AccSampleHandler* instance=nil;
    if (instance == nil)
    {
        instance = [AccSampleHandler new];
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        arr = [NSMutableArray array];
        garr = [NSMutableArray array];
        parr = [NSMutableArray array];
    }
    return self;
}

-(void)queueData:(NSMutableArray*)array1 tag:(NSString*)tag1
           data2:(NSMutableArray*)array2 tag:(NSString*)tag2
           data3:(NSMutableArray*)array3 tag:(NSString*)tag3
{
    NSMutableDictionary * dict = [NSMutableDictionary new];
    
    if (array1.count!=0) dict[tag1]=array1;
    if (array2.count!=0) dict[tag2]=array2;
    if (array3.count!=0) dict[tag3]=array3;
    
    NSData * jsondata = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
    NSString * jsonstring = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
    NSDictionary* samples = @{@"DataJSON":jsonstring,
                              @"DeviceId":[SettingsDb sharedInstance].deviceId,
                              @"FromTimestamp":array1.firstObject[0],
                              @"ToTimestamp":array1.lastObject[0]};
    //[[DBHandler sharedInstance] addQueueEntry:samples];
    [array1 removeAllObjects];
    [array2 removeAllObjects];
    [array3 removeAllObjects];
    
    DLog(@"Queuing %@", [SettingsDb sharedInstance].deviceId);
    //DLog(@"%@",samples);
}

-(void)addSampleNow:(NSTimeInterval)now sampleTime:(NSTimeInterval)sampleTime x:(double)x y:(double)y z:(double)z
{
    // format is: [dateNow, sampleTime, x, y, z]
    [arr addObject:@[[NSNumber numberWithDouble:now],
                     [NSNumber numberWithDouble:sampleTime],
                     [NSNumber numberWithDouble:x],
                     [NSNumber numberWithDouble:y],
                     [NSNumber numberWithDouble:z]]];
    if (arr.count>=1000)
    {
        //[self queueData:arr tag:@"accel" data2:garr tag:@"gyro" data3:parr tag:@"gnss"];
    }
}

-(void)addSampleNow:(NSTimeInterval)now sampleTime:(NSTimeInterval)sampleTime gx:(double)x gy:(double)y gz:(double)z
{
    // format is: [dateNow, sampleTime, gx, gy, gz]
    [garr addObject:@[[NSNumber numberWithDouble:now],
                      [NSNumber numberWithDouble:sampleTime],
                      [NSNumber numberWithDouble:x],
                      [NSNumber numberWithDouble:y],
                      [NSNumber numberWithDouble:z]]];
    if (garr.count>=1000)
    {
        //[self queueData:arr tag:@"accel" data2:garr tag:@"gyro" data3:parr tag:@"gnss"];
    }
}

-(void)addSampleNow:(NSTimeInterval)now location:(CLLocation*)location
{
    // format is: [dateNow, gpsTime, accuracy, lat, long, speed, course]
    [parr addObject:@[[NSNumber numberWithDouble:now],
                      [NSNumber numberWithDouble:location.timestamp.timeIntervalSince1970],
                      [NSNumber numberWithDouble:location.horizontalAccuracy],
                      [NSNumber numberWithDouble:location.coordinate.latitude],
                      [NSNumber numberWithDouble:location.coordinate.longitude],
                      [NSNumber numberWithDouble:location.speed],
                      [NSNumber numberWithDouble:location.course]]];
    
    if (parr.count>=60)
    {
        //[self queueData:arr tag:@"accel" data2:garr tag:@"gyro" data3:parr tag:@"gnss"];
    }
}

-(void)queueAllNow
{
    DLog(@"Queuing all");
    //[self queueData:arr tag:@"accel" data2:garr tag:@"gyro" data3:parr tag:@"gnss"];
}


@end
