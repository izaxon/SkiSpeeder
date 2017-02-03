//
//  MeasureViewController.m
//  Swedsleep
//
//  Created by Mats Berggrund on 09/11/13.
//  Copyright (c) 2013 SwirlySpace AB. All rights reserved.
//

#import "MeasureViewController.h"
#import "SWSlideButton.h"

@import AVFoundation;

// VIDEO
//#include "OpenGLPixelBufferView.h"

const double FREEFALLLIMIT = 0.3;
const double GFORCELIMIT   = 1.2;
const double GFORCEMINTIME = 1.0;

@implementation MeasureViewController {
    AccSampleHandler* accSampleHandler;
    BOOL measuring;
    double scale;
    AVSpeechSynthesizer* ss;
    AVSpeechSynthesisVoice* voice;
    double maxs;
    NSDate* freefallstarted;
    NSDate* gforcestarted;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        accSampleHandler = [AccSampleHandler sharedInstance];
        measuring=NO;
        maxs=0;
        freefallstarted = nil;
        gforcestarted = nil;
        ss = [AVSpeechSynthesizer new];
        //voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"];
        voice = [self findVoice:@"Aaron"];
        DLog(@"%@",voice);
        
        DLog(@"%@",[AVSpeechSynthesisVoice speechVoices]);
        
        [NSTimer scheduledTimerWithTimeInterval:60 repeats:YES block:^(NSTimer * _Nonnull timer) {
            if (self->measuring && self->maxs>=40)
            {
                NSString* str = [NSString stringWithFormat:@"Max speed last minute was %.0lf kph.",maxs];
                self->maxs=0;
                [self say:str];
            }
        }];
    }
    return self;
}

-(AVSpeechSynthesisVoice*)findVoice:(NSString*)name
{
    NSArray<AVSpeechSynthesisVoice *> * voices = [AVSpeechSynthesisVoice speechVoices];
    for (AVSpeechSynthesisVoice * v in voices)
    {
        if ([v.name isEqualToString:name]) return v;
    }
    return nil;
}

-(void)loadView
{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor redColor];
    
    SWSlideButton* slb = [[SWSlideButton alloc] initWithFrame:CGRectMake(10, 100, 280, 60)];
    slb.tag = 10001;
    slb.backgroundColor = [UIColor grayColor];
    slb.title = @"Slide to start";
    [slb addTarget:self action:@selector(startStop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:slb];
    
    UILabel* l = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 60)];
    l.tag = 10002;
    l.backgroundColor = [UIColor clearColor];
    l.text = @"-";
    l.textAlignment = NSTextAlignmentCenter;
    l.textColor = [UIColor blackColor];
    l.font = [UIFont boldSystemFontOfSize:30];
    [self.view addSubview:l];
}

