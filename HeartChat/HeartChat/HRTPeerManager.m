//
//  HRTPeerManager.m
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

#import "HRTPeerManager.h"

@implementation HRTPeerManager

@synthesize peerImageMap, peerMap;

+ (HRTPeerManager *) sharedPeerManager
{
    static HRTPeerManager *peerManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        peerManager = [[self alloc] init];
    });
    return peerManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        peerImageMap = [[NSMutableDictionary alloc]init];
        peerMap = [[NSMutableDictionary alloc]init];
    }
    return self;
}


- (void)setupSession
{
    
    NSLog(@"Setting up a session");
    
    // Create the session that peers will be invited/join into.
    [[JKPeerConnectivity sharedManager]setDelegate:self];
    [[JKPeerConnectivity sharedManager]startConnectingToPeersWithGroupID:@"1"];

}

#pragma mark JKPeerConnectivty Delegate Methods (New Networking 2.0 Framework)

- (void)peerHasJoined:(JKPeer*)newPeer {
    NSLog(@"We Are Now Connected To Peer %@",newPeer);
    
    if ( [newPeer.peerOSType isEqualToString:@"Android"] ) {
        NSLog(@"ANDROID!!!");
        NSString *peerName = newPeer.peerName;
        NSString *realName = newPeer.peerName;
        UIImage *displayAvatar = [UIImage imageNamed:@"Android"];
        
        [self updatePeerInfoForPeerID:realName forPeerName:peerName withImage:displayAvatar];
        
    } else {
        
        [self sayHelloToJKPeer:newPeer];
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateArray" object:self];
    
}

-(void)peerHasLeft:(JKPeer *)leavingPeer {
    NSLog(@"We Are No Longer Connected To Peer %@",leavingPeer);
    //[self removePeerFromPeerMap:leavingPeer.peerName];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateArray" object:self];
    
}

#pragma mark JKPeerConnectiy Helper Methods

- (NSArray*)currrentConnectPeers {
    
    return [[[JKPeerConnectivity sharedManager]peerConnections] allObjects];
}


#pragma mark peer map

- (void)removePeerFromPeerMap:(NSString*)peerName
{
    if ( [peerMap objectForKey:peerName] )
    {
        [peerMap removeObjectForKey:peerName];
    }
    
    if ( [peerImageMap objectForKey:peerName] )
    {
        [peerImageMap removeObjectForKey:peerName];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateArray" object:self];

}

- (void)updatePeerInfoForPeerID:(NSString*)realName forPeerName:(NSString*)peerName withImage:(UIImage*)peerImage
{
    NSLog(@"Recived An Update For PeerName %@ who is now RealName %@",peerName,realName);
    if ( realName ) {
        [peerMap setValue:realName forKey:peerName];
    }
    
    if ( peerImage ) {
        [peerImageMap setValue:peerImage forKey:peerName];
    }
    
    NSLog(@"Peer ID to Real Name reads %@",peerMap);
    NSLog(@"Peer ID to Image Map reads %@",peerImageMap);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateArray" object:self];

}

#pragma mark protocols

- (void) sayHelloToJKPeer:(JKPeer*)peerToSayHelloTo
{
    NSLog(@"I Just Came To Say Hello!!!");
    //The Hello Dictionary Has a picture and a name that goes alongside a PeerID

    NSString *peerName = [[JKPeerConnectivitySetup sharedSetup]myUniqueID];
    NSString *realName = [[JKPeerConnectivitySetup sharedSetup]deviceNameIdentifier];
    UIImage *displayAvatar = [self randomImage];
    NSData *imagedata = UIImagePNGRepresentation(displayAvatar);
    
    NSDictionary *myDict = [[NSDictionary alloc]initWithObjectsAndKeys:@kIncomingMessageTypeHello,@"messageType",
                            peerName,@"peerName",
                            realName,@"realName",
                            imagedata,@"displayAvatar"
                            ,nil];
    
    NSLog(@"Sending a hello message");
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:myDict];

    [[JKPeerConnectivity sharedManager]sendDataToOnePeer:peerToSayHelloTo data:myData];
}

- (void) sendChatMessage:(NSString *)chatMessage
{
    NSLog(@"Sending message: %@",chatMessage);
    NSString *realName = [[NSUserDefaults standardUserDefaults] stringForKey:@"Name"];
    
    NSDictionary *myDict = [[NSDictionary alloc]initWithObjectsAndKeys:@kIncomingMessageTypeChatText,@"messageType",
                            realName,@"realName",
                            chatMessage,@"chatMessage"
                            ,nil];
    
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:myDict];
    
    [[JKPeerConnectivity sharedManager]sendDataToAllPeers:myData];
}

- (void) sendChatImage:(UIImage *)chatImage
{
    NSLog(@"Sending image");
    NSString *realName = [[NSUserDefaults standardUserDefaults] stringForKey:@"Name"];
    
    NSDictionary *myDict = [[NSDictionary alloc]initWithObjectsAndKeys:@kIncomingMessageTypeChatImage,@"messageType",
                            realName,@"realName",
                            chatImage,@"chatImage"
                            ,nil];
    
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:myDict];
    
    [[JKPeerConnectivity sharedManager]sendDataToAllPeers:myData];
}

- (UIImage *)randomImage
{
    NSUInteger randomIndex = arc4random()%10;
    NSString *imageString = [NSString stringWithFormat:@"avatar%lu",(unsigned long)randomIndex];
    UIImage *selectedImage = [UIImage imageNamed:imageString];
    return selectedImage;
}


@end
