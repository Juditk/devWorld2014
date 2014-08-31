//
//  JKLocalConnection.h
//  GeoStormEmbedded
//
//  Created by Judit Klein on 18/04/14.
//  Copyright (c) 2014 Judit Klein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKConnection.h"
#import "Server.h"
#import "ServerDelegate.h"
#import "ConnectionDelegate.h"


@interface JKLocalConnection : JKConnection <ServerDelegate, ConnectionDelegate> {
  // We accept connections from other clients using an instance of the Server class
  Server* server;
  
  // Container for all connected clients
  NSMutableSet* clients;
}

// Initialize everything
- (id)init;

- (void)broadcastPacketInJSON:(NSData*)packet fromId:(NSString*)fromID;

@end
