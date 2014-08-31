//
//  HRTThirdViewController.h
//  HeartChat
//
//  Created by Judit Klein on 1/09/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRTPeerManager.h"
#import "HRTMessageServer.h"

@interface HRTThirdViewController : UIViewController <UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    UICollectionView *imageCollectionView;
}

@property (nonatomic,retain) IBOutlet UICollectionView *imageCollectionView;

- (IBAction)sendPhoto:(id)sender;


@end
