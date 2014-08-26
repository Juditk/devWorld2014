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

@synthesize tableView;

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
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ( picker != nil ) {
        [picker dismissViewControllerAnimated:YES completion:NULL];
    }
    
}

#pragma mark tableView delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[WATMessageServer sharedManager]receivedImages]count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    static NSString *cellIdentifier = @"peerCell";
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UIImage *image = [[[WATMessageServer sharedManager]receivedImages]objectAtIndex:indexPath.row];
    cell.imageView.image = image;
    
    return cell;
}



#pragma mark show images

- (void) updateImages
{
    NSLog(@"reloading data");
    [tableView reloadData];
}


@end
