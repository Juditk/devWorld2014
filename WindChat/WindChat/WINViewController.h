//
//  WINViewController.h
//  WindChat
//
//  Created by Judit Klein on 25/08/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface WINViewController : UIViewController <MCBrowserViewControllerDelegate, MCSessionDelegate, UITextFieldDelegate>

@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *mySession;
@property (nonatomic, strong) MCPeerID *myPeerID;

@property (nonatomic, strong) UIButton *browseButton;
@property (nonatomic, strong) UITextView *textBox;
@property (nonatomic, strong) UITextField *chatBox;

@end
