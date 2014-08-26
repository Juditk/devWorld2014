//
//  WATMessageServer.m
//  WaterChat
//
//  Created by Judit Klein on 26/08/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import "WATMessageServer.h"

@implementation WATMessageServer

+ (WATMessageServer *) sharedManager
{
    static WATMessageServer *sharedMessageServer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMessageServer = [[self alloc] init];
    });
    return sharedMessageServer;
}


- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) decodeMessage: (NSData *)incomingData
{
    
    NSLog(@"Decoding Message Now");

    NSDictionary *incomingDict = (NSDictionary* )[NSKeyedUnarchiver unarchiveObjectWithData:incomingData];
    
    NSInteger messageType = [[incomingDict valueForKey:@"messageType"]integerValue];
    
    switch (messageType) {
            
        case kIncomingMessageTypeHello:
        {
            NSLog(@"Somebody Is Saying Hello");
            NSString *peerName = [incomingDict objectForKey:@"peerName"];
            NSString *realName = [incomingDict objectForKey:@"realName"];
            UIImage *displayAvatar = [incomingDict objectForKey:@"displayAvatar"];
            
            [[WATPeerManager sharedPeerManager]updatePeerInfoForPeerID:realName forPeerName:peerName withImage:displayAvatar];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateArray" object:self];

        }
            break;
            
            
        default:
            break;
    }
    
}


@end
