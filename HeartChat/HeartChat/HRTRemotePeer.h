//
//  HRTRemotePeer.h
//  HeartChat
//
//  Created by Judit Klein on 1/09/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRTRemotePeer : NSObject
{
    NSString *remotePeerID;
    NSString *remotePeerName;
    UIImage *remotePeerImage;
}

@property (nonatomic, strong) NSString *remotePeerID;
@property (nonatomic, strong) NSString *remotePeerName;
@property (nonatomic, strong) UIImage *remotePeerImage;

- (id)initWithID:(NSString*)newPeerID
        peerName:(NSString*)newPeerName
      peerAvatar:(UIImage*)newPeerAvatar;

@end
