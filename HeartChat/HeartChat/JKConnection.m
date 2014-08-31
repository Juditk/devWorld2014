//
//  JKConnection.m
//  GeoStormEmbedded
//
//  Created by Judit Klein on 18/04/14.
//  Copyright (c) 2014 Judit Klein. All rights reserved.
//

#import "JKConnectionDelegate.h"
#import "JKConnection.h"


@implementation JKConnection

@synthesize delegate;
@synthesize displayName;

// Cleanup
- (void)dealloc {
  self.delegate = nil;
}


// "Abstract" methods
- (BOOL)start {
  // Crude way to emulate "abstract" class
  [self doesNotRecognizeSelector:_cmd];
  return NO;
}

- (void)stop {
  // Crude way to emulate "abstract" class
  [self doesNotRecognizeSelector:_cmd];
}

//This will broadcast a given NSDictionary to all clinets connected to this device
- (void)broadcastPacket:(NSDictionary*)packet fromId:(NSString*)fromID {
    
    // Crude way to emulate "abstract" class
   [self doesNotRecognizeSelector:_cmd];
}
@end
