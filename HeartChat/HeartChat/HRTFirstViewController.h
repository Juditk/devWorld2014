//
//  HRTFirstViewController.h
//  HeartChat
//
//  Created by Judit Klein on 1/09/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRTPeerManager.h"

@interface HRTFirstViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *nearbyPeersArray;
    UITableView *tableView;
}

@property (nonatomic,retain) NSMutableArray *nearbyPeersArray;
@property (nonatomic,retain) IBOutlet UITableView *tableView;

@end
