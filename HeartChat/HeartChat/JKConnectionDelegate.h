//
//  JKConnectionDelegate.h
//  GeoStormEmbedded
//
//  Created by Judit Klein on 18/04/14.
//  Copyright (c) 2014 Judit Klein. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JKConnection;

@protocol JKConnectionDelegate

- (void) displayChatMessage:(NSString*)message fromUser:(NSString*)userName;
- (void) roomTerminated:(id)room reason:(NSString*)string;
- (void) remoteConnectionHasClosed:(JKConnection*)oldConnection;
@end
