//
//  HRTPeerManager.h
//  HeartChat
//
//  Created by Judit Klein on 1/09/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKPeerConnectivity.h"
#import "HRTRemotePeer.h"
#import "HRTConstants.h"
#import "HRTMessageServer.h"


@interface HRTPeerManager : NSObject <JKPeerConnectivityDelegate>
{
    NSMutableArray *nearbyPeers;
    NSDictionary *myDiscoveryInfo;
}

@property (nonatomic, strong) NSMutableArray *nearbyPeers;
@property (nonatomic, strong) NSDictionary *myDiscoveryInfo;
@property (nonatomic, strong) NSString *encodedImage;


+ (HRTPeerManager *) sharedPeerManager;
- (void) updatePeerInfoForPeerID:(NSString*)realName forPeerName:(NSString*)peerName withImage:(UIImage*)peerImage;
- (void) sendChatMessage:(NSString *)chatMessage;
- (void) sendChatImage:(UIImage *)chatImage;
- (void) setupSession;
- (void) startServices;

@end
