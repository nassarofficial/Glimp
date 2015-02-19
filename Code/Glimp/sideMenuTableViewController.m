//
//  sideMenuTableViewController.m
//  Glimp
//
//  Created by Ahmed Salah on 12/6/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import "sideMenuTableViewController.h"
#import "ProfileViewController.h"
#import "DescreptionViewController.h"
#import "AppDelegate.h"
@interface sideMenuTableViewController ()
{
    BOOL firstTime;
}
@end

@implementation sideMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
//    CGRect rect = self.tableView.frame;
//    rect.origin.y = rect.origin.y+100;
//    [self.tableView setFrame:rect];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" ];
    if (cell == nil)
       cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] ;
  
    cell.backgroundColor = [UIColor clearColor];
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Map";
            break;
        case 1:
            cell.textLabel.text = @"Profile";
            break;
        case 2:
            cell.textLabel.text = @"Privacy and Policy";
            break;
        case 3:
            cell.textLabel.text = @"Terms";
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    IIViewDeckController *tab = (IIViewDeckController *)appDelegate.viewController;
    UINavigationController *navg = appDelegate.navg;
    switch (indexPath.row) {
        case 0:{
            if (![((UINavigationController *)tab.centerController).topViewController isKindOfClass:[mapViewController class]]){
            mapViewController *map = [[mapViewController alloc]initWithNibName:@"mapViewController" bundle:nil];
            navg.viewControllers = [NSArray arrayWithObject:map];
            self.viewDeckController.centerController = navg;
            }
            break;

        }
        case 1:{
            if (![((UINavigationController *)tab.centerController).topViewController isKindOfClass:[ProfileViewController class]]){
          

            ProfileViewController *profile = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
            profile.user = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]];
            profile.myProfile = YES;
                navg.viewControllers = [NSArray arrayWithObject:profile];
            self.viewDeckController.centerController = navg;
            }
            break;

        }
        case 2:{
            DescreptionViewController *desc = [[DescreptionViewController alloc] initWithNibName:@"DescreptionViewController" bundle:nil];
            desc.stringURL = @"http://www.glimpnow.com/#!CopyofPrivacy/c1rrp";
            desc.title = @"Privacy and Policy";
            navg.viewControllers = [NSArray arrayWithObject:desc];

            [self.viewDeckController setCenterController:navg];
            break;
        }
        case 3:{
            DescreptionViewController *desc = [[DescreptionViewController alloc] initWithNibName:@"DescreptionViewController" bundle:nil];
            desc.stringURL = @"http://www.glimpnow.com/#!CopyofTerms/c1x6q";
            desc.title = @"Terms";
            navg.viewControllers = [NSArray arrayWithObject:desc];
            
            [self.viewDeckController setCenterController:navg];
            break;
        }
        default:
            break;
    }
    [self closeLeftView];
}
- (void)closeLeftView{
    AppDelegate* del = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [(IIViewDeckController *)del.viewController closeLeftViewAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (firstTime) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        
    }
    firstTime = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}
@end
