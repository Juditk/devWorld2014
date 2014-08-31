//
//  JKConnection.h
//  GeoStormEmbedded
//
//  Created by Judit Klein on 18/04/14.
//  Copyright (c) 2014 Judit Klein. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JKConnectionDelegate.h"

@interface JKConnection : NSObject {
  id<JKConnectionDelegate> delegate;
    NSString *displayName;
}
@property(nonatomic,retain) NSString *displayName;
@property(nonatomic,retain) id<JKConnectionDelegate> delegate;

- (BOOL)start;
- (void)stop;
- (void)broadcastPacket:(NSDictionary*)packet fromId:(NSString*)fromID;

@end
