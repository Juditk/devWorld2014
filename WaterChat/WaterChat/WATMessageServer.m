//
//  WATMessageServer.m
//  WaterChat
//
//  Created by Judit Klein on 26/08/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import "WATMessageServer.h"

@implementation WATMessageServer

@synthesize receivedMessage, receivedImages;

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
            NSData *imageData = [incomingDict objectForKey:@"displayAvatar"];
            UIImage *displayAvatar = [UIImage imageWithData:imageData];
            
            [[WATPeerManager sharedPeerManager]updatePeerInfoForPeerID:realName forPeerName:peerName withImage:displayAvatar];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateArray" object:self];

        }
            break;
            
        case kIncomingMessageTypeChatText:
        {
            NSLog(@"Somebody Is Sending a message");
            NSString *realName = [incomingDict objectForKey:@"realName"];
            NSString *chatMessage = [incomingDict objectForKey:@"chatMessage"];
        
            NSString *theMessage = [NSString stringWithFormat:@"%@ says: %@\n",realName,chatMessage];
            
            receivedMessage = theMessage;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateChat" object:self];
            
        }
            break;
            
        case kIncomingMessageTypeChatImage:
        {
            NSLog(@"Somebody Is Sending an image");
            NSString *realName = [incomingDict objectForKey:@"realName"];
            UIImage *chatImage = [incomingDict objectForKey:@"chatImage"];
            
            [self updateImagesArray:chatImage];
            NSLog(@"%@ has sent an image",realName);

        }
            break;
            
            
        default:
            break;
    }
}

- (void) updateImagesArray:(UIImage *)image
{
    if (receivedImages == nil) {
        receivedImages = [[NSMutableArray alloc]init];
    }
    
    [receivedImages addObject:image];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateImages" object:self];

}

@end
