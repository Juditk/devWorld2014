//
//  ServerDelegate.h
//  GeoStormEmbedded
//
//  Created by Judit Klein on 15/04/14.
//  Copyright (c) 2014 Judit Klein. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Server, Connection;

@protocol ServerDelegate

// Server has been terminated because of an error
- (void) serverFailed:(Server*)server reason:(NSString*)reason;

// Server has accepted a new connection and it needs to be processed
- (void) handleNewConnection:(Connection*)connection;

@end
