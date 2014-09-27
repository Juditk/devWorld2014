//
//  HRTPeerManager.h
//  HeartChat
//
//  Created by Judit Klein on 1/09/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKPeerConnectivity.h"
#import "HRTConstants.h"
#import "HRTMessageServer.h"


@interface HRTPeerManager : NSObject <JKPeerConnectivityDelegate>
{
    NSMutableDictionary *peerMap;
    NSMutableDictionary *peerImageMap;
}

@property (nonatomic, strong) NSString *encodedImage;
@property (nonatomic, strong) NSMutableDictionary *peerMap;
@property (nonatomic, strong) NSMutableDictionary *peerImageMap;


+ (HRTPeerManager *) sharedPeerManager;
- (void) updatePeerInfoForPeerID:(NSString*)realName forPeerName:(NSString*)peerName withImage:(UIImage*)peerImage;
- (void) sendChatMessage:(NSString *)chatMessage;
- (void) sendChatImage:(UIImage *)chatImage;
- (void) setupSession;
- (NSArray*)currrentConnectPeers;

@end
