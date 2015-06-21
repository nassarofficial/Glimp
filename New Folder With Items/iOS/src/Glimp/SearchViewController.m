//
//  SearchViewController.m
//  Glimp
//
//  Created by Ahmed Salah on 10/12/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import "SearchViewController.h"
#import "ProfileViewController.h"
@interface SearchViewController ()
{
    NSMutableArray *pastUrls, *users;
    NSString *textSearch;
}
@end

@implementation SearchViewController

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
    users = [NSMutableArray new];
    [self.searchTextField becomeFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;

}
-(void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
}
-(void)hideKeyboard:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)search:(NSString *)text {
    NSString *url;
    NSMutableDictionary *parameters =  [NSMutableDictionary new];
    if (users.count >0) {
        [users removeAllObjects];
    }

    [parameters setObject:text forKey:@"searchText"];
   __block  NSMutableArray *videosArr = [NSMutableArray new];
    __block SearchViewController *blockSelf = self;

    if (self.selectedFilter.selectedSegmentIndex ==  0){
      
        url = [NSString stringWithFormat:KHostURL,KsearchUsers];
        [parameters setObject:self.user.userId forKey:@"currentUserID"];
    }else if(self.selectedFilter.selectedSegmentIndex == 1)
        url = [NSString stringWithFormat:KHostURL,KsearchHashTags];
    else
        url = [NSString stringWithFormat:KHostURL,KsearchLocation];
    [SVProgressHUD showWithStatus:@"Loading.."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [NSURLSessionConfiguration defaultSessionConfiguration];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SBJSON* parser = [[SBJSON alloc] init];
        NSString *response = [parser stringWithObject:responseObject];
        NSDictionary* myDict = [parser objectWithString:response error:nil];
        if (self.selectedFilter.selectedSegmentIndex ==  0) {
            if ([[[myDict objectForKey:@"SearchForUsersResult"] objectForKey:@"ReturnedObject"] isKindOfClass:[NSArray class]]) {
                NSArray *arr = [[myDict objectForKey:@"SearchForUsersResult"] objectForKey:@"ReturnedObject"] ;
                for (NSDictionary *dic in arr) {
                    UserModel * user = [[UserModel alloc]initWithData:dic];
                    [users addObject:user];
                }
            }else{
                NSDictionary *userDict = [[myDict objectForKey:@"SearchForUsersResult"] objectForKey:@"ReturnedObject"];
                UserModel * user = [[UserModel alloc]initWithData:userDict];
                [users addObject:user];
            }
                
    
            
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               [self.tableView reloadData];
                           });
        }else if (self.selectedFilter.selectedSegmentIndex ==  2){
            VideoModel * video;
            if ([[[myDict  objectForKey:@"SearchForVideosByHashTagsResult"] objectForKey:@"ReturnedObject"] isKindOfClass:[NSMutableArray class]]) {
                NSArray *arr = [[myDict  objectForKey:@"SearchForVideosByHashTagsResult"] objectForKey:@"ReturnedObject"] ;
                for (NSDictionary *dic in arr) {
                    video = [[VideoModel alloc]initWithData:dic];
                    [videosArr addObject:video];
                }
            }else{
                NSDictionary *userDict = [[myDict  objectForKey:@"SearchForVideosByHashTagsResult"] objectForKey:@"ReturnedObject"];
                video = [[VideoModel alloc]initWithData:userDict];
                [videosArr addObject:video];
                
            }
            
            if (videosArr.count != 0) {
                [(mapViewController *)blockSelf.map setFromSearch:YES];
                [(mapViewController *)blockSelf.map setVideosArr:videosArr];
                [blockSelf dismissViewControllerAnimated:YES completion:nil];
            }
        }else{
            VideoModel * videoLocation;
            if ([[[myDict  objectForKey:@"SearchForVideosByLocationResult"] objectForKey:@"ReturnedObject"] isKindOfClass:[NSMutableArray class]]) {
                NSArray *arr = [[myDict  objectForKey:@"SearchForVideosByLocationResult"] objectForKey:@"ReturnedObject"] ;
                for (NSDictionary *dic in arr) {
                    videoLocation = [[VideoModel alloc]initWithData:dic];
                    [videosArr addObject:videoLocation];
                }
            }else{
                NSDictionary *userDict = [[myDict  objectForKey:@"SearchForVideosByLocationResult"] objectForKey:@"ReturnedObject"];
                videoLocation = [[VideoModel alloc]initWithData:userDict];
                [videosArr addObject:videoLocation];
                
            }
            
            if (videosArr.count != 0) {
                [(mapViewController *)blockSelf.map setFromSearch:YES];
                [(mapViewController *)blockSelf.map setVideosArr:videosArr];
                [blockSelf dismissViewControllerAnimated:YES completion:nil];
            }
        }
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"Error Getting Glimps"];
    }];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar  resignFirstResponder];
    textSearch = searchBar.text;
    if (textSearch.length == 0)
        [SVProgressHUD showErrorWithStatus:@"please enter a text to search"];
    else
        [self search:textSearch];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return users.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier1 = @"Cell";
    FreindsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (cell == nil) {
        cell = [[FreindsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] ;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UserModel *user = [users objectAtIndex:indexPath.row];
    [cell setDelegate:self];
    if (user.isFollowed) {
        [cell.followButton setSelected:YES];
    }else{
        [cell.followButton setSelected:NO];
    }
    if (user.userName != nil) {
        cell.titleLabel.text = user.userName;
    }
    
    [cell.contactImage setImageWithURL:[NSURL URLWithString:user.imageUrl] placeholderImage:[UIImage imageNamed:@""]];
    return  cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileViewController *profile = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    profile.user = [users objectAtIndex:indexPath.row];
    profile.fromSearch = YES;
    profile.myProfile = NO;
    [self.navigationController pushViewController:profile animated:YES];
}

-(void) didTappedAddfriendButtonAtCell:(FreindsCell *)cell type:(UIButton *)button{
    [SVProgressHUD show];
    
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    
    [self followUsers:index follow:button];
    
}

- (void)followUsers:(NSIndexPath *)index follow:(UIButton *)btn {
    UserModel *friend = [users objectAtIndex:index.row];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:KHostURL,!btn.selected?KFollowUser:KUnFollowUser];
    NSMutableDictionary *parameters =  [NSMutableDictionary new];
    UserModel *user =[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]];
    if (user.userId)
        [parameters setObject:user.userId forKey:@"userID"];
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

- (IBAction)searchButton:(id)sender {
    [(mapViewController *)self.map setFromSearch:NO];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}
@end
