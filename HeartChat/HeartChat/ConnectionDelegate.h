//
//  ConnectionDelegate.h
//  GeoStormEmbedded
//
//  Created by Judit Klein on 15/04/14.
//  Copyright (c) 2014 Judit Klein. All rights reserved.

#import <Foundation/Foundation.h>

@class Connection;

@protocol ConnectionDelegate

- (void) connectionAttemptFailed:(Connection*)connection;
- (void) connectionTerminated:(Connection*)connection;
- (void) receivedNetworkPacket:(NSDictionary*)message viaConnection:(Connection*)connection;

@end
