//
//  HRTMessageServer.h
//  HeartChat
//
//  Created by Judit Klein on 1/09/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRTConstants.h"
#import "HRTPeerManager.h"

@interface HRTMessageServer : NSObject
{
    NSString *receivedMessage;
    NSMutableArray *recevivedImages;
}


@property (nonatomic, strong) NSString *receivedMessage;
@property (nonatomic, strong) NSMutableArray *receivedImages;


+ (HRTMessageServer *) sharedManager;
- (void) decodeMessage: (NSData *)incomingData;
- (void) updateImagesArray:(UIImage *)image;

@end

