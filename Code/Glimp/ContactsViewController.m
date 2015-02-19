//
//  ContactsViewController.m
//  Glimp
//
//  Created by Ahmed Salah on 9/13/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import "ContactsViewController.h"
#import "mapViewController.h"
#import "NSObject+SBJSON.h"
#import "AppDelegate.h"
#import "sideMenuTableViewController.h"
@interface ContactsViewController ()
{
    NSMutableArray *contactList,*contactsNo, *registeredUsers,*followedUsers;
    
}

@end

@implementation ContactsViewController

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
    contactsNo = [NSMutableArray new];
    registeredUsers = [NSMutableArray new];
    followedUsers = [NSMutableArray new];
    [self getContacts];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
  
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getContacts{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);

    __block BOOL accessGranted = NO;

    if (ABAddressBookRequestAccessWithCompletion != NULL) { // We are on iOS 6
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(semaphore);
            [self getContactsWithAddressBook:addressBook];
            [self getRegisterdNumbers];

        });

        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    }


}

-(void)getRegisterdNumbers{
    NSString *url = [NSString stringWithFormat:KHostURL,KGetUserRegisterd];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableDictionary *parameters =  [NSMutableDictionary new];
    [parameters setObject:contactsNo forKey:@"mobileNos"] ;
    NSLog(@"%@",[contactsNo JSONRepresentation]);
    [SVProgressHUD show];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SBJSON* parser = [[SBJSON alloc] init];
        NSString *response = [parser stringWithObject:responseObject];
        NSDictionary* myDict = [parser objectWithString:response error:nil];

        if ([[[myDict objectForKey:@"GetUserRegisteredFriendsResult"] objectForKey:@"ReturnedObject"] isKindOfClass:[NSArray class]]) {
            NSArray *arr = [[myDict objectForKey:@"GetUserRegisteredFriendsResult"] objectForKey:@"ReturnedObject"] ;
            for (NSDictionary *dic in arr) {
                UserModel * user = [[UserModel alloc]initWithData:dic];
                [registeredUsers addObject:user];
            }
        }else{
            NSDictionary *userDict = [[myDict objectForKey:@"GetUserRegisteredFriendsResult"] objectForKey:@"ReturnedObject"];
            UserModel * user = [[UserModel alloc]initWithData:userDict];
            [registeredUsers addObject:user];
        }
    
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self.tableView reloadData];
                       });
        NSLog(@"JSON: %@", responseObject);
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"error"];
    }];
}
- (void)getContactsWithAddressBook:(ABAddressBookRef )addressBook {

    contactList = [[NSMutableArray alloc] init];
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);

    for (int i=0;i < nPeople;i++) {
        NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];

        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);

        //For username and surname
        ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty));

        CFStringRef firstName, lastName;
        firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        if (!lastName) {
            [dOfPerson setObject:[NSString stringWithFormat:@"%@", firstName] forKey:@"name"];
        }else
            [dOfPerson setObject:[NSString stringWithFormat:@"%@ %@", firstName, lastName] forKey:@"name"];


        CFDataRef imageData = ABPersonCopyImageData(ref);
        UIImage *image = [UIImage imageWithData:(__bridge NSData *)imageData];
        if(image != nil)
            [dOfPerson setObject:image forKey:@"image"];
        //For Phone number
        NSString* mobileLabel;

        for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
            mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
            if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"Phone"];
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"Phone"];
                break ;
            }

        }
        if([dOfPerson objectForKey:@"Phone"])
            [contactsNo addObject:[dOfPerson objectForKey:@"Phone"]];

        [contactList addObject:dOfPerson];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return registeredUsers.count;
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
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UserModel *user = [registeredUsers objectAtIndex:indexPath.row];
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
- (void)followUsers:(NSIndexPath *)index follow:(UIButton *)btn {
    UserModel *friend = [registeredUsers objectAtIndex:index.row];
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

-(void) didTappedAddfriendButtonAtCell:(FreindsCell *)cell type:(UIButton *)button{
    [SVProgressHUD show];
  
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    
    [self followUsers:index follow:button];

}

- (IBAction)skipAction:(id)sender {
    UINavigationController *navg = [[UINavigationController alloc]init];
    mapViewController *map = [[mapViewController alloc]initWithNibName:@"mapViewController" bundle:nil];
    map.user = self.user;
    navg.viewControllers = [NSArray arrayWithObject:map];
    sideMenuTableViewController* leftController = [[sideMenuTableViewController alloc] initWithNibName:nil bundle:nil];
    [leftController view];
    IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:navg leftViewController:leftController rightViewController:nil];
    deckController.leftSize = 44.f;
    deckController.rightSize = 44.f;
    deckController.panningMode = IIViewDeckFullViewPanning;
    deckController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToCloseBouncing;
    deckController.openSlideAnimationDuration = .3f; // In seconds
    deckController.closeSlideAnimationDuration = .3f;
    deckController.bounceOpenSideDurationFactor = .5f;
 
    [self.navigationController pushViewController:deckController animated:YES];
}
@end
