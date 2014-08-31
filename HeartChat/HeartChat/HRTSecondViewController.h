//
//  HRTSecondViewController.h
//  HeartChat
//
//  Created by Judit Klein on 1/09/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRTPeerManager.h"
#import "HRTMessageServer.h"

@interface HRTSecondViewController : UIViewController <UITextFieldDelegate>
{
    UITextView *textBox;
    UITextField *chatBox;
}

@property (nonatomic, strong) IBOutlet UITextView *textBox;
@property (nonatomic, strong) IBOutlet UITextField *chatBox;

@end
