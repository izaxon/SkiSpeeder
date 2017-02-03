//
//  RegisterInputView.h
//  Swedsleep
//
//  Created by Mats Berggrund on 09/11/13.
//  Copyright (c) 2013 SwirlySpace AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RegisterInputView;

@protocol RegisterInputViewDelegate <NSObject>
@optional
-(void)registerPressed:(RegisterInputView*)v;
@end

@interface RegisterInputView : UIView <UITextFieldDelegate>
@property (weak, nonatomic) id <RegisterInputViewDelegate> delegate;

-(NSString*)getUserCode;
-(void)showSpinner:(BOOL)show;

@end
