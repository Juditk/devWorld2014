//
//  HRTSecondViewController.m
//  HeartChat
//
//  Created by Judit Klein on 1/09/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import "HRTSecondViewController.h"

@interface HRTSecondViewController ()

@end

@implementation HRTSecondViewController

@synthesize textBox, chatBox;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateChat)
                                                 name:@"updateChat"
                                               object:nil];
    
    textBox.text = @"Welcome!\n";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) sendText {
    //retrieve text from chat box and clear chat box
    NSString *message = self.chatBox.text;
    self.chatBox.text = @"";
    
    // Send data to connected peers
    [[HRTPeerManager sharedPeerManager]sendChatMessage:message];
    
}

- (void) updateChat
{
    NSString *newString = [[HRTMessageServer sharedManager]receivedMessage];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        textBox.text = [textBox.text stringByAppendingString:newString];
    });
    
    NSLog(@"%@",newString);
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self sendText];
    return YES;
}

@end