- (void)startStop
{
    measuring = !measuring;
    SWSlideButton* slb = (SWSlideButton*)[self.view viewWithTag:10001];
    UILabel* l = (UILabel*)[self.view viewWithTag:10002];
    if (measuring)
    {
        [self enableMeasure];
        l.textColor = [UIColor greenColor];
        slb.title = @"Slide to stop";
    }
    else
    {
        [self disableMeasure];
        l.textColor = [UIColor blackColor];
        slb.title = @"Slide to start";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)addBlocker
{
    UIView* gl = [self.view viewWithTag:77];
    UIView * blocker = [UIView new];
    blocker.bounds = gl.bounds;
    blocker.center = CGPointMake(gl.bounds.size.width/2, gl.bounds.size.height/2);
    blocker.tag = 111;
    blocker.backgroundColor = [UIColor whiteColor];
    blocker.alpha = 0.5;
    [gl addSubview:blocker];
}

-(void)removeBlocker
{
    UIView* gl = [self.view viewWithTag:77];
    UIView* blocker = [gl viewWithTag:111];
    [blocker removeFromSuperview];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self addBlocker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)enableMeasure
{
    [self removeBlocker];
    if (!self.motionManager)
    {
        self.motionManager = [CMMotionManager new];
        self.motionManager.deviceMotionUpdateInterval=1.0/50.0; // 50Hz

        NSOperationQueue* opqueue = [NSOperationQueue new];
        opqueue.maxConcurrentOperationCount = 1;
        [self.motionManager startDeviceMotionUpdatesToQueue:opqueue withHandler:^(CMDeviceMotion *accelerometerData, NSError *error)
        {
            static double a = 0;
            static double gforcemax = 0;
            
            double x = accelerometerData. gravity.x;
            double y = accelerometerData.gravity.y;
            double z = accelerometerData.gravity.z;
            double xa = accelerometerData.userAcceleration.x;
            double ya = accelerometerData.userAcceleration.y;
            double za = accelerometerData.userAcceleration.z;
            
            x = x+xa;
            y = y+ya;
            z = z+za;
            double g = sqrt(x*x+y*y+z*z);
            double old_a = a;
            a = a * 0.9 + g * 0.1;
            //NSLog(@"a = %.1lf, %.1lf", a, g);
            
            // Free fall logic
            if (old_a > FREEFALLLIMIT && a <= FREEFALLLIMIT)
            {
                freefallstarted = [NSDate date];
            }
            if (a>FREEFALLLIMIT && freefallstarted!=nil)
            {
                NSString* s = [NSString stringWithFormat:@"Free fall for %.1lf seconds", -[freefallstarted timeIntervalSinceNow]];
                [self say:s];
                freefallstarted = nil;
            }

            // gforce logic
            gforcemax = MAX(gforcemax,a);
            if (old_a < GFORCELIMIT && a >= GFORCELIMIT)
            {
                gforcestarted = [NSDate date];
                gforcemax = a;
            }
            if (a<GFORCELIMIT && gforcestarted!=nil)
            {
                double duration = -[gforcestarted timeIntervalSinceNow];
                if (duration>GFORCEMINTIME)
                {
                    NSString* s = [NSString stringWithFormat:@"%.1lf,G", gforcemax];
                    [self say:s];
                }
                gforcestarted = nil;
            }
        }];
    }
    
    if (!self.locationManager)
    {
        CLAuthorizationStatus astatus = [CLLocationManager authorizationStatus];
        switch(astatus) {
            case kCLAuthorizationStatusRestricted:
            case kCLAuthorizationStatusDenied:
                break;
                
            case kCLAuthorizationStatusNotDetermined:
            default:
                self.locationManager = [CLLocationManager new];
                if (astatus==kCLAuthorizationStatusNotDetermined) [self.locationManager requestAlwaysAuthorization];
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                self.locationManager.delegate = self;
                self.locationManager.pausesLocationUpdatesAutomatically=NO;
                [self.locationManager startUpdatingLocation];
                break;
        }
    }
    
    [self say:@"Ski Speeder enabled"];
}

- (void)say:(NSString*)text
{
    AVSpeechUtterance* su = [AVSpeechUtterance speechUtteranceWithString:text];
    su.voice = voice;
    [ss speakUtterance:su];

    NSLog(@"%@", text);
}

- (void)disableMeasure
{
    //OpenGLPixelBufferView* gl = [self.view viewWithTag:77];
    //[gl stopRecordingAndSave:YES];

    [self addBlocker];
    [self.motionManager stopDeviceMotionUpdates];
    self.motionManager=nil;
    
    [self.locationManager stopUpdatingLocation];
    self.locationManager=nil;
    
    [accSampleHandler queueAllNow];
    
    [self say:@"Ski Speeder disabled"];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //NSDate* now = [NSDate date];
    CLLocation* loc = [locations lastObject];
    if (loc && loc.speed >= 0 && loc.horizontalAccuracy<50)
    {
        double speed = loc.speed * 3.6;
        
        //[accSampleHandler addSampleNow:now.timeIntervalSince1970 location:loc];
        static double s = 0;
        static double saidspeed = 0;
//        static double old_s = 0;
        
        double prev_s = s;
        s = 0.5 * s + 0.5 * speed;
        NSLog(@"s = %lf, speed = %lf", s, speed);
        
        
        /*
        if (fabs(s - old_s) > 5 && s>9)
        {
            [self say:[NSString stringWithFormat:@"New speed %.0lf kph.", s]];
            old_s = s;
        }*/
        
        maxs = s>maxs?s:maxs;
        
        if (s >= 90 && prev_s < 90)
        {
            [self say:[NSString stringWithFormat:@"Fuck off! Reached 90!"]];
        }
        else if (s >= 80 && prev_s < 80)
        {
            [self say:[NSString stringWithFormat:@"Amazing dude! You are seriously fast! Topping 80 kph."]];
        }
        else if (s >= 70 && prev_s < 70)
        {
            [self say:[NSString stringWithFormat:@"Now we are talking dude! You are speeding at 70 kph."]];
        }
        else if (s >= 60 && prev_s < 60)
        {
            [self say:[NSString stringWithFormat:@"60!?! Wow, come on dude!"]];
        }
        else if (s >= 50 && prev_s < 50)
        {
            [self say:[NSString stringWithFormat:@"Reached 50. Take it eazy!"]];
        }
        else if (s >= 40 && prev_s < 40)
        {
            [self say:[NSString stringWithFormat:@"Topping 40. Running?"]];
        }
        else if (s >= 30 && prev_s < 30)
        {
            [self say:[NSString stringWithFormat:@"Going 30. Tough day?"]];
        }
        else if (s >= 20 && prev_s < 20)
        {
            [self say:[NSString stringWithFormat:@"Racing with granny?"]];
        }
    }
}

- (void)setQueuedMessages:(NSNumber*)queuedMessages
{
    UILabel* l = (UILabel*)[self.view viewWithTag:10002];
    l.text = [NSString stringWithFormat:@"%@",queuedMessages];
}

/*
- (void)overlayRenderer:(CGContextRef)context size:(CGSize)size
{
    
}*/

- (void)recordingDidStart
{
    
}

- (void)recordingDidStopWithError:(NSError*)error
{
    
}

- (void)recordingDidStopWithUrl:(NSURL*)assetUrl
{
    NSLog(@"Recording %@", assetUrl);
    // http://stackoverflow.com/questions/4545982/getting-video-from-alasset
}

- (void)recordingDiskFull
{
    
}

- (bool)isMeasureEnabled
{
    return measuring;
}

@end
