//
//  SettingsDb.m
//  Traffic
//
//  Created by Mats Berggrund on 2011-04-28.
//  Copyright 2011 SwirlySpace AB. All rights reserved.
//

#import "SettingsDb.h"


@implementation SettingsDb

+ (SettingsDb*)sharedInstance
{
    static SettingsDb* instance=nil;
    if (!instance)
    {
        instance = [SettingsDb new];
    }
    return instance;
}

-(id)init
{
    self = [super init];
    defaults = [NSUserDefaults standardUserDefaults];
    return self;
}

- (BOOL)boolForKey:(NSString*)key withDefaultValue:(BOOL)d
{
    if (![defaults objectForKey:key]) return d;
    else return [defaults boolForKey:key];
}

- (float)floatForKey:(NSString*)key withDefaultValue:(float)f
{
    if (![defaults objectForKey:key]) return f;
    else return [defaults floatForKey:key];
}

- (unsigned int)unsignedIntForKey:(NSString*)key withDefaultValue:(unsigned int)f
{
    if (![defaults objectForKey:key]) return f;
    else return (unsigned int)[defaults integerForKey:key];
}

- (NSString*)stringForKey:(NSString*)key withDefaultValue:(NSString*)f
{
    if (![defaults objectForKey:key]) return f;
    else return [defaults stringForKey:key];
}

- (id)objectForKey:(NSString*)key withDefaultValue:(id)f
{
    if (![defaults objectForKey:key]) return f;
    else return [defaults objectForKey:key];
}

- (void)synchronize
{
    [defaults synchronize];
}

/*
// my settings
- (void)setSpeedWarningEnabled:(BOOL)speedWarning
{
    [defaults setBool:speedWarning forKey:@"TR_SPEED_WARNING_ENABLED"];
}
- (BOOL)speedWarningEnabled
{
    return [self boolForKey:@"TR_SPEED_WARNING_ENABLED" withDefaultValue:YES];
}

- (void)setSpeedWarningLevel:(float)speedWarningLevel
{
    [defaults setFloat:speedWarningLevel forKey:@"TR_SPEED_WARNING_LEVEL"];    
}
- (float)speedWarningLevel
{
    return [self floatForKey:@"TR_SPEED_WARNING_LEVEL" withDefaultValue:10.0];
}

- (void)setManualReportConfirmation:(BOOL)confirm
{    
    [defaults setBool:confirm forKey:@"TR_REPORT_CONFIRM"];    
}
- (BOOL)manualReportConfirmation
{
    return [self boolForKey:@"TR_REPORT_CONFIRM" withDefaultValue:YES];    
}

- (void)setGuiSoundEnabled:(BOOL)soundEnabled
{
    [defaults setBool:soundEnabled forKey:@"TR_GUI_SOUND"];        
}
- (BOOL)guiSoundEnabled
{
    return [self boolForKey:@"TR_GUI_SOUND" withDefaultValue:YES];        
}


- (void)setShowRoadWorks:(BOOL)show
{
    [defaults setBool:show forKey:@"TR_SHOW_ROAD_WORKS"];        
}
- (BOOL)showRoadWorks
{
    return [self boolForKey:@"TR_SHOW_ROAD_WORKS" withDefaultValue:YES];        
}

- (void)setShowSpeedCameras:(BOOL)show
{
    [defaults setBool:show forKey:@"TR_SHOW_SPEED_CAMERAS"];        
}
- (BOOL)showSpeedCameras
{
    return [self boolForKey:@"TR_SHOW_SPEED_CAMERAS" withDefaultValue:YES];        
}

- (void)setShowPoliceControls:(BOOL)show
{
    [defaults setBool:show forKey:@"TR_SHOW_POLICE_CONTROLS"];        
}
- (BOOL)showPoliceControls
{
    return [self boolForKey:@"TR_SHOW_POLICE_CONTROLS" withDefaultValue:YES];        
}

- (void)setShowAccidents:(BOOL)show
{
    [defaults setBool:show forKey:@"TR_SHOW_ACCIDENTS"];        
}
- (BOOL)showAccidents
{
    return [self boolForKey:@"TR_SHOW_ACCIDENTS" withDefaultValue:YES];        
}

- (void)setShowQueues:(BOOL)show
{
    [defaults setBool:show forKey:@"TR_SHOW_QUEUES"];        
}
- (BOOL)showQueues
{
    return [self boolForKey:@"TR_SHOW_QUEUES" withDefaultValue:YES];        
}

- (void)setShowOther:(BOOL)show
{
    [defaults setBool:show forKey:@"TR_SHOW_OTHER"];        
}
- (BOOL)showOther
{
    return [self boolForKey:@"TR_SHOW_OTHER" withDefaultValue:YES];        
}

- (void)setUGCSeqId:(unsigned int)seqid
{
    [defaults setInteger:(int)seqid forKey:@"UGC_SEQID"];
}
- (unsigned int)uGCSeqId
{
    return [self unsignedIntForKey:@"UGC_SEQID" withDefaultValue:1];            
}

- (void)setVersion:(NSString*)version
{
    [defaults setObject:version forKey:@"TR_VERSION"];    
}
- (NSString*)version
{
    return [self stringForKey:@"TR_VERSION" withDefaultValue:@""];                
}
*/

- (void)setDeviceId:(NSString*)did
{
    [defaults setObject:did forKey:@"SL_DID"];
}

- (NSString*)deviceId
{
    return [self stringForKey:@"SL_DID" withDefaultValue:@""];
}

- (void)setUserCode:(NSString*)uc
{
    [defaults setObject:uc forKey:@"SL_UC"];
}

- (NSString*)userCode
{
    return [self stringForKey:@"SL_UC" withDefaultValue:@""];
}

@end
