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
    [[WATPeerManager sharedPeerManager]sendChatMessage:message];
    
    //append your own text to the box
    NSString *myMessage = [NSString stringWithFormat:@"Me: %@\n",message];
    [[WATMessageServer sharedManager]setReceivedMessage:myMessage];
    [self updateChat];
    
}

- (void) updateChat
{
    NSString *newString = [[WATMessageServer sharedManager]receivedMessage];
    
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
