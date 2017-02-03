//
//  RegisterInputView.m
//  Swedsleep
//
//  Created by Mats Berggrund on 09/11/13.
//  Copyright (c) 2013 SwirlySpace AB. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "RegisterInputView.h"

#define TAG_INPUT1  (1001)
#define TAG_INPUT2  (1002)
#define TAG_INPUT3  (1003)
#define TAG_INPUT4  (1004)

#define TAG_BUTTON  (1010)
#define TAG_LINE    (1020)

#define TAG_DASH12  (1100)
#define TAG_DASH23  (1101)
#define TAG_DASH34  (1102)

#define TAG_ACTIVITY (1110)

#define FIELD_TEXT_SIZE (20)
#define FIELD_MARGIN    (10)
#define FIELD_SPACE     (20)
#define FIELD_BG_COLOR  [UIColor colorWithWhite:.95 alpha:1]

#define DASH_COLOR      [UIColor grayColor]


@implementation RegisterInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.layer.borderWidth = 1;
        
        UITextField* registerText = [UITextField new];
        registerText.font = [UIFont boldSystemFontOfSize:FIELD_TEXT_SIZE];
        registerText.backgroundColor = FIELD_BG_COLOR;
        registerText.tag = TAG_INPUT1;
        registerText.textColor = [UIColor blackColor];
        registerText.keyboardType = UIKeyboardTypeNumberPad;
        [registerText becomeFirstResponder];
        registerText.delegate=self;
        registerText.adjustsFontSizeToFitWidth=YES;
        [self addSubview:registerText];

        registerText = [UITextField new];
        registerText.font = [UIFont boldSystemFontOfSize:FIELD_TEXT_SIZE];
        registerText.backgroundColor = FIELD_BG_COLOR;
        registerText.tag = TAG_INPUT2;
        registerText.textColor = [UIColor blackColor];
        registerText.keyboardType = UIKeyboardTypeNumberPad;
        registerText.delegate=self;
        registerText.adjustsFontSizeToFitWidth=YES;
        [self addSubview:registerText];
        
        registerText = [UITextField new];
        registerText.font = [UIFont boldSystemFontOfSize:FIELD_TEXT_SIZE];
        registerText.backgroundColor = FIELD_BG_COLOR;
        registerText.tag = TAG_INPUT3;
        registerText.textColor = [UIColor blackColor];
        registerText.keyboardType = UIKeyboardTypeNumberPad;
        registerText.delegate=self;
        registerText.adjustsFontSizeToFitWidth=YES;
        [self addSubview:registerText];
        
        registerText = [UITextField new];
        registerText.font = [UIFont boldSystemFontOfSize:FIELD_TEXT_SIZE];
        registerText.backgroundColor = FIELD_BG_COLOR;
        registerText.tag = TAG_INPUT4;
        registerText.textColor = [UIColor blackColor];
        registerText.keyboardType = UIKeyboardTypeNumberPad;
        registerText.delegate=self;
        registerText.adjustsFontSizeToFitWidth=YES;
        [self addSubview:registerText];
        
        UILabel* dashLabel = [UILabel new];
        dashLabel.tag = TAG_DASH12;
        dashLabel.textAlignment = NSTextAlignmentCenter;
        dashLabel.text = @"-";
        dashLabel.textColor = DASH_COLOR;
        dashLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:dashLabel];
        
        dashLabel = [UILabel new];
        dashLabel.tag = TAG_DASH23;
        dashLabel.textAlignment = NSTextAlignmentCenter;
        dashLabel.text = @"-";
        dashLabel.textColor = DASH_COLOR;
        dashLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:dashLabel];
        
        dashLabel = [UILabel new];
        dashLabel.tag = TAG_DASH34;
        dashLabel.textAlignment = NSTextAlignmentCenter;
        dashLabel.text = @"-";
        dashLabel.textColor = DASH_COLOR;
        dashLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:dashLabel];
        
        UIButton* registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [registerButton setTitle:NSLocalizedString(@"REGISTER",nil) forState:UIControlStateNormal];
        registerButton.backgroundColor = [UIColor clearColor];
        registerButton.tag = TAG_BUTTON;
        [self addSubview:registerButton];
        [registerButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView* line = [UIView new];
        line.backgroundColor = [UIColor darkGrayColor];
        line.tag = TAG_LINE;
        [self addSubview:line];
        
        UIActivityIndicatorView* act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        act.tag = TAG_ACTIVITY;
        act.hidesWhenStopped=YES;
        act.color = [UIColor blackColor];
        [self addSubview:act];
        
        [self evaluateUserCodeLength];
        
        [self layoutMyView];
    }
    return self;
}

- (void)buttonPressed
{
    [self.delegate registerPressed:self];
}

