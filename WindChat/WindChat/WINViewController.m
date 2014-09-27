//
//  WINViewController.m
//  WindChat
//
//  Created by Judit Klein on 25/08/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import "WINViewController.h"

@interface WINViewController ()

@end

@implementation WINViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpMultipeer];
}

- (void) setUpMultipeer
{
    // set up peer ID
    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
    
    // set up session
    self.mySession = [[MCSession alloc] initWithPeer:self.myPeerID];
    self.mySession.delegate = self;
    
    // set up BrowserViewController
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"windChat" session:self.mySession];
    
    // set up advertiser
    self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"windChat" discoveryInfo:nil session:self.mySession];
    [self.advertiser start];
    
    self.browserVC.delegate = self;
}

- (IBAction)browseButton:(id)sender
{
    [self showBrowserVC];
}


- (void) showBrowserVC
{
    [self presentViewController:self.browserVC animated:YES completion:nil];
}

- (void) dismissBrowserVC
{
    [self.browserVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma marks MCBrowserViewControllerDelegate Methods

//notifies the delegate when the user taps the done button
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [self dismissBrowserVC];
}

//notifies delegate that the user taps the cancel button
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [self dismissBrowserVC];
}

#pragma marks MCSessionDelegate methods

//remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    if ( state == MCSessionStateConnected ) {
        NSLog(@"Now connected to peer %@",peerID);
        
    } else if ( state == MCSessionStateConnecting ) {
        NSLog(@"Connecting to peer %@",peerID);
        
    } else if ( state == MCSessionStateNotConnected ) {
        NSLog(@"Not connected to peer %@",peerID);
        
    }
}

//received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    //decode data back to NSString
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //append message to text box on main thread
    dispatch_async(dispatch_get_main_queue(),^{
        [self receiveMessage:message fromPeer:peerID];
    });
}

//recieved a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    
}

//Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    
}

//finished recieving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    
}


#pragma mark Sending Data

- (void) sendText
{
    //retrieve text from chat box and clear chat box
    NSString *message = self.chatBox.text;
    self.chatBox.text = @"";
    
    //convert text to NSData
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    // Send data to connected peers
    NSError *error;
    [self.mySession sendData:data toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataUnreliable error:&error];
    
    //append your own text to the box
    [self receiveMessage:message fromPeer:self.myPeerID];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self sendText];
    return YES;
}

- (void) receiveMessage: (NSString *) message fromPeer: (MCPeerID *) peer
{
    //create the final text to append
    
    NSString *finalText;
    if (peer == self.myPeerID) {
        finalText = [NSString stringWithFormat:@"\nme: %@\n", message];
    } else {
        finalText = [NSString stringWithFormat:@"\n%@: %@\n", peer.displayName, message];
    }
    
    //append text to text box
    self.textBox.text = [self.textBox.text stringByAppendingString:finalText];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
