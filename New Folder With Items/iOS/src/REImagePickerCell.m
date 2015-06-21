//
//  REImagePickerCell2.m
//  Warshety
//
//  Created by Mohamed Abd El-latef on 7/26/14.
//  Copyright (c) 2014 Mohamed Abd El-latef. All rights reserved.
//

#import "REImagePickerCell.h"
#import "NoStatusBarImagePickerController.h"
#import "AppDelegate.h"
@interface REImagePickerCell ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@end
@implementation REImagePickerCell

+(CGFloat)heightWithItem:(RETableViewItem *)item tableViewManager:(RETableViewManager *)tableViewManager{
    return 162;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        if (!self.item.isCircular) {
            int width = 115;
            int height = 80;
            self.imageButton.frame = CGRectMake(320 / 2 - ( width /2 ), 10, width, height);
            self.imageButton.layer.cornerRadius = 10.0;
            self.imageButton.layer.borderColor = [UIColor yellowColor].CGColor;
            self.userName.text  = self.item.userName;
            self.backgroundColor = [UIColor clearColor];

        }
        self.userName.text  = self.item.userName;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if (!self.item.isCircular) {
            int width = 115;
            int height = 80;
            self.imageButton.frame = CGRectMake(320 / 2 - ( width /2 ), 10, width, height);
            self.imageButton.layer.cornerRadius = 10.0;
            self.imageButton.layer.borderColor = [UIColor yellowColor].CGColor;
            
        }
        self.userName.text  = self.item.userName;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        if (!self.item.isCircular) {
            int width = 115;
            int height = 80;
            self.imageButton.frame = CGRectMake(320 / 2 - ( width /2 ), 10, width, height);
            self.imageButton.layer.cornerRadius = 10.0;
            self.imageButton.layer.borderColor = [UIColor yellowColor].CGColor;
        }
        self.userName.text  = self.item.userName;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (IBAction)buttonActionHandler:(id)sender {
    UIActionSheet *imageSourceOptions;
    if (self.item.EnableClearOption) {
        imageSourceOptions = [[UIActionSheet alloc]
                                             initWithTitle:nil
                                             delegate:nil
                                             cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                             destructiveButtonTitle:nil
                                             otherButtonTitles:
                                             NSLocalizedString(@"Photo Library", @""),
                                             NSLocalizedString(@"Camera",@""),
                                             NSLocalizedString(@"Clear",@""),nil];
    }
    else{
        imageSourceOptions = [[UIActionSheet alloc]
                                             initWithTitle:nil
                                             delegate:nil
                                             cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                             destructiveButtonTitle:nil
                                             otherButtonTitles:
                                             NSLocalizedString(@"Photo Library", @""),
                                             NSLocalizedString(@"Camera",@""),nil];
    }

    imageSourceOptions.delegate = self;
    [self.parentTableView endEditing:YES];
    [imageSourceOptions showInView:self];
}

-(void)setCircledImage:(UIImage*)image{
    [self.imageButton setImage:image forState:UIControlStateNormal];
}


#pragma mark - Action Sheet Delegate

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerControllerSourceType source;
    
    if(buttonIndex == 0)
    {
        source = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if (buttonIndex == 1)
    {
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"No camera on device", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            return;
        }
        source = UIImagePickerControllerSourceTypeCamera;
    }
    else if (buttonIndex == 2 && self.item.EnableClearOption)
    {
        self.item.circledImage = nil;
        self.item.imageName = nil;
        
        [self setCircledImage:self.item.circledImage];
        return;
    }
    else
    {
        return;
    }
    
    NoStatusBarImagePickerController *imagePickerController = [[NoStatusBarImagePickerController alloc]init];
    imagePickerController.sourceType = source;
    imagePickerController.delegate = self;
    if (source != UIImagePickerControllerSourceTypeCamera) {
        imagePickerController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController];
}

#pragma mark UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.item.circledImage = [info valueForKey:UIImagePickerControllerEditedImage];
    NSString *imageUrl = [info objectForKey:UIImagePickerControllerReferenceURL];

    self.item.imageData = [NSData dataWithContentsOfFile:imageUrl];
    self.item.imageName = nil;
    
    [self setCircledImage:self.item.circledImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TKIconPicker Delegate

- (void) imagePickerControllerDidSelectImage:(UIImage *)image withIconName:(NSString *)iconName{
    
    self.item.imageName = iconName;
    self.item.circledImage = nil;
    
    [self setCircledImage:[UIImage imageNamed:iconName]];
    

}

- (void) presentViewController:(UIViewController*)viewController{
    if ([viewController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController*)viewController).sourceType == UIImagePickerControllerSourceTypeCamera) {
    }
    else {
        viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];


    [ [appDelegate.navg.viewControllers lastObject]  presentViewController:viewController animated:YES completion:nil];
}


@end
