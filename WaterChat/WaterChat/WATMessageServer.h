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
{
    NSString *receivedMessage;
    NSMutableArray *recevivedImages;
}


@property (nonatomic, strong) NSString *receivedMessage;
@property (nonatomic, strong) NSMutableArray *receivedImages;


+ (WATMessageServer *) sharedManager;
- (void) decodeMessage: (NSData *)incomingData;
- (void) updateImagesArray:(UIImage *)image;

@end
