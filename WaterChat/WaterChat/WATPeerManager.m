//
//  WATPeerManager.m
//  WaterChat
//
//  Created by Judit Klein on 26/08/14.
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

#import "WATPeerManager.h"

@implementation WATPeerManager 

@synthesize serviceAdvertiser, serviceBrowser, myPeerID, nearbyPeers, session;

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

- (void)setupLocalPeer
{
    //set up my peerID
    NSString *uniqueID = [[NSUserDefaults standardUserDefaults] valueForKeyPath:@"personalID"];
    myPeerID = [[MCPeerID alloc] initWithDisplayName:uniqueID];
    
    //initialise our array for nearby peers
    nearbyPeers = [[NSMutableArray alloc]init];

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
                                                          discoveryInfo:nil
                                                            serviceType:service];
    serviceAdvertiser.delegate = self;
    
    // Create the service browser
    serviceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:myPeerID
                                                      serviceType:service];
    serviceBrowser.delegate = self;
}


#pragma mark - MCNearbyServiceBrowser Delegate methods

// Found a nearby advertising peer
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    
    NSLog(@"Browser found a peer");

    //get some information about the newly discovered peer and add them to the array
    NSString *peerUniqueID = peerID.displayName;
    
    WATRemotePeer *newPeer = [[WATRemotePeer alloc]initWithID:peerUniqueID peerName:nil peerAvatar:nil];
    
    [self addNewPeerToArray:newPeer];
    
    //we need to figure out who invites the other person but simply comparing our peer IDs
    BOOL shouldInvite = ([self.myPeerID.displayName compare:peerID.displayName]==NSOrderedDescending);
    
    if (shouldInvite)
    {
        //but first let's make sure there's room in the session
        
        if ( [[session connectedPeers] count] < 8 ) {
            
            [browser invitePeer:peerID
                      toSession:self.session
                    withContext:nil
                        timeout:10];
            NSLog(@"Inviting peer to session");
            
        } else {
            NSLog(@"This session is full, sorry!");
        }
        
    } else {
        NSLog(@"Waiting for invitation from peer");
    }
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


#pragma mark - MCNearbyServiceAdvertiser Delegate methods

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    
    invitationHandler(YES, self.session);
    NSLog(@"didReceiveInvitationFromPeer %@", peerID.displayName);
    
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    NSLog(@"didNotStartAdvertisingForPeers: %@", error);
}

//Lost a peer
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    
    //get some information about the peer so can remove them from the array
    
    NSString *lostPeerID = peerID.displayName;
    [self removePeerFromArray:lostPeerID];
    
    NSLog(@"lostPeer %@", lostPeerID);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateArray" object:self];
    
}

#pragma mark - MCSessionDelegate protocol conformance

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    
    switch (state) {
        case MCSessionStateNotConnected:
            NSLog(@"Not Connected to peer %@",peerID);
            break;
            
        case MCSessionStateConnecting:
            NSLog(@"Connecting to peer %@",peerID);
            break;
            
        case MCSessionStateConnected:
            NSLog(@"Connected to peer %@",peerID);
            [self sayHelloToPeer:@[peerID]];
            
            break;
            
        default:
            break;
    }
    
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    // Decode the incoming data to a UTF8 encoded string
    NSString *receivedMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"didReceiveData %@ from %@", receivedMessage, peerID.displayName);
    
    [[WATMessageServer sharedManager]decodeMessage:data];
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

#pragma mark protocols

- (void) sayHelloToPeer:(NSArray*)peersToSayHelloTo
{
    NSLog(@"I Just Came To Say Hello!!!");
    //The Hello Dictionary Has a picture and a name that goes alongside a PeerID
    
    NSString *peerID = self.myPeerID.displayName;
    NSString *realName = [[NSUserDefaults standardUserDefaults] stringForKey:@"Name"];
    UIImage *displayAvatar = [self randomImage];
    NSData *imagedata = UIImagePNGRepresentation(displayAvatar);
    
    NSDictionary *myDict = [[NSDictionary alloc]initWithObjectsAndKeys:@kIncomingMessageTypeHello,@"messageType",
                            peerID,@"peerName",
                            realName,@"realName",
                            imagedata,@"displayAvatar"
                            ,nil];
    
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:myDict];
    
    [session sendData:myData toPeers:peersToSayHelloTo withMode:MCSessionSendDataReliable error:nil];
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
    
    [session sendData:myData toPeers:[session connectedPeers] withMode:MCSessionSendDataReliable error:nil];

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
    
    [session sendData:myData toPeers:[session connectedPeers] withMode:MCSessionSendDataReliable error:nil];
    
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
    
    for (WATRemotePeer *peer in [[WATPeerManager sharedPeerManager]nearbyPeers]) {
        if (peer.remotePeerID) {
            [peer setRemotePeerName:realName];
            [peer setRemotePeerImage:peerImage];
        }
    }
    
}


@end
