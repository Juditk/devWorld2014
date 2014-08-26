//
//  WATMessageServer.h
//  WaterChat
//
//  Created by Judit Klein on 26/08/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WATConstants.h"
#import "WATPeerManager.h"

@interface WATMessageServer : NSObject


+ (WATMessageServer *) sharedManager;
- (void) decodeMessage: (NSData *)incomingData;

@end
