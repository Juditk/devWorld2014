//
//  HRTMessageServer.m
//  HeartChat
//
//  Created by Judit Klein on 1/09/14.
//  Copyright (c) 2014 Judit Klein
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "HRTMessageServer.h"

@implementation HRTMessageServer

@synthesize receivedMessage, receivedImages;

+ (HRTMessageServer *) sharedManager
{
    static HRTMessageServer *sharedMessageServer = nil;
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

- (void) decodeMessage:(NSData *)incomingData
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
            
            [[HRTPeerManager sharedPeerManager]updatePeerInfoForPeerID:realName forPeerName:peerName withImage:displayAvatar];
            
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
