//
//  EditProfileViewController.m
//  Glimp
//
//  Created by Ahmed Salah on 9/27/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import "ProfileViewController.h"
#import "VideoCell.h"
#import "VideoViewController.h"
#import "FriendsTableViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CommentsViewController.h"
@interface ProfileViewController ()<videoCellDelegate>{
    UIPickerView *genderPicker;
    NSArray *pickerData;
    UIToolbar *toolBar;
    ProfileTableViewCell *editProfileCell;
    NSMutableArray *users,*videos;
    BOOL userVideos;
}
@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setTableHeader
{
    [self.userImageView setImageWithURL:[NSURL URLWithString:self.user.imageUrl]];
    [self.followersButton setTitle:self.user.noOfFollowers forState:UIControlStateNormal];
    [self.followingsButton setTitle:self.user.noOfFollowing forState:UIControlStateNormal];
    [self.nameLabel setText:self.user.userName];
    [self.noOfVideos setText:self.user.noOfVideos];
    if (self.myProfile) {
        [self.follow setTitle:@"Edit Profile" forState:UIControlStateNormal];
        
    }else{
        if (self.user.isFollowed){
            [self.follow setTitle:@"Unfollow" forState:UIControlStateSelected];
            [self.follow setSelected:YES];
        } else{
            [self.follow setSelected:NO];
            [self.follow setTitle:@"Follow" forState:UIControlStateNormal];
        }
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Profile";

    
    [SVProgressHUD show];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

//    [self.navigationController.navigationBar
//     setTitleTextAttributes:@{NSForegroundColorAttributeName : RGB(65, 246, 255)}];
    users = [NSMutableArray new];
    videos = [NSMutableArray new];
    self.userImageView.layer.borderWidth = 1.0f;
    self.userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userImageView.layer.masksToBounds = NO;
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2;
    self.userImageView.clipsToBounds = YES;
    self.followersButton.layer.borderWidth = 1.0f;
    self.followersButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.followersButton.layer.masksToBounds = NO;
    self.followersButton.layer.cornerRadius = self.followersButton.frame.size.width / 2;
    self.followersButton.clipsToBounds = YES;
    self.followingsButton.layer.borderWidth = 1.0f;
    self.followingsButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.followingsButton.layer.masksToBounds = NO;
    self.followingsButton.layer.cornerRadius = self.followingsButton.frame.size.width / 2;
    self.followingsButton.clipsToBounds = YES;
    self.navigationController.navigationBar.hidden  = NO;
    
    self.tableView.tableHeaderView = self.headerView;
    [self GetUSerByID];
    [self getUserVideos:nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)GetUSerByID{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:KHostURL,KGetUSerByID];
    NSMutableDictionary *parameters =  [NSMutableDictionary new];
    [parameters setObject:[self.userID length]?self.userID:self.user.userId forKey:@"userID"];
    [NSURLSessionConfiguration defaultSessionConfiguration];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        SBJSON* parser = [[SBJSON alloc] init];
        NSString *response = [parser stringWithObject:responseObject];
        NSDictionary* myDict = [parser objectWithString:response error:nil];
    NSDictionary *userDict = [[myDict objectForKey:@"GetUserByIDResult"] objectForKey:@"ReturnedObject"];
        UserModel *user = [[UserModel alloc]initWithData:userDict];
        self.user = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]];
        if ([self.user.userId intValue] == [user.userId intValue]) {
            self.myProfile = YES;
        }
        self.user = user;
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self setTableHeader];
                       });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"error"];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

        return videos.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 113;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier2 = @"VideoCell";
   
        VideoCell *videocell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (videocell == nil) {
            videocell = [[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] ;
        }
        if (videos.count!=0) {
            videocell.delegate = self;
            [videocell setBackgroundColor:[UIColor clearColor]];
            VideoModel *video = [videos objectAtIndex:indexPath.row];
            videocell.liveImage.backgroundColor = video.isLive?[UIColor greenColor]:[UIColor grayColor];
            videocell.comment.text = video.comment ?video.comment:@"";
            videocell.Location.text = video.videoLocation ?video.videoLocation:@"";
            videocell.Date.text = video.uploadedTime?video.uploadedTime:@"";
            videocell.noOfViews.text = [NSString stringWithFormat:@"%i", video.noOfViews];
            videocell.noOfComments.text = [NSString stringWithFormat:@"%i", video.noOfComments];
        }
  
        return  videocell;

   
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

        VideoViewController *video = [[VideoViewController alloc]initWithNibName:@"VideoViewController" bundle:nil];
        VideoModel *currentVideo = [videos objectAtIndex:indexPath.row];
      
        video.currentVideo = currentVideo;
        [self presentViewController:video animated:YES completion:nil];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)followUsers:(NSIndexPath *)index follow:(UIButton *)btn
{
    UserModel *friend = [users objectAtIndex:index.row];
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

#pragma mark - Table view data source

- (IBAction)followingsUsers:(id)sender {

    [users removeAllObjects];
    NSMutableDictionary *parameters =  [NSMutableDictionary new];
    [parameters setObject:[self.user.userId stringValue] forKey:@"userID"];
    NSString *url = [NSString stringWithFormat:KHostURL,KGetUserFollowings];
    [SVProgressHUD showWithStatus:@"Getting followings friends..."];
    [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SBJSON* parser = [[SBJSON alloc] init];
        NSString *response = [parser stringWithObject:responseObject];
        NSDictionary* myDict = [parser objectWithString:response error:nil];
        if ([[[myDict objectForKey:@"GetUserFollowingsResult"] objectForKey:@"ReturnedObject"] isKindOfClass:[NSArray class]]) {
            NSArray *arr = [[myDict objectForKey:@"GetUserFollowingsResult"] objectForKey:@"ReturnedObject"] ;
            for (NSDictionary *dic in arr) {
                UserModel * user = [[UserModel alloc]initWithData:dic];
                [users addObject:user];
            }
        }else{
            NSDictionary *userDict = [[myDict objectForKey:@"GetUserFollowingsResult"] objectForKey:@"ReturnedObject"];
            UserModel * user = [[UserModel alloc]initWithData:userDict];
            [users addObject:user];
        }
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                    
                           FriendsTableViewController *frindsView = [[FriendsTableViewController alloc] init];
                           frindsView.user = self.user;
                           frindsView.friends = users;
                           frindsView.viewTitle = @"Followings";
                               [self.navigationController pushViewController:frindsView animated:YES];
                           [SVProgressHUD dismiss];
                           });
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"Error getting followings friends"];
    }];

}

