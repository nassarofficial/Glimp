//
//  REImagePickerCell2.h
//  Warshety
//
//  Created by Mohamed Abd El-latef on 7/26/14.
//  Copyright (c) 2014 Mohamed Abd El-latef. All rights reserved.
//

#import "RETableViewCell.h"
#import "TKCircularButton.h"
#import "REImagePickerItem.h"
@interface REImagePickerCell : RETableViewCell
@property (weak, nonatomic) IBOutlet TKCircularButton *imageButton;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (nonatomic,strong) REImagePickerItem * item;

@end
