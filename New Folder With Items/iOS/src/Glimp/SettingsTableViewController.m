//
//  sideMenuTableViewController.m
//  Glimp
//
//  Created by Ahmed Salah on 12/6/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "ProfileViewController.h"
#import "DescreptionViewController.h"
#import "AppDelegate.h"
#import "StartingViewController.h"
@interface SettingsTableViewController ()
{
    BOOL firstTime;
}
@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Settings";
    [self.tableView setBackgroundColor:RGB(237, 246, 249)];
//    CGRect rect = self.tableView.frame;
//    rect.origin.y = rect.origin.y+100;
//    [self.tableView setFrame:rect];
    CGRect rect = self.tableView.frame;
    rect.origin.x = rect.origin.x+30;
    rect.size.width = rect.size.width-30;
    [self.tableView setFrame:rect];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
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

    return 3;
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" ];
    if (cell == nil)
       cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] ;

    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.layer.masksToBounds = NO;
    cell.layer.cornerRadius = 3.0f;
    cell.clipsToBounds = YES;
    cell.backgroundColor = [UIColor whiteColor];
    // Configure the cell...
    switch (indexPath.row) {
       
        case 0:
            cell.textLabel.text = @"Privacy Policy";
            break;
        case 1:
            cell.textLabel.text = @"Terms Of Use";
            break;
        case 2:
            cell.textLabel.text = @"Log Out";
            [cell.imageView setImage:[UIImage imageNamed:@"logouticon"]];
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case 0:{
            DescreptionViewController *desc = [[DescreptionViewController alloc] initWithNibName:@"DescreptionViewController" bundle:nil];
            desc.stringURL = @"http://www.glimpnow.com/#!CopyofPrivacy/c1rrp";
            desc.title = @"Privacy Policy";

            [self.navigationController pushViewController:desc animated:YES];
            break;
        }
        case 1:{
            DescreptionViewController *desc = [[DescreptionViewController alloc] initWithNibName:@"DescreptionViewController" bundle:nil];
            desc.stringURL = @"http://www.glimpnow.com/#!CopyofTerms/c1x6q";
            desc.title = @"Terms";
            [self.navigationController pushViewController:desc animated:YES];
            break;
        }
        case 2:{
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
            StartingViewController *start = [[StartingViewController alloc]initWithNibName:@"StartingViewController" bundle:nil];
            [appDelegate.navg pushViewController:start animated:YES];

            break;
        }
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated
{

}

- (void)viewWillDisappear:(BOOL)animated
{
}
@end
