//
//  AppDelegate.m
//  Swedsleep
//
//  Created by Mats Berggrund on 09/11/13.
//  Copyright (c) 2013 SwirlySpace AB. All rights reserved.
//

#import "AppDelegate.h"
//#import "Azure.h"

@import AVFoundation;

@implementation AppDelegate {
    NSThread* queueThread;
    UIBackgroundTaskIdentifier backid;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    application.idleTimerDisabled=YES;
    
//	self.registerController = [RegisterViewController new];
    
    self.measureController = [MeasureViewController new];
    self.measureController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    backid = UIBackgroundTaskInvalid;

    // Add the view controller's view to the window and display.
    [self.window setRootViewController:self.measureController];
    [self.window makeKeyAndVisible];
    
    // Start the queue handler thread
    queueThread = [[NSThread alloc] initWithTarget:self selector:@selector(queueHandlerThread) object:nil];
    queueThread.threadPriority = 0.1;
    [queueThread start];
    
    NSError *error = NULL;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    if(error) {
        // Do some error handling
    }
    [session setActive:YES error:&error];
    if (error) {
        // Do some error handling
    }
    
    [self.measureController say:@"gday sir, time to get going?"];
    
    return YES;
}
/*
-(void)registerOk
{
    if (!self.measureController)
    {
        self.measureController = [MeasureViewController new];
        self.measureController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.registerController presentViewController:self.measureController animated:YES completion:^{
        }];

        [self queueEntryAdded]; // make an initial check of the out-queue
    }
    //[self.measureController enableMeasure];
}
*/

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    // [self.measureController disableMeasure];
    // we dont do this since we want it to sample also in the backgorund
    DLog(@"ResignActive");
    if (self.measureController.isMeasureEnabled)
    {
        DLog(@"beginBackgroundTaskWithExpirationHandler");
        backid = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [self.measureController say:@"Getting sleepy here"];
        }];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    DLog(@"Background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    DLog(@"Foreground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (backid != UIBackgroundTaskInvalid) {
        DLog(@"endBackgroundTask");
        [[UIApplication sharedApplication] endBackgroundTask:backid];
    }
    backid = UIBackgroundTaskInvalid;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //[self.measureController enableMeasure];
    DLog(@"BecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    DLog(@"Terminate");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)queueEntryAdded
{
    [self performSelector:@selector(handleQueue) onThread:queueThread withObject:nil waitUntilDone:NO];
}

-(void)queueHandlerThread
{
    NSLog(@"Starting queue handler thread");
    while (1) {
        [[NSRunLoop currentRunLoop] run];
        [NSThread sleepForTimeInterval:.5];
    }
}

/*
static BOOL inInsert=NO;
- (void)handleQueue2
{
    inInsert=NO;
    [self handleQueue];
}


- (void)handleQueue
{
    if (inInsert) return;
    NSDictionary* samples=nil;
    int cnt = [[DBHandler sharedInstance] queueEntries];
    [self.measureController performSelectorOnMainThread:@selector(setQueuedMessages:) withObject:[NSNumber numberWithInt:cnt] waitUntilDone:NO];
    
    int64_t queueId = [[DBHandler sharedInstance] nextQueueEntry:&samples];
    if (queueId!=0)
    {
#ifdef DEBUG
        NSDate* t1 = [NSDate date];
#endif
        inInsert=YES;
        [azureDataTable insert:samples completion:^(NSDictionary *insertedItem, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
                // try again after 30 secs
                [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(handleQueue2) userInfo:nil repeats:NO];
            } else {
                DLog(@"Sample %lld uploaded, took %lf secs", queueId, [[NSDate date] timeIntervalSinceDate:t1]);

#if 0
                NSData * jsondata = [NSJSONSerialization dataWithJSONObject:insertedItem options:NSJSONWritingPrettyPrinted error:NULL];
                NSString * jsonstring = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
                DLog(@"%@",jsonstring);
#endif
                
                [[DBHandler sharedInstance] removeQueueEntry:queueId];
                [self performSelector:@selector(handleQueue2) onThread:queueThread withObject:nil waitUntilDone:NO];
            }
        }];
    }
}
 */

@end
