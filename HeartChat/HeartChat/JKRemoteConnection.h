//
//  JKRemoteConnection.h
//  GeoStormEmbedded
//
//  Created by Judit Klein on 18/04/14.
//  Copyright (c) 2014 Judit Klein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKConnection.h"
#import "Connection.h"


@interface JKRemoteConnection : JKConnection <ConnectionDelegate> {
  // Our connection to the chat server
  Connection* connection;
}

@property(nonatomic,retain) Connection* connection;

// Initialize with host address and port
- (id)initWithHost:(NSString*)host andPort:(int)port;

// Initialize with a reference to a net service discovered via Bonjour
- (id)initWithNetService:(NSNetService*)netService;

@end
