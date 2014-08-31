//
//  JKRemoteConnection.m
//  GeoStormEmbedded
//
//  Created by Judit Klein on 18/04/14.
//  Copyright (c) 2014 Judit Klein. All rights reserved.
//

#import "JKRemoteConnection.h"
#import "GSGlobalMessageServer.h"
#import "GSDevice.h"


// Private properties
@interface JKRemoteConnection ()
@end


@implementation JKRemoteConnection

@synthesize connection;

// Setup connection but don't connect yet
- (id)initWithHost:(NSString*)host andPort:(int)port {
  connection = [[Connection alloc] initWithHostAddress:host andPort:port];
  return self;
}


// Initialize and connect to a net service
- (id)initWithNetService:(NSNetService*)netService {
  connection = [[Connection alloc] initWithNetService:netService];
  return self;
}


// Cleanup
- (void)dealloc {
  self.connection = nil;
}


// Start everything up, connect to server
- (BOOL)start {
  if ( connection == nil ) {
    return NO;
  }
  
  // We are the delegate
  connection.delegate = self;
  
  return [connection connect];
}


// Stop everything, disconnect from server
- (void)stop {
  if ( connection == nil ) {
    return;
  }
  
  [connection close];
  self.connection = nil;
}

//This will broadcast a given NSDictionary to all clinets connected to this device
- (void)broadcastPacket:(NSDictionary*)packet fromId:(NSString*)fromID {
    
    // Send it out
    [connection sendNetworkPacket:packet];
}


#pragma mark -
#pragma mark ConnectionDelegate Method Implementations

- (void)connectionAttemptFailed:(Connection*)connection {
    NSLog(@"Failed To COnnecto To REmote Peer");
#warning Failed To Connect To Peer Logic goes here
}


- (void)connectionTerminated:(Connection*)connection {
    NSLog(@"Connection To Remote Peer has been terminated");

    [delegate remoteConnectionHasClosed:self];
    #warning Peer has left us goes here

}


- (void)receivedNetworkPacket:(NSDictionary*)packet viaConnection:(Connection*)connection {
	
    //NSLog(@"Incomming Data From Peer %@",packet);
    
    //Decode it
    [[GSGlobalMessageServer sharedManager]decodeMessage:[packet objectForKey:@"MessagePacket"]];
    
#warning THIS IS WHERE THE MESSAGE COMES IN TO THE CLIENT FROM OTHER CLIENTS, IT NEEDS TO BE SENT TO THE MESSAGE DECODE SERVER FROM HERE
    
    
}


@end
