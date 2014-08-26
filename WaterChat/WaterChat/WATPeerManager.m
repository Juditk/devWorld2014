//
//  WATPeerManager.m
//  WaterChat
//
//  Created by Judit Klein on 26/08/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import "WATPeerManager.h"

@implementation WATPeerManager 

@synthesize serviceAdvertiser, serviceBrowser, myPeerID, myDiscoveryInfo, nearbyPeers, session;

+ (WATPeerManager *) sharedPeerManager
{
    static WATPeerManager *peerManager = nil;
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
    //set up my discovery info to send to other peers
    
    NSString *uniqueID = [[NSUserDefaults standardUserDefaults] valueForKeyPath:@"personalID"];
    
    myPeerID = [[MCPeerID alloc] initWithDisplayName:uniqueID];
    
    nearbyPeers = [[NSMutableArray alloc]init];
    
    myDiscoveryInfo = [[NSDictionary alloc]initWithObjectsAndKeys:
                       uniqueID,@"uniqueID", nil];
}

- (void)setupSession
{
    
    NSLog(@"Setting up a session");
    
    // Create the session that peers will be invited/join into.
    session = [[MCSession alloc] initWithPeer:self.myPeerID];
    session.delegate = self;
    
    
    // Create the service advertiser that is visible to everyone
    NSString *service = @"WaterChat";
    serviceAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:myPeerID
                                                          discoveryInfo:myDiscoveryInfo
                                                            serviceType:service];
    serviceAdvertiser.delegate = self;
    
    // Create the service browser
    serviceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:myPeerID
                                                      serviceType:service];
    serviceBrowser.delegate = self;
}


- (void)startServices
{
    if ( !session ) {
        [self setupLocalPeer];
        [self setupSession];
        [self.serviceAdvertiser startAdvertisingPeer];
        [self.serviceBrowser startBrowsingForPeers];
    }
}

- (void)stopServices
{
    [self.serviceBrowser stopBrowsingForPeers];
    [self.serviceAdvertiser stopAdvertisingPeer];
}


// Found a nearby advertising peer
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    
    NSLog(@"Browser found a peer");

    NSString *peerUniqueID = [info objectForKey:@"uniqueID"];
    
    WATRemotePeer *newPeer = [[WATRemotePeer alloc]initWithID:peerUniqueID];
    [self addNewPeerToArray:newPeer];
    
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    
    NSString *lostPeerID = peerID.displayName;
    [self removePeerFromArray:lostPeerID];
    
    NSLog(@"lostPeer %@", lostPeerID);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateArray" object:self];
    
}

- (void) addNewPeerToArray: (WATRemotePeer *)peer
{
    
    [nearbyPeers addObject:peer];
    NSLog(@"new peer was added to the array with the ID %@",peer.remotePeerID);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateArray" object:self];
    
}

- (void) removePeerFromArray: (NSString *)peerID
{
    
    for (WATRemotePeer *peerToRemove in nearbyPeers) {
        if ( [peerToRemove.remotePeerID isEqualToString:peerID] ) {
            NSLog(@"Found the peer to remove");
            [nearbyPeers removeObject:peerToRemove];
        }
    }
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    NSLog(@"didNotStartBrowsingForPeers: %@", error);
}


#pragma mark - MCNearbyServiceAdvertiserDelegate protocol conformance

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    
    invitationHandler(YES, self.session);
    NSLog(@"didReceiveInvitationFromPeer %@", peerID.displayName);
    
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    NSLog(@"didNotStartAdvertisingForPeers: %@", error);
}

#pragma mark - MCSessionDelegate protocol conformance

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    
    NSLog(@"Peer [%@] changed state to %d", peerID.displayName, state);
    
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    // Decode the incoming data to a UTF8 encoded string
    NSString *receivedMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"didReceiveData %@ from %@", receivedMessage, peerID.displayName);
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    NSLog(@"didStartReceivingResourceWithName [%@] from %@ with progress [%@]", resourceName, peerID.displayName, progress);
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    NSLog(@"didFinishReceivingResourceWithName [%@] from %@", resourceName, peerID.displayName);
    
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    NSLog(@"didReceiveStream %@ from %@", streamName, peerID.displayName);
}



@end
