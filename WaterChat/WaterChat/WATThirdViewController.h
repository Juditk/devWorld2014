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

@interface WATThirdViewController : UIViewController <UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    UICollectionView *imageCollectionView;
}

@property (nonatomic,retain) IBOutlet UICollectionView *imageCollectionView;

- (IBAction)sendPhoto:(id)sender;


@end
