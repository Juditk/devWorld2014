//
//  WATSecondViewController.h
//  WaterChat
//
//  Created by Judit Klein on 25/08/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WATPeerManager.h"
#import "WATMessageServer.h"

@interface WATSecondViewController : UIViewController <UITextFieldDelegate>
{
    UITextView *textBox;
    UITextField *chatBox;
}

@property (nonatomic, strong) IBOutlet UITextView *textBox;
@property (nonatomic, strong) IBOutlet UITextField *chatBox;

@end
