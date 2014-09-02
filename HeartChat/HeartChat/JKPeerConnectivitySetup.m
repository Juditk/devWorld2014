//
//  JKPeerConnectivitySetup.m
//  HeartChat
//
//  Created by Judit Klein on 2/09/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import "JKPeerConnectivitySetup.h"

@implementation JKPeerConnectivitySetup

@synthesize deviceNameIdentifier, groupIdentifier;

+ (JKPeerConnectivitySetup *) sharedSetup
{
    static JKPeerConnectivitySetup *sharedSetup = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSetup = [[self alloc] init];
    });
    return sharedSetup;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        deviceNameIdentifier = [[UIDevice currentDevice]name];
        groupIdentifier = @"default";
    
        NSString *UUIDToSave = [[NSUUID UUID] UUIDString];
        myUniqueID = [UUIDToSave substringToIndex:15];
        
    }
    return self;
}

@end
