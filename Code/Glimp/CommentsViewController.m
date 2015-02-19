//
//  CommentsViewController.m
//  Glimp
//
//  Created by Ahmed Salah on 11/26/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentCellTableViewCell.h"
#import "ProfileViewController.h"
#define kNumberOfItemsToAdd 10

@interface CommentsViewController ()<commentCellDelegate>
{
    NSMutableArray *comments;
    NSUInteger numberOfItemsToDisplay;
    int pageNo;
}
@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    comments  = [NSMutableArray new];
    numberOfItemsToDisplay = kNumberOfItemsToAdd;

    self.user = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]];
    pageNo = 1;
    [self loadComments];
    CGRect viewBounds = [[self view] bounds];
    CGRect frame = CGRectMake(0.0f,
                              viewBounds.size.height - PHFComposeBarViewInitialHeight,
                              viewBounds.size.width,
                              PHFComposeBarViewInitialHeight);
    PHFComposeBarView *composeBarView = [[PHFComposeBarView alloc] initWithFrame:frame];
    [composeBarView setMaxCharCount:160];
    [composeBarView setMaxLinesCount:5];
    [composeBarView setPlaceholder:@"Type your comment..."];
    [[composeBarView utilityButton] removeFromSuperview];
    [composeBarView setButtonTitle:@"Post"];
    [composeBarView setDelegate:self];
    [self.view addSubview:composeBarView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillToggle:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillToggle:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self.tableView setAllowsSelection:YES];
}
-(void)hideKeyboard:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
}
-(void)loadComments{
    int  noOfComments = 10;
    [SVProgressHUD show];
    [Flurry logEvent:@"Get all Get Comments"];
    NSMutableDictionary *parameters =  [NSMutableDictionary new];
    [parameters setObject:[NSNumber numberWithInt:[self.videoID intValue] ] forKey:@"videoId"];
    [parameters setObject:[NSNumber numberWithInt:noOfComments] forKey:@"noOfComments"];
    [parameters setObject:[NSNumber numberWithInt:pageNo] forKey:@"pageNo"];
    NSString *url = [NSString stringWithFormat:KHostURL,KGetVideoComment];
    [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        pageNo ++;
        SBJSON* parser = [[SBJSON alloc] init];
        NSString *response = [parser stringWithObject:responseObject];
        NSDictionary* myDict = [parser objectWithString:response error:nil];
        if ([[[myDict objectForKey:@"GetCommentsResult"] objectForKey:@"ReturnedObject"] isKindOfClass:[NSArray class]]) {
            NSArray *arr = [[myDict objectForKey:@"GetCommentsResult"] objectForKey:@"ReturnedObject"] ;
            if (pageNo>1) {
                comments = [[comments reverseObjectEnumerator] allObjects];
            }
            for (NSDictionary *dic in arr) {
               CommentModel *comment = [[CommentModel alloc]initWithData:dic];
          
                [comments addObject:comment];
            }
        }else{
            NSDictionary *userDict = [[myDict objectForKey:@"GetCommentsResult"] objectForKey:@"ReturnedObject"];
            CommentModel *comment = [[CommentModel alloc]initWithData:userDict];
            [comments addObject:comment];
        }
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           comments = [[comments reverseObjectEnumerator] allObjects];
                           [self.tableView reloadData];
                       });
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Error loading Coments"];
    }];
}
- (void)keyboardWillToggle:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSTimeInterval duration;
    UIViewAnimationCurve animationCurve;
    CGRect startFrame;
    CGRect endFrame;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]    getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey]        getValue:&startFrame];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]          getValue:&endFrame];
    
    NSInteger signCorrection = 1;
    if (startFrame.origin.y < 0 || startFrame.origin.x < 0 || endFrame.origin.y < 0 || endFrame.origin.x < 0)
        signCorrection = -1;
    
    CGFloat widthChange  = (endFrame.origin.x - startFrame.origin.x) * signCorrection;
    CGFloat heightChange = (endFrame.origin.y - startFrame.origin.y) * signCorrection;
    CGFloat sizeChange = UIInterfaceOrientationIsLandscape([self interfaceOrientation]) ? widthChange : heightChange;
    
    CGRect newContainerFrame = [[self view] frame];
    CGRect newTableFrame = [[self tableView] frame];
    newContainerFrame.size.height += sizeChange;
    newTableFrame.size.height += sizeChange;
    [UIView animateWithDuration:duration
                          delay:0
                        options:(animationCurve << 16)|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [[self view] setFrame:newContainerFrame];
                         [[self tableView] setFrame:newTableFrame];
                     }
                     completion:NULL];
}


- (void)composeBarViewDidPressButton:(PHFComposeBarView *)composeBarView {
    NSString *text = [composeBarView text];
    [composeBarView setText:@"" animated:YES];
    [composeBarView resignFirstResponder];
    [SVProgressHUD show];
    [Flurry logEvent:@"Adding Comment"];
    NSMutableDictionary *parameters =  [NSMutableDictionary new];
    [parameters setObject:text forKey:@"comment"];
    [parameters setObject:[NSNumber numberWithInt:[self.videoID intValue]] forKey:@"videoId"];
    [parameters setObject:self.user.userId forKey:@"userId"];
    [parameters setObject:self.user.firstName forKey:@"userFirstName"];
    [parameters setObject:self.user.lastName forKey:@"userLastName"];
    NSString *url = [NSString stringWithFormat:KHostURL,KAddVideoComment];
    [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [comments removeAllObjects];
        pageNo = 1;
        [self loadComments];
        
        
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Error Posting your Coments"];
    }];
///public static bool Addcomment(int videoId, int userId, string comment)
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/////

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.

    return (comments.count<10)?1:2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (comments.count >= 10 && section == 1){
        return [comments count];
    }else if(comments.count <10 && comments.count >0 && section == 0)
        return comments.count;
    else
        return 1;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && comments.count >= 10) {
        return 30;
    }
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
#pragma tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && comments.count>=10)
        [self loadComments];
        

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    

    
    if((indexPath.section == 1 && comments.count>=10 )||(indexPath.section == 0 && comments.count<10 && comments.count != 0)){
        NSString *CellIdentifier = @"CommentCell";
        
        CommentCellTableViewCell *CommentCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (CommentCell == nil) {
            CommentCell = [[CommentCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        CommentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        CommentCell.delegate = self;
        CommentModel *comment = [comments objectAtIndex:indexPath.row];
        CommentCell.commentLabel.text = comment.comment;
        CommentCell.timeLabel.text = comment.commentTime;
        [CommentCell.timeLabel adjustsFontSizeToFitWidth];
        [CommentCell.userNameLabel setTitle:comment.user.userName forState:UIControlStateNormal] ;
        [CommentCell.userImage setImageWithURL:[NSURL URLWithString:comment.user.imageUrl]];
        return CommentCell;
    }else {
        NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setBackgroundColor:[UIColor clearColor]];

        if(comments.count==10){
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.text = @"Load more comments...";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        return cell;
    }


}
- (void) didTappedAddfriendButtonAtCell:(CommentCellTableViewCell *)cell{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    ProfileViewController *profile = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    profile.user = [(CommentModel*)[comments objectAtIndex:index.row] user];
    profile.myProfile = NO;
    [self.navigationController pushViewController:profile animated:YES];
}
@end
