//
//  FriendsTableViewController.m
//  Glimp
//
//  Created by Ahmed Salah on 12/5/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "FreindsCell.h"
#import "ProfileViewController.h"
@interface FriendsTableViewController ()<FriendsllDelegate>

@end

@implementation FriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.viewTitle;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.friends.count==0?1:self.friends.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier1 = @"Cell";

    FreindsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (cell == nil) {
        cell = [[FreindsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] ;
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.friends.count == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"There is no %@ Friends",self.viewTitle];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.followButton.hidden = YES;
        cell.userInteractionEnabled =NO;
    }else{
        UserModel *user = [self.friends objectAtIndex:indexPath.row];
        if (user.isFollowed) {
            [cell.followButton setSelected:YES];
        }else{
            [cell.followButton setSelected:NO];
        }
        if (user.userName != nil) {
            cell.titleLabel.text = user.userName;
        }
        [cell.contactImage setImageWithURL:[NSURL URLWithString:user.imageUrl] placeholderImage:[UIImage imageNamed:@""]];
    }

    return  cell;
    
}

-(void) didTappedAddfriendButtonAtCell:(FreindsCell *)cell type:(UIButton *)button{
    [SVProgressHUD show];
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    [self followUsers:index follow:button];
}

- (void)followUsers:(NSIndexPath *)index follow:(UIButton *)btn {
    UserModel *friend = [self.friends objectAtIndex:index.row];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:KHostURL,!btn.selected?KFollowUser:KUnFollowUser];
    NSMutableDictionary *parameters =  [NSMutableDictionary new];
    
    if (self.user.userId)
        [parameters setObject:self.user.userId forKey:@"userID"];
    if(friend.userId)
        [parameters setObject:friend.userId forKey:@"friendID"];
    
    [NSURLSessionConfiguration defaultSessionConfiguration];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        SBJSON* parser = [[SBJSON alloc] init];
        NSString *response = [parser stringWithObject:responseObject];
        btn.selected = !btn.selected;
        NSLog(@"Response: %@", response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"error"];
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

        ProfileViewController *profile = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
        profile.user = [self.friends objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:profile animated:YES];
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
