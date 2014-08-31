//
//  ServerBrowser.h
//  GeoStormEmbedded
//
//  Created by Judit Klein on 16/04/14.
//  Copyright (c) 2014 Judit Klein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PeerDiscoveryDelegate.h"

@interface PeerBrowser : NSObject <NSNetServiceBrowserDelegate,NSNetServiceDelegate> {
  NSNetServiceBrowser* netServiceBrowser;
  NSMutableArray* servers;
  id<PeerDiscoveryDelegate> delegate;
}

@property(nonatomic,readonly) NSArray* servers;
@property(nonatomic,retain) id<PeerDiscoveryDelegate> delegate;

// Start browsing for Peers
- (BOOL)start;

// Stop browsing for Peers
- (void)stop;

@end
