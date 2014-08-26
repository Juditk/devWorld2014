//
//  WATRemotePeer.h
//  WaterChat
//
//  Created by Judit Klein on 26/08/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WATRemotePeer : NSObject
{
    NSString *remotePeerID;
}

@property (nonatomic, strong) NSString *remotePeerID;

- (id)initWithID:(NSString*)newPeerID;

@end
