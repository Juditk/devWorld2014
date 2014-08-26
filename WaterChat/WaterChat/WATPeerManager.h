//
//  WATPeerManager.h
//  WaterChat
//
//  Created by Judit Klein on 26/08/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "WATRemotePeer.h"
#import "WATConstants.h"
#import "WATMessageServer.h"


@interface WATPeerManager : NSObject <MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate>
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


+ (WATPeerManager *) sharedPeerManager;
- (void)updatePeerInfoForPeerID:(NSString*)realName forPeerName:(NSString*)peerName withImage:(UIImage*)peerImage;
- (void) sendChatMessage:(NSString *)chatMessage;
- (void)setupSession;
- (void)startServices;

@end
