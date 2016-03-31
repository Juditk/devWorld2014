//
//  JKPeerConnectivity.h
//  GeoStormEmbedded
//
//  Created by Judit Klein on 4/19/14.
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

#import <Foundation/Foundation.h>
#import "JKLocalConnection.h"
#import "JKRemoteConnection.h"

#import "PeerBrowser.h"
#import "PeerDiscoveryDelegate.h"

#import "JKPeerConnectivityDelegate.h"
#import "JKPeer.h"

@interface JKPeerConnectivity : NSObject <PeerDiscoveryDelegate,JKConnectionDelegate>
{
    //I Myself will only have one "local" connection which I will use to braodcast to all clients
    JKLocalConnection *myConnection;
    
    //I will have multiple "Peer Connections" which I will recive incomming packets from
    NSMutableSet *peerConnections;
    
    //Peer ID to Connection Map, I have a connection to each peer, if I only want to send on that connection I can
    NSMutableDictionary *peerIDToConnectionMap;

    //JKPeer to NetService Map
    NSMutableDictionary *peerToNetServiceMap;
    
    //This will search for other Peers
    PeerBrowser *peerBrowser;
    
    id<JKPeerConnectivityDelegate> delegate;
    
    //This is the current group stable identifier that we will only connect to
    //clients which have this, aka the Major of the beacon
    NSString *groupID;
}

@property(nonatomic,retain) id<JKPeerConnectivityDelegate> delegate;
@property(nonatomic,retain) NSMutableSet* peerConnections;
@property(nonatomic,retain) NSMutableDictionary *peerIDToConnectionMap;
@property(nonatomic,retain) NSMutableDictionary *peerToNetServiceMap;


+ (JKPeerConnectivity *) sharedManager;

- (void) startConnectingToPeersWithGroupID:(NSString*)partyName;
- (void) stopConnectionsAndResetState;
- (void) stopEverything;


- (void) sendDataToOnePeer:(JKPeer *)peerToSendTo data:(NSData *)dataToSend;
- (void) sendDataToAllPeers:(NSData *)dataToSend;

- (void)removePeerWithID:(NSString*)peerID;

@end
