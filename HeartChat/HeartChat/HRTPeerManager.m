//
//  HRTPeerManager.m
//  HeartChat
//
//  Created by Judit Klein on 1/09/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import "HRTPeerManager.h"

@implementation HRTPeerManager

@synthesize myDiscoveryInfo, nearbyPeers;

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
        
    }
    return self;
}

- (void)setupLocalPeer
{
    nearbyPeers = [[NSMutableArray alloc]init];
    
}

- (void)setupSession
{
    
    NSLog(@"Setting up a session");
    
    // Create the session that peers will be invited/join into.
    [[JKPeerConnectivity sharedManager]setDelegate:self];
    [[JKPeerConnectivity sharedManager]startConnectingToPeersWithGroupID:@"1"];

}


- (void)startServices
{
    [self setupLocalPeer];
    [self setupSession];
}


- (void) addNewPeerToArray: (HRTRemotePeer *)peer
{
    
    [nearbyPeers addObject:peer];
    NSLog(@"new peer was added to the array with the ID %@",peer.remotePeerID);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateArray" object:self];
    
}

#warning this causes a crash when a peer leaves 

- (void) removePeerFromArray: (NSString *)peerID
{
    NSMutableArray *peersToRemove = [NSMutableArray alloc];
    
    for (HRTRemotePeer *peerToRemove in nearbyPeers) {
        if ( [peerToRemove.remotePeerID isEqualToString:peerID] ) {
            NSLog(@"Found the peer to remove");
            [peersToRemove addObject:peerToRemove];
        }
    }
    
    [nearbyPeers removeObjectsInArray:peersToRemove];
}


#pragma mark hello protocol

- (void) sayHelloToJKPeer:(JKPeer*)peerToSayHelloTo
{
    NSLog(@"I Just Came To Say Hello!!!");
    //The Hello Dictionary Has a picture and a name that goes alongside a PeerID

    NSString *peerName = [[JKPeerConnectivitySetup sharedSetup]myUniqueID];
    NSString *realName = [[JKPeerConnectivitySetup sharedSetup]deviceNameIdentifier];
    UIImage *displayAvatar = [self randomImage];
    
    NSDictionary *myDict = [[NSDictionary alloc]initWithObjectsAndKeys:@kIncomingMessageTypeHello,@"messageType",
                            peerName,@"peerName",
                            realName,@"realName",
                            displayAvatar,@"displayAvatar"
                            ,nil];
    
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

- (void)updatePeerInfoForPeerID:(NSString*)realName forPeerName:(NSString*)peerName withImage:(UIImage*)peerImage
{
    
    NSLog(@"Recived An Update For PeerName %@ who is now RealName %@",peerName,realName);
    
    for (HRTRemotePeer *peer in [[HRTPeerManager sharedPeerManager]nearbyPeers]) {
        if ([peer.remotePeerID isEqualToString:peerName]) {
            [peer setRemotePeerName:realName];
            [peer setRemotePeerImage:peerImage];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateArray" object:self];

        }
    }
}

#pragma mark JKPeerConnectiy Helper Methods

- (NSArray*)currrentConnectPeers {
    
    return [[[JKPeerConnectivity sharedManager]peerConnections] allObjects];
}

#pragma mark JKPeerConnectivty Delegate Methods (New Networking 2.0 Framework)

- (void)peerHasJoined:(JKPeer*)newPeer {
    NSLog(@"We Are Now Connected To Peer %@",newPeer);
    
    NSString *peerUniqueID = newPeer.peerName;
    HRTRemotePeer *freshPeer = [[HRTRemotePeer alloc]initWithID:peerUniqueID peerName:nil peerAvatar:nil];
    [self addNewPeerToArray:freshPeer];
    
    [self sayHelloToJKPeer:newPeer];
}

-(void)peerHasLeft:(JKPeer *)leavingPeer {
    NSLog(@"We Are No Longer Connected To Peer %@",leavingPeer);
    [self removePeerFromArray:leavingPeer.peerName];
    
}


@end
