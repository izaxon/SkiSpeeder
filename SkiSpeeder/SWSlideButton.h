//
//  SWSlideButton.h
//  SlideToCancel
//
//  Created by Mats Berggrund on 2011-11-11.
//  Copyright (c) 2011 SwirlySpace AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWSlideButton : UIControl {
    UIImageView * buttonView;
    UIImageView *trackBackgroundView;
	UISlider *slider;
	UILabel *label;
    
    UIImage* buttonBgNormal;
    UIImage *trackBackgroundImage;
    UIImage *thumbImage;
    
    BOOL touchIsDown;
}

@property(nonatomic, strong) NSString* title;

@end
