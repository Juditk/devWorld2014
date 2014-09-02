//
//  JKLocalConnection.m
//  GeoStormEmbedded
//
//  Created by Judit Klein on 18/04/14.
//  Copyright (c) 2014 Judit Klein. All rights reserved.
//

#import "JKLocalConnection.h"
#import "Connection.h"

// Private properties
@interface JKLocalConnection ()
@property(nonatomic,retain) Server* server;
@property(nonatomic,retain) NSMutableSet* clients;
@end


@implementation JKLocalConnection

@synthesize server, clients;

// Initialization
- (id)init {
  clients = [[NSMutableSet alloc] init];
  
  return self;
}


// Cleanup
- (void)dealloc {
  self.clients = nil;
  self.server = nil;
}


// Start the server and announce self
- (BOOL)start {
  // Create new instance of the server and start it up
  server = [[Server alloc] init];
  
  // We will be processing server events
  server.delegate = self;
  
  // Try to start it up
  if ( ! [server start] ) {
    self.server = nil;
    return NO;
  }
  
  return YES;
}


// Stop everything
- (void)stop {
  // Destroy server
  [server stop];
  self.server = nil;
  
  // Close all connections
  [clients makeObjectsPerformSelector:@selector(close)];
}

//This will broadcast a given NSDictionary to all clinets connected to this device
- (void)broadcastPacket:(NSDictionary*)packet fromId:(NSString*)fromID {
    
    // Send it out
    [clients makeObjectsPerformSelector:@selector(sendNetworkPacket:) withObject:packet];
}

//This will broadcast a given NSDictionary to all clinets connected to this device
- (void)broadcastPacketInJSON:(NSData*)packet fromId:(NSString*)fromID {
    
    // Send it out
    [clients makeObjectsPerformSelector:@selector(sendNetworkPacketToAndroidDevice:) withObject:packet];
}


#pragma mark -
#pragma mark ServerDelegate Method Implementations

// Server has failed. Stop the world.
- (void) serverFailed:(Server*)server reason:(NSString*)reason {
  // Stop everything and let our delegate know
  [self stop];
  [delegate roomTerminated:self reason:reason];
}


// New client connected to our server. Add it.
- (void) handleNewConnection:(Connection*)connection {
  // Delegate everything to us
  connection.delegate = self;
  
  // Add to our list of clients
  [clients addObject:connection];
}


#pragma mark -
#pragma mark ConnectionDelegate Method Implementations

// We won't be initiating connections, so this is not important
- (void) connectionAttemptFailed:(Connection*)connection {
}


// One of the clients disconnected, remove it from our list
- (void) connectionTerminated:(Connection*)connection {
  [clients removeObject:connection];
}


// One of connected clients sent a chat message. Propagate it further.
- (void) receivedNetworkPacket:(NSDictionary*)packet viaConnection:(Connection*)connection {
        
#warning THIS IS WHERE THE MESSAGE COMES IN TO THE CLIENT FROM OTHER CLIENTS, IT NEEDS TO BE SENT TO THE MESSAGE DECODE SERVER FROM HERE

}


@end
