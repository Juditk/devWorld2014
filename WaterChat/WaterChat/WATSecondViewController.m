//
//  WATSecondViewController.m
//  WaterChat
//
//  Created by Judit Klein on 25/08/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import "WATSecondViewController.h"

@interface WATSecondViewController ()

@end

@implementation WATSecondViewController

@synthesize textBox, chatBox;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
    [[WATPeerManager sharedPeerManager]sendChatMessage:message];
    
    //append your own text to the box
    //[self receiveMessage:message fromPeer:self.myPeerID];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self sendText];
    return YES;
}

@end
