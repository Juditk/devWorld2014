//
//  WATRemotePeer.m
//  WaterChat
//
//  Created by Judit Klein on 26/08/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import "WATRemotePeer.h"

@implementation WATRemotePeer

@synthesize remotePeerID;

- (id)initWithID:(NSString*)newPeerID
{
    self = [super init];
    if (self) {
        remotePeerID = newPeerID;
        
    }
    return self;
}

@end
