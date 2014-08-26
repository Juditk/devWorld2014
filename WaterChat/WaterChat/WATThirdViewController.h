//
//  WATThirdViewController.h
//  WaterChat
//
//  Created by Judit Klein on 27/08/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WATPeerManager.h"
#import "WATMessageServer.h"

@interface WATThirdViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tableview;
}

@property (nonatomic,retain) IBOutlet UITableView *tableView;

- (IBAction)sendPhoto:(id)sender;


@end
