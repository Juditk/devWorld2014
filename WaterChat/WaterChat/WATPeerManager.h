//
//  WATPeerManager.h
//  WaterChat
//
//  Created by Judit Klein on 26/08/14.
//  Copyright (c) 2014 Judit Klein
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "WATRemotePeer.h"
#import "WATConstants.h"
#import "WATMessageServer.h"


@interface WATPeerManager : NSObject <MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate>
{
    MCNearbyServiceAdvertiser *serviceAdvertiser;
    MCNearbyServiceBrowser *serviceBrowser;
    MCPeerID *myPeerID;
    MCSession *session;
    NSMutableArray *nearbyPeers;
}

@property (nonatomic, strong) MCNearbyServiceAdvertiser *serviceAdvertiser;
@property (nonatomic, strong) MCNearbyServiceBrowser *serviceBrowser;
@property (nonatomic, strong) MCPeerID *myPeerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) NSMutableArray *nearbyPeers;
@property (nonatomic, strong) NSString *encodedImage;


+ (WATPeerManager *) sharedPeerManager;
- (void)updatePeerInfoForPeerID:(NSString*)realName forPeerName:(NSString*)peerName withImage:(UIImage*)peerImage;
- (void) sendChatMessage:(NSString *)chatMessage;
- (void) sendChatImage:(UIImage *)chatImage;
- (void)setupSession;
- (void)startServices;

@end
