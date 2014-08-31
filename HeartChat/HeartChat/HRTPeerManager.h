//
//  HRTPeerManager.h
//  HeartChat
//
//  Created by Judit Klein on 1/09/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "HRTRemotePeer.h"
#import "HRTConstants.h"
#import "HRTMessageServer.h"


@interface HRTPeerManager : NSObject <MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate>
{
    MCNearbyServiceAdvertiser *serviceAdvertiser;
    MCNearbyServiceBrowser *serviceBrowser;
    MCPeerID *myPeerID;
    MCSession *session;
    NSMutableArray *nearbyPeers;
    NSDictionary *myDiscoveryInfo;
}

@property (nonatomic, strong) MCNearbyServiceAdvertiser *serviceAdvertiser;
@property (nonatomic, strong) MCNearbyServiceBrowser *serviceBrowser;
@property (nonatomic, strong) MCPeerID *myPeerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) NSMutableArray *nearbyPeers;
@property (nonatomic, strong) NSDictionary *myDiscoveryInfo;
@property (nonatomic, strong) NSString *encodedImage;


+ (HRTPeerManager *) sharedPeerManager;
- (void)updatePeerInfoForPeerID:(NSString*)realName forPeerName:(NSString*)peerName withImage:(UIImage*)peerImage;
- (void) sendChatMessage:(NSString *)chatMessage;
- (void) sendChatImage:(UIImage *)chatImage;
- (void)setupSession;
- (void)startServices;

@end
