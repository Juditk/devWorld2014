//
//  WATFirstViewController.h
//  WaterChat
//
//  Created by Judit Klein on 25/08/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WATPeerManager.h"

@interface WATFirstViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *nearbyPeersArray;
    UITableView *tableView;
}

@property (nonatomic,retain) NSMutableArray *nearbyPeersArray;
@property (nonatomic,retain) IBOutlet UITableView *tableView;

@end