- (void)layoutMyView
{
    CGRect r = self.bounds;
    float fieldWidth = (r.size.width-2*FIELD_MARGIN-3*FIELD_SPACE)/4.0;
    
    UITextField* registerText = (UITextField*)[self viewWithTag:TAG_INPUT1];
    registerText.frame = CGRectMake(FIELD_MARGIN+(fieldWidth+FIELD_SPACE)*0, r.size.height/8, fieldWidth, r.size.height/4);

    registerText = (UITextField*)[self viewWithTag:TAG_INPUT2];
    registerText.frame = CGRectMake(FIELD_MARGIN+(fieldWidth+FIELD_SPACE)*1, r.size.height/8, fieldWidth, r.size.height/4);
    
    registerText = (UITextField*)[self viewWithTag:TAG_INPUT3];
    registerText.frame = CGRectMake(FIELD_MARGIN+(fieldWidth+FIELD_SPACE)*2, r.size.height/8, fieldWidth, r.size.height/4);
    
    registerText = (UITextField*)[self viewWithTag:TAG_INPUT4];
    registerText.frame = CGRectMake(FIELD_MARGIN+(fieldWidth+FIELD_SPACE)*3, r.size.height/8, fieldWidth, r.size.height/4);
    
    UILabel* dashLabel = (UILabel*)[self viewWithTag:TAG_DASH12];
    dashLabel.frame = CGRectMake(FIELD_MARGIN+fieldWidth+(fieldWidth+FIELD_SPACE)*0, r.size.height/8, FIELD_SPACE, r.size.height/4);
    
    dashLabel = (UILabel*)[self viewWithTag:TAG_DASH23];
    dashLabel.frame = CGRectMake(FIELD_MARGIN+fieldWidth+(fieldWidth+FIELD_SPACE)*1, r.size.height/8, FIELD_SPACE, r.size.height/4);
    
    dashLabel = (UILabel*)[self viewWithTag:TAG_DASH34];
    dashLabel.frame = CGRectMake(FIELD_MARGIN+fieldWidth+(fieldWidth+FIELD_SPACE)*2, r.size.height/8, FIELD_SPACE, r.size.height/4);
    
    UIButton* registerButton = (UIButton*)[self viewWithTag:TAG_BUTTON];
    registerButton.frame = CGRectMake(5, r.size.height/2, r.size.width-10, r.size.height/2);
    
    UIActivityIndicatorView* act = (UIActivityIndicatorView*)[self viewWithTag:TAG_ACTIVITY];
    act.frame = CGRectMake(r.size.width-50, r.size.height/2+(r.size.height/2-40)/2, 40, 40);
    
    UIView* line = [self viewWithTag:TAG_LINE];
    line.frame = CGRectMake(0, r.size.height/2, r.size.width, 1);
}

- (void)showSpinner:(BOOL)show
{
    UIActivityIndicatorView* act = (UIActivityIndicatorView*)[self viewWithTag:TAG_ACTIVITY];
    if (show)
    {
        [act startAnimating];
    }
    else
    {
        [act stopAnimating];
    }
}

- (void)disable
{
    
    /* TODO
    UITextField* registerText = (UITextField*)[self viewWithTag:TAG_INPUT];
    registerText.enabled=NO;
    UIButton* registerButton = (UIButton*)[self viewWithTag:TAG_BUTTON];
    registerButton.enabled=NO;*/
}

- (void)layoutSubviews
{
    [self layoutMyView];
}

-(NSString*)getUserCode
{
    UITextField* registerText1 = (UITextField*)[self viewWithTag:TAG_INPUT1];
    UITextField* registerText2 = (UITextField*)[self viewWithTag:TAG_INPUT2];
    UITextField* registerText3 = (UITextField*)[self viewWithTag:TAG_INPUT3];
    UITextField* registerText4 = (UITextField*)[self viewWithTag:TAG_INPUT4];
    return [NSString stringWithFormat:@"%@%@%@%@", registerText1.text,registerText2.text,registerText3.text,registerText4.text];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* newstr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    int tag = (int)textField.tag;
    if (newstr.length>4)
    {
        switch (tag) {
            case TAG_INPUT1:
                [(UIResponder*)[self viewWithTag:TAG_INPUT2] becomeFirstResponder];
                break;
            case TAG_INPUT2:
                [(UIResponder*)[self viewWithTag:TAG_INPUT3] becomeFirstResponder];
                break;
            case TAG_INPUT3:
                [(UIResponder*)[self viewWithTag:TAG_INPUT4] becomeFirstResponder];
                break;
            case TAG_INPUT4:
            default:
                break;
        }
        return NO;
    }
    if (newstr.length==4)
    {
        // ok, lets move to next first responder
        switch (tag) {
            case TAG_INPUT1:
                [(UIResponder*)[self viewWithTag:TAG_INPUT2] performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:.05];
                break;
            case TAG_INPUT2:
                [(UIResponder*)[self viewWithTag:TAG_INPUT3] performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:.05];
                break;
            case TAG_INPUT3:
                [(UIResponder*)[self viewWithTag:TAG_INPUT4] performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:.05];
                break;
            case TAG_INPUT4:
            default:
                break;
        }
    }
    if (newstr.length==0)
    {
        // ok, lets move to prev first responder
        switch (tag) {
            case TAG_INPUT1:
                break;
            case TAG_INPUT2:
                [(UIResponder*)[self viewWithTag:TAG_INPUT1] performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:.05];
                break;
            case TAG_INPUT3:
                [(UIResponder*)[self viewWithTag:TAG_INPUT2] performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:.05];
                break;
            case TAG_INPUT4:
                [(UIResponder*)[self viewWithTag:TAG_INPUT3] performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:.05];
            default:
                break;
        }
    }
    
    [self performSelector:@selector(evaluateUserCodeLength) withObject:nil afterDelay:.2];
    return YES;
}

- (void)evaluateUserCodeLength
{
    NSString* uc = [self getUserCode];
    UIButton* registerButton = (UIButton*)[self viewWithTag:TAG_BUTTON];
    registerButton.enabled = (uc.length==16);
    registerButton.titleLabel.font = registerButton.enabled ? [UIFont boldSystemFontOfSize:18] : [UIFont systemFontOfSize:18];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