- (IBAction)followersUsers:(id)sender {
    [users removeAllObjects];
    NSMutableDictionary *parameters =  [NSMutableDictionary new];
    [parameters setObject:[self.user.userId stringValue] forKey:@"userID"];
    NSString *url = [NSString stringWithFormat:KHostURL,KGetUserFollowers];
    [SVProgressHUD showWithStatus:@"Getting followers friends ..."];
    [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SBJSON* parser = [[SBJSON alloc] init];
        NSString *response = [parser stringWithObject:responseObject];
        NSDictionary* myDict = [parser objectWithString:response error:nil];
        if ([[[myDict objectForKey:@"GetUserFollowersResult"] objectForKey:@"ReturnedObject"] isKindOfClass:[NSArray class]]) {
            NSArray *arr = [[myDict objectForKey:@"GetUserFollowersResult"] objectForKey:@"ReturnedObject"] ;
            for (NSDictionary *dic in arr) {
                UserModel * user = [[UserModel alloc]initWithData:dic];
                [users addObject:user];
            }
        }else{
            NSDictionary *userDict = [[myDict objectForKey:@"GetUserFollowersResult"] objectForKey:@"ReturnedObject"];
            UserModel * user = [[UserModel alloc]initWithData:userDict];
            [users addObject:user];
        }
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           FriendsTableViewController *frindsView = [[FriendsTableViewController alloc] init];
                           frindsView.user = self.user;
                           frindsView.friends = users;
                           frindsView.viewTitle = @"Followers";
                               [self.navigationController pushViewController:frindsView animated:YES];
                           [SVProgressHUD dismiss];
    
                       });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"Error Getting followers"];
    }];

}

- (IBAction)followAction:(id)sender {
  
    if (!self.myProfile) {
        __block UIButton *button = (UIButton *)sender;
        button.selected = !button.selected;
        UserModel *myProfileUser = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *url = [NSString stringWithFormat:KHostURL,button.selected?KFollowUser:KUnFollowUser];
        NSMutableDictionary *parameters =  [NSMutableDictionary new];
 
        if (self.user.userId)
            [parameters setObject:self.user.userId forKey:@"friendID"];
        if (myProfileUser.userId)
            [parameters setObject:myProfileUser.userId forKey:@"userID"];
        
        [NSURLSessionConfiguration defaultSessionConfiguration];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            SBJSON* parser = [[SBJSON alloc] init];
            NSString *response = [parser stringWithObject:responseObject];
            if (!button.selected) {
                [self.follow setTitle:@"Follow" forState:UIControlStateNormal];
            }else{
                [self.follow setTitle:@"Unfollow" forState:UIControlStateSelected];
            }
            NSLog(@"Response: %@", response);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            button.selected = !button.selected;
            [SVProgressHUD showErrorWithStatus:@"error"];
        }];
    }else{
        EditProfileViewController2 *editProfile = [[EditProfileViewController2 alloc]init];
        editProfile.fromMap = YES;
        [self.navigationController pushViewController:editProfile animated:YES];

    }
   
}
-(void)didTappedAddCommentButtonAtCell:(VideoCell *)cell{
    CommentsViewController *comment = [[CommentsViewController alloc]initWithNibName:@"CommentsViewController" bundle:nil];
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    VideoModel *video = [videos objectAtIndex: index.row];
    comment.videoID = video.videoID;
    [self.navigationController pushViewController:comment animated:YES];
}
- (IBAction)getUserVideos:(id)sender {
    [videos removeAllObjects];
    NSMutableDictionary *parameters =  [NSMutableDictionary new];
    [parameters setObject:self.userID?self.userID:[self.user.userId stringValue] forKey:@"userId"];
    NSString *url = [NSString stringWithFormat:KHostURL,KGetUserVideos];
    [SVProgressHUD show];
    [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SBJSON* parser = [[SBJSON alloc] init];
        NSString *response = [parser stringWithObject:responseObject];
        NSDictionary* myDict = [parser objectWithString:response error:nil];
        if ([[[myDict objectForKey:@"GetUserVideosResult"] objectForKey:@"ReturnedObject"] isKindOfClass:[NSArray class]]) {
            NSArray *arr = [[myDict objectForKey:@"GetUserVideosResult"] objectForKey:@"ReturnedObject"] ;
            for (NSDictionary *dic in arr) {
                VideoModel * video = [[VideoModel alloc]initWithData:dic];
                [videos addObject:video];
            }
        }else{
            NSDictionary *userDict = [[myDict objectForKey:@"GetUserVideosResult"] objectForKey:@"ReturnedObject"];
            VideoModel * video = [[VideoModel alloc]initWithData:userDict];
            [videos addObject:video];
        }
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           userVideos = YES;
                           self.noOfVideos.text =[NSString stringWithFormat:@"%lu",(unsigned long)videos.count];
                           [self.tableView reloadData];
                       });
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"Error"];
    }];
}
@end
