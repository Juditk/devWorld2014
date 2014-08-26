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
