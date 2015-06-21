//
//  RECustomTextCell.h
//  Glimp
//
//  Created by Ahmed Salah on 9/30/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import "RETableViewCell.h"
#import "ReCustomTextItem.h"
@interface RECustomTextCell : RETableViewCell<UITextFieldDelegate>
@property (nonatomic,strong) ReCustomTextItem *item;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
