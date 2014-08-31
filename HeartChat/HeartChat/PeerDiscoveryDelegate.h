//
//  PeerDiscoveryDelegate.h
//  GeoStormEmbedded
//
//  Created by Judit Klein on 15/04/14.
//  Copyright (c) 2014 Judit Klein. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PeerDiscoveryDelegate

- (void)updatePeerList;
- (void)newPeerDiscovered:(NSNetService*)newPeer;
- (void)peerIsGone:(NSNetService*)leavingPeer;

@end
