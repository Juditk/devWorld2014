//
//  WATRemotePeer.m
//  WaterChat
//
//  Created by Judit Klein on 26/08/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import "WATRemotePeer.h"

@implementation WATRemotePeer

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
