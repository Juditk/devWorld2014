//
//  HRTFirstViewController.m
//  HeartChat
//
//  Created by Judit Klein on 1/09/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import "HRTFirstViewController.h"

@interface HRTFirstViewController ()

@end

@implementation HRTFirstViewController

@synthesize tableView, nearbyPeersArray;

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
    return [[[HRTPeerManager sharedPeerManager]nearbyPeers]count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    static NSString *cellIdentifier = @"peerCell";
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    HRTRemotePeer *peer = [[[HRTPeerManager sharedPeerManager]nearbyPeers]objectAtIndex:indexPath.row];
    
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
        
        [[HRTPeerManager sharedPeerManager]startServices];
        
    } else {
        
        [[HRTPeerManager sharedPeerManager]startServices];
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