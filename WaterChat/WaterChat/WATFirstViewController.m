//
//  WATFirstViewController.m
//  WaterChat
//
//  Created by Judit Klein on 25/08/14.
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

#import "WATFirstViewController.h"

@interface WATFirstViewController ()

@end

@implementation WATFirstViewController

@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self performSelector:@selector(firstRunExperience) withObject:nil afterDelay:0.1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateArray)
                                                 name:@"updateArray"
                                               object:nil];

}

- (void) updateArray
{
    NSLog(@"reloading data");
    [tableView reloadData];
}

#pragma mark - Table view delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[WATPeerManager sharedPeerManager]nearbyPeers]count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    static NSString *cellIdentifier = @"peerCell";
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    WATRemotePeer *peer = [[[WATPeerManager sharedPeerManager]nearbyPeers]objectAtIndex:indexPath.row];
    
    if (peer.remotePeerName) {
        cell.textLabel.text = peer.remotePeerName;
    } else {
        cell.textLabel.text = peer.remotePeerID;
    }
    
    if (peer.remotePeerImage) {
        cell.imageView.image = peer.remotePeerImage;
    }
    
    return cell;
}

#pragma first run

- (void) firstRunExperience
{
    if (![[NSUserDefaults standardUserDefaults] valueForKeyPath:@"personalID"] )
    {
        NSLog(@"Information missing, this might be the first time we are running");
        
        [self generateUniqueID];
        
        NSString *deviceName = [[UIDevice currentDevice] name];
        [[NSUserDefaults standardUserDefaults] setObject: deviceName forKey: @"Name"];
        
        [[WATPeerManager sharedPeerManager]startServices];
        
    } else {
        
        [[WATPeerManager sharedPeerManager]startServices];
    }
}

- (void)generateUniqueID
{
    NSString *UUIDToSave = [[NSUUID UUID] UUIDString];
    UUIDToSave = [UUIDToSave substringToIndex:15];
    
    [[NSUserDefaults standardUserDefaults] setObject: UUIDToSave forKey: @"personalID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
