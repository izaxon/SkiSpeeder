//
//  SWSlideButton.m
//  SlideToCancel
//
//  Created by Mats Berggrund on 2011-11-11.
//  Copyright (c) 2011 SwirlySpace AB. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SWSlideButton.h"

@implementation SWSlideButton

- (id)init
{
    return [self initWithFrame:CGRectNull];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.cornerRadius = 6;
        touchIsDown=NO;
        // =========================================
        // the main buttonview with the button image
        buttonBgNormal = [UIImage imageNamed: @"TSAlertViewButtonBackground"];
        buttonBgNormal = [buttonBgNormal stretchableImageWithLeftCapWidth:buttonBgNormal.size.width/2.0
                                                             topCapHeight:buttonBgNormal.size.height/2.0];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, buttonBgNormal.size.height);
        
        if (frame.size.height==0)
        {
            frame.size.height = buttonBgNormal.size.height;
            self.frame = frame;
        }
        
        UIImage* buttonBgHigh = [UIImage imageNamed: @"TSAlertViewButtonBackground_Highlighted"];
        buttonBgHigh = [buttonBgHigh stretchableImageWithLeftCapWidth:buttonBgHigh.size.width/2.0
                                                         topCapHeight: buttonBgHigh.size.height/2.0];
        
        // Create the view same size as the given BUT the height is taken directly from the TSAlertViewButtonBackground and cannot be changed
        buttonView = [[UIImageView alloc] initWithImage:buttonBgNormal highlightedImage:buttonBgHigh];
        buttonView.userInteractionEnabled=YES;
        //buttonView.backgroundColor = [UIColor colorWithRed:0 green:157.0/255.0 blue:224.0/255.0 alpha:1]; // make the button KeyWeight blue
        [self addSubview:buttonView];
        
        
        // =========================
        // Load the track background
        trackBackgroundImage = [UIImage imageNamed:@"sliderTrack2"];
        trackBackgroundImage = [trackBackgroundImage stretchableImageWithLeftCapWidth:trackBackgroundImage.size.width/2.0
                                                                         topCapHeight:trackBackgroundImage.size.height/2.0];
        
        trackBackgroundView = [[UIImageView alloc] initWithImage:trackBackgroundImage];
        trackBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:.2];
        trackBackgroundView.layer.cornerRadius = 3;
        trackBackgroundView.clipsToBounds=YES;
        trackBackgroundView.alpha=.7;
        [buttonView addSubview:trackBackgroundView];
        
        
        // =========================
        // Add the slider with correct geometry centered over the track
        slider = [UISlider new];
        //slider.backgroundColor = [UIColor whiteColor];
        [slider setMinimumTrackImage:[UIImage imageNamed:@"sliderMaxMin-02"] forState:UIControlStateNormal];
        [slider setMaximumTrackImage:[UIImage imageNamed:@"sliderMaxMin-02"] forState:UIControlStateNormal];
        thumbImage = [UIImage imageNamed:@"sliderThumb2"];
        [slider setThumbImage:thumbImage forState:UIControlStateNormal];
        slider.minimumValue = 0.0;
        slider.maximumValue = 1.0;
        slider.continuous = YES;
        slider.value = 0.0;
        
        
        // ========================
        // label
        // Create the label with the actual size required by the text
        UIFont *labelFont = [UIFont systemFontOfSize:18];
        label = [UILabel new];
        // Set other label attributes and add it to the view
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = labelFont;
        label.shadowColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
        label.shadowOffset = CGSizeMake(0, -1);
        [buttonView addSubview:label];
        [buttonView addSubview:slider];
        
        [self setNeedsLayout];
        
        
        
        // Set the slider action methods
        [slider addTarget:self 
                   action:@selector(sliderUp:) 
         forControlEvents:UIControlEventTouchUpInside];
        
        [slider addTarget:self 
                   action:@selector(sliderUpOutside:) 
         forControlEvents:UIControlEventTouchUpOutside];
        
        [slider addTarget:self 
                   action:@selector(sliderDown:) 
         forControlEvents:UIControlEventTouchDown];
        
        [slider addTarget:self 
                   action:@selector(sliderChanged:) 
         forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)layoutSubviews
{
    CGRect frame = self.frame;
    
    // Button image view
    float buttonYPos = (frame.size.height-buttonBgNormal.size.height)/2;
    if (buttonYPos<0) buttonYPos=0;
    CGRect buttonRect = CGRectMake(0, buttonYPos, frame.size.width, buttonBgNormal.size.height);
    buttonView.frame = buttonRect;
    
    // slider track
    CGRect trackRect = CGRectMake(8, 8, buttonRect.size.width-16, trackBackgroundImage.size.height+6);
    trackBackgroundView.frame = trackRect;
    
    // slider
    CGRect sliderFrame = trackBackgroundView.bounds;
    sliderFrame.size.width -= 6;
    slider.frame = sliderFrame;
    slider.center = trackBackgroundView.center;
    
    // label
    CGSize labelSize = [label.text sizeWithFont:label.font];
    label.frame = CGRectMake(0.0, 0.0, labelSize.width, labelSize.height);
    // Center the label over the slidable portion of the track
    CGFloat labelHorizontalCenter = (int)(slider.center.x + (thumbImage.size.width / 2));
    label.center = CGPointMake(labelHorizontalCenter, (int)(slider.center.y));
}

- (NSString*)title
{
    return label.text;
}

- (void)setTitle:(NSString *)title
{
    label.text = title;
    [self setNeedsLayout];
}


// UISlider actions
- (void) sliderUpOutside: (UISlider *) sender
{
	if (touchIsDown) {
		touchIsDown = NO;
        [slider setValue: 0 animated: YES];
        label.textColor=[UIColor whiteColor];
        buttonView.highlighted=NO;
	}
}

- (void) sliderUp: (UISlider *) sender
{
	//filter out duplicate sliderUp events
	if (touchIsDown) {
		touchIsDown = NO;
		
		if (slider.value == 1.0)  //if the value is not the max, slide this bad boy back to zero
		{
			//tell the delagate we are slid all the way to the right
            [self sendActionsForControlEvents:UIControlEventTouchUpInside];
		}
        [slider setValue: 0 animated: YES];
        label.textColor=[UIColor whiteColor];
        buttonView.highlighted=NO;
	}
}

- (void) sliderDown: (UISlider *) sender
{
	touchIsDown = YES;
}

- (void) sliderChanged: (UISlider *) sender
{
    label.textColor = [UIColor colorWithRed:1 green:1.0-slider.value blue:1.0-slider.value alpha:1];
	
	// Stop the animation if the slider moved off the zero point
    buttonView.highlighted = (slider.value==1.0);
}

@end
