//
//  HRTRemotePeer.m
//  HeartChat
//
//  Created by Judit Klein on 1/09/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import "HRTRemotePeer.h"

@implementation HRTRemotePeer

@synthesize remotePeerID, remotePeerImage, remotePeerName;

- (id)initWithID:(NSString*)newPeerID
        peerName:(NSString*)newPeerName
      peerAvatar:(UIImage*)newPeerAvatar
{
    self = [super init];
    if (self) {
        remotePeerID = newPeerID;
        remotePeerName = newPeerName;
        remotePeerImage = newPeerAvatar;
    }
    return self;
}
@end
