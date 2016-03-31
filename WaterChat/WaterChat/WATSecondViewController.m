//
//  WATSecondViewController.m
//  WaterChat
//
//  Created by Judit Klein on 25/08/14.
//  Copyright (c) 2014 Judit Klein
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
