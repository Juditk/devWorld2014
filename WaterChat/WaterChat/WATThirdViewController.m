//
//  WATThirdViewController.m
//  WaterChat
//
//  Created by Judit Klein on 27/08/14.
//  Copyright (c) 2014 juditk. All rights reserved.
//

#import "WATThirdViewController.h"

@interface WATThirdViewController ()

@end

@implementation WATThirdViewController

@synthesize imageCollectionView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateImages)
                                                 name:@"updateImages"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendPhoto:(id)sender
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // There is not a camera on this device, so don't show the camera button.
        NSLog(@"There is no camera available, hide the camera button");
        
        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
    } else {
        
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                                  delegate: self
                                                         cancelButtonTitle: @"Cancel"
                                                    destructiveButtonTitle: nil
                                                         otherButtonTitles: @"Take Photo",
                                       @"Choose Existing Photo", nil];
        
        [actionSheet showInView:self.view];
        
    }
}

#pragma mark image picker

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"Take Photo");
        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else if (buttonIndex == 1) {
        NSLog(@"Choose Photo");
        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = NO;
    picker.sourceType = sourceType;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    //Send the selected image to all peers
    [[WATPeerManager sharedPeerManager]sendChatImage:chosenImage];
    
    //Make sure the image appears in our own view
    [[WATMessageServer sharedManager]updateImagesArray:chosenImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ( picker != nil ) {
        [picker dismissViewControllerAnimated:YES completion:NULL];
    }
    
}

#pragma mark tableView delegate methods

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView {
    
    return 1; // The number of sections we want
}


-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section {
    
    return [[[WATMessageServer sharedManager]receivedImages]count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell"
                                              forIndexPath:indexPath]; // Create the cell from the storyboard cell
    
    
    UIImageView *imageItemCellImageView = (UIImageView*)[cell viewWithTag:100];
    UIImage *image = [[[WATMessageServer sharedManager]receivedImages]objectAtIndex:indexPath.row];
    imageItemCellImageView.image = image;
    
    return cell; // Return the cell
}





#pragma mark show images

- (void) updateImages
{
    NSLog(@"reloading data");
    [imageCollectionView reloadData];
}


@end