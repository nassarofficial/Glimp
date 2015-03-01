//
//  mapViewController.m
//  Glimp
//
//  Created by Ahmed Salah on 9/13/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import "mapViewController.h"
#import "NSObject+SBJSON.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "EditProfileViewController2.h"
#import "CXAlertView.h"
#import "searchviewController.h"
#import "ProfileViewController.h"
#import "ClusterAnnotationView.h"
#import "UIButton+Pulsing.h"
#import "UIImage+DrawText.h"
#import "CommentsViewController.h"
#import "JPSThumbnailAnnotation.h"
#import "LeveyPopListView.h"
#import "DescreptionViewController.h"
#import "KxMenu.h"
#import "NotificationsViewController.h"
#import "AppDelegate.h"
@interface mapViewController ()<LeveyPopListViewDelegate,UIScrollViewDelegate>{
    JPSThumbnail *ann;
    MPMoviePlayerController *theMoviPlayer;
    NSString *videoUrl, *videoId,*videoImageUrl, *videoUser, *noOfViews, *noOfComments, *userID;
    int noOFlike,time, keyboardHeight;
    CGRect videoImageOriginalFrame;
    CXAlertView *alert;
    BOOL videoTaken;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    UIImagePickerController *videoRecorder;
    NSMutableArray *videoByteArray;
    NSMutableArray *imageByteArray, *venuesName;
    NSDictionary *mediaItemInfo;
    int seconds;
    NSTimer *timer;
    NSString *photo;
}
@property (weak, nonatomic) NSTimer *myTimer;
@property int currentTimeInSeconds;
@property (nonatomic, strong)UIImagePickerController *recorder;
@property (nonatomic, strong)NSString *videoComment;
@property (nonatomic, retain) UIViewController *selectedViewController;
@end

@implementation mapViewController
@synthesize location;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.user = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]];

        ProfileViewController *userProfile = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
        userProfile.userID = userID;
        userProfile.user   = self.user;
        NotificationsViewController *notifications = [[NotificationsViewController
                                                       alloc]initWithNibName:@"NotificationsViewController" bundle:nil];
        UINavigationController *navg = [[UINavigationController alloc]initWithRootViewController:userProfile];
        UINavigationController *notNavg = [[UINavigationController alloc]initWithRootViewController:notifications];
        // Custom initialization
        NSArray *array = [[NSArray alloc] initWithObjects:self, navg, notNavg, nil];
        self.viewControllers = array;

    }
    return self;
}

- (void)customizeTabBar {
    [self.homeTab setSelectedImage:[[UIImage imageNamed:@"bluehome"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
    [self.globeTab setSelectedImage:[[UIImage imageNamed:@"globe blue"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
    
    [self.profileTab setSelectedImage:[[UIImage imageNamed:@"Profilebuttonblue"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
    [self.notificationTap setSelectedImage:[[UIImage imageNamed:@"bluenotifbutton"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
    
    [self.homeTab setImage:[[UIImage imageNamed:@"whitehome"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
    [self.globeTab setImage:[[UIImage imageNamed:@"2"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
    
    [self.profileTab setImage:[[UIImage imageNamed:@"5"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
    [self.notificationTap setImage:[[UIImage imageNamed:@"whitenotifbutton"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
    
    [self.cameraTap setImage:[[UIImage imageNamed:@"3"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
    [self.tabBar setTintColor:[UIColor whiteColor]];
    [self.tabBar setBarTintColor:RGB(89, 89, 89)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tabBar.translucent = NO;
        self.tabBar.translucent = YES;
    });
    [self.searchBar resignFirstResponder];
}

- (void)addGestureRecognizers {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(doSingleTap)] ;
    singleTap.numberOfTapsRequired = 1;
    [self.videoImage addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *userTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(goToUSerProfile)] ;
    singleTap.numberOfTapsRequired = 1;
    [self.videoUserName addGestureRecognizer:userTap];
    
    UITapGestureRecognizer *singleTapForPlaces = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(showPlaces)] ;
    singleTapForPlaces.numberOfTapsRequired = 1;
    [self.addressLabel addGestureRecognizer:singleTapForPlaces];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(doDoubleTap)];
    doubleTap.numberOfTapsRequired = 2;
    [self.videoImage addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];

    UITapGestureRecognizer *singleTapForMap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(showSearch)] ;
    singleTapForMap.numberOfTapsRequired = 1;
    [self.mapView addGestureRecognizer:singleTapForMap];
}
-(void)showSearch{
    if (self.tabBar.selectedItem == self.globeTab) {
        self.searchBarView.hidden = NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.navg.navigationBarHidden = NO;
    self.navigationController.navigationBarHidden = NO;
    [self.sliderProgress setThumbImage:[UIImage imageNamed:@"seekicon"] forState:UIControlStateNormal];
    self.tabBar.selectedItem = self.homeTab;
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.translucent = NO;
    self.player = [[CEPlayer alloc] init];
    self.player.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    

   // [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
   //                                                                  RGB(255, 255, 255),
   //                                                                  NSForegroundColorAttributeName,
//[UIFont fontWithName:@"Arial-Bold" size:20.0],
    //                                                                 NSFontAttributeName,
    //                                                                 nil]];
    [self.navigationController.navigationBar setBarTintColor: [UIColor colorWithRed:0.0f/255.0f green:220.0f/255.0f blue:251.0f/255.0f alpha:1.0f]];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"glimplogonav.png"]];

    
    //self.title = @"GLIMP";
    geocoder = [[CLGeocoder alloc] init];
    [self.mapView setDelegate:self];
    [self getAddresOnMap];
 
    if (!self.fromSearch) {
        [self getFriednsGlimps:nil];
        self.videosArr = [NSMutableArray new];

    }
    [self getVeneus];
    videoImageOriginalFrame = self.videoImage.frame;
    [self addGestureRecognizers];
    // Do any additional setup after loading the view from its nib.
}
- (void)goToUSerProfile{
    ProfileViewController *userProfile = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    userProfile.userID = userID;
    userProfile.user   = self.user;

    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:userProfile animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    if (self.fromSearch) {
        [self removeAnnotations];
        [self setPinOnMap:self.videosArr];
    }
    [self customizeTabBar];
    if (!self.annotationView.hidden) {
        self.navigationController.navigationBarHidden = YES;

    }

}
- (void)viewDidAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];

}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self hideKeyboardForComment];
}
- (void)gotoSearch{
    SearchViewController *search = [[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:search];
    search.map = self;
    search.user = self.user;
    navigationController.navigationBar.hidden = YES;
    [self.navigationController presentViewController:navigationController animated:NO completion:^{
        
    }];
}
- (void)getvideos{
    [SVProgressHUD showWithStatus:@"Getting all Glimps..."];
    [Flurry logEvent:@"Get all Videos"];
    NSMutableDictionary *parameters =  [NSMutableDictionary new];
//    [parameters setObject:self.user.userId forKey:@"currentUserID"];
    [self.videosArr removeAllObjects];
    NSString *url = [NSString stringWithFormat:KHostURL,KGetAllVideos];
    [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        VideoModel * video;
        SBJSON* parser = [[SBJSON alloc] init];
        NSString *response = [parser stringWithObject:responseObject];
        NSDictionary* myDict = [parser objectWithString:response error:nil];
        
        if ([[[myDict  objectForKey:@"AllVideosResult"] objectForKey:@"ReturnedObject"] isKindOfClass:[NSMutableArray class]]) {
            NSArray *arr = [[myDict  objectForKey:@"AllVideosResult"] objectForKey:@"ReturnedObject"] ;
            for (NSDictionary *dic in arr) {
               video = [[VideoModel alloc]initWithData:dic];
                [self.videosArr addObject:video];
            }
        }else{
            NSDictionary *userDict = [[myDict  objectForKey:@"AllVideosResult"] objectForKey:@"ReturnedObject"];
            video = [[VideoModel alloc]initWithData:userDict];
            [self.videosArr addObject:video];

        }
        [self setPinOnMap:self.videosArr];

        [SVProgressHUD dismiss];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"Error Getting Glimps"];
    }];
}

- (BOOL)startCameraControllerFromViewController:(UIViewController*)controller usingDelegate:(id )delegate{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        videoRecorder = [[UIImagePickerController alloc]init];
        NSArray *sourceTypes = [UIImagePickerController availableMediaTypesForSourceType:videoRecorder.sourceType];
        if (![sourceTypes containsObject:(NSString*)kUTTypeMovie] ) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Device Not Supported for video Recording."                                                                       delegate:self
                                                  cancelButtonTitle:@"Yes"
                                                  otherButtonTitles:@"No",nil];
            [alertView show];
        }

        videoRecorder.sourceType = UIImagePickerControllerSourceTypeCamera;
        videoRecorder.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeMovie];
        videoRecorder.videoQuality = UIImagePickerControllerQualityTypeMedium;
        videoRecorder.videoMaximumDuration = VIDEODURATION;
        videoRecorder.showsCameraControls = NO;
        self.cameraLayout.frame = videoRecorder.cameraOverlayView.frame;
        videoRecorder.cameraOverlayView = self.cameraLayout;
        videoRecorder.delegate = self;
        self.recorder = videoRecorder;
        [self presentViewController:self.recorder animated:YES  completion:nil];
    }
    return YES;
}

- (void)setPinOnMap:(NSMutableArray *)videos {
    self.qTree = [QTree new];

    for (VideoModel *video in videos) {
        CLLocationCoordinate2D coordinate ;
        coordinate.longitude =  video.longitude ;
        coordinate.latitude = video.latitude;
        
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: video.videoUserImage]];
                JPSThumbnail *videoAnn = [[JPSThumbnail alloc] init];
        if (data != nil) {
            videoAnn.image = [UIImage imageWithData:data];
        }else{
            videoAnn.image = [UIImage imageNamed:@"glimp icon"];
        }
        videoAnn.coordinate            = coordinate;
        videoAnn.videoUrl              = video.videoUrl;
        videoAnn.userName              = video.userName;
        videoAnn.videoID               = video.videoID;
        videoAnn.videoComment          = video.comment;
        videoAnn.videoImage            = video.videoImage;
        videoAnn.isLiked               = video.isLiked;
        videoAnn.noOflikes             = video.noOflikes;
        noOFlike                       = video.noOflikes;
        videoAnn.noOfViews             =video.noOfViews;
        videoAnn.noOfComments          =video.noOfComments;
        videoAnn.videoLocation         =video.videoLocation;
        videoAnn.videoTime             =video.uploadedTime;
        videoAnn.userID                =video.userID;
        [self.qTree insertObject:[JPSThumbnailAnnotation annotationWithThumbnail:videoAnn]];
        

    }
    [self reloadAnnotations];
}

- (void)reloadAnnotations {
    if( !self.isViewLoaded ) {
        return;
    }
    
    const MKCoordinateRegion mapRegion = self.mapView.region;
    const CLLocationDegrees minNonClusteredSpan =  MIN(mapRegion.span.latitudeDelta, mapRegion.span.longitudeDelta) /20;
    NSArray* objects = [self.qTree getObjectsInRegion:mapRegion minNonClusteredSpan:minNonClusteredSpan];
    
    NSMutableArray* annotationsToRemove = [self.mapView.annotations mutableCopy];
    [annotationsToRemove removeObject:self.mapView.userLocation];
    [annotationsToRemove removeObjectsInArray:objects];
    [self.mapView removeAnnotations:annotationsToRemove];
    
    NSMutableArray* annotationsToAdd = [objects mutableCopy];
    [annotationsToAdd removeObjectsInArray:self.mapView.annotations];
    
    [self.mapView addAnnotations:annotationsToAdd];
}
- (void)sendVideo:(NSMutableArray *)byteArray withThumbnailImage: (NSMutableArray *)imageByteArr {
    [Flurry logEvent:@"Make a video"];
    [SVProgressHUD showWithStatus:@"Uploading Video..." maskType:SVProgressHUDMaskTypeClear];
    [self getLocation];
    NSString *url = [NSString stringWithFormat:KHostURL,KSaveVideos];
    NSMutableDictionary *parameters =  [NSMutableDictionary new];
    [parameters setObject:self.user.userId forKey:@"userID"];
    [parameters setObject:self.addressLabel.text forKey:@"location"];
    [parameters setObject:byteArray forKey:@"video"];
    [parameters setObject:_videoComment?_videoComment:@"" forKey:@"comment"];
    [parameters setObject:imageByteArr forKey:@"videoImage"];
    [parameters setObject:[NSNumber numberWithDouble:self.location.location.coordinate.longitude] forKey:@"longitute"];
    [parameters setObject:[NSNumber numberWithDouble:self.location.location.coordinate.latitude ]forKey:@"latitude"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [NSURLSessionConfiguration defaultSessionConfiguration];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SBJSON* parser = [[SBJSON alloc] init];
        NSString *response = [parser stringWithObject:responseObject];
        NSDictionary* myDict = [parser objectWithString:response error:nil];
        NSDictionary *userDict = [[myDict objectForKey:@"SaveVideoResult"] objectForKey:@"ReturnedObject"];
        if (![userDict isKindOfClass:[NSNull class]] ) {
            VideoModel * video = [[VideoModel alloc]initWithData:userDict];
            [self.videosArr addObject:video];
            [self setPinOnMap:self.videosArr];
        }
       
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"Error while uploading"];
    }];
    if (videoByteArray.count > 0){
        [videoByteArray removeAllObjects];
    }
}
- (void)makeMediaITemsByteArray {
    
    videoByteArray = [NSMutableArray array];
    imageByteArray = [NSMutableArray array];
    NSURL *videoURL = [mediaItemInfo objectForKey:UIImagePickerControllerMediaURL];
    UIImage *image = [self generateThumbImagewithURL:videoURL];
    NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
    const unsigned char *bytes = [videoData bytes];
    NSUInteger length = [videoData length];
    for (NSUInteger i = 0; i < length; i++) {
        [videoByteArray addObject:[NSNumber numberWithUnsignedChar:bytes[i]]];
    }
    NSData *imageData = UIImageJPEGRepresentation(image, 0.0);;
    
    const unsigned char *imagebytes = [imageData bytes];
    NSUInteger imageLength = [imageData length];
    
    for (NSUInteger i = 0; i < imageLength; i++) {
        [imageByteArray addObject:[NSNumber numberWithUnsignedChar:imagebytes[i]]];
    }
    [self.videoThumbnailImage setImage:image];
    

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if (([type isEqualToString:(NSString *)kUTTypeVideo] ||
        [type isEqualToString:(NSString *)kUTTypeMovie])&& videoTaken) {
        // movie != video
        mediaItemInfo = info;
    }
}
- (void)hideKeyboard:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
    [self.commentView endEditing:YES];
}

- (void)doSingleTap{
    [self videoSeen];
    [self playAvideoWithFrame:videoImageOriginalFrame];

}
- (void)videoSeen{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:KHostURL,KVideoSeen];
    NSMutableDictionary *parameters =  [NSMutableDictionary new];
    [parameters setObject:self.user.userId forKey:@"userId"];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * videoIdNo = [f numberFromString:videoId];
    [parameters setObject:videoIdNo forKey:@"videoId"];
    [NSURLSessionConfiguration defaultSessionConfiguration];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        SBJSON* parser = [[SBJSON alloc] init];
        NSString *response = [parser stringWithObject:responseObject];
        NSDictionary* myDict = [parser objectWithString:response error:nil];
        NSString *seenNo = [[myDict objectForKey:@"VideoSeenByUserResult"] stringValue];
        self.noOfViews.text = seenNo;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"error"];
    }];
}
- (void)doDoubleTap{
    [self videoSeen];
    [self playAvideoWithFrame:[[UIScreen mainScreen] bounds]];

}
- (void)playAvideoWithFrame:(CGRect)frame{
    NSURL *urlString=[NSURL URLWithString:videoUrl];
    theMoviPlayer = [[MPMoviePlayerController alloc] initWithContentURL:urlString];
    [theMoviPlayer prepareToPlay];
    theMoviPlayer.scalingMode = MPMovieScalingModeAspectFill;
    theMoviPlayer.view.frame = frame;
    theMoviPlayer.movieSourceType = MPMovieSourceTypeStreaming;
    if (CGRectEqualToRect(frame, videoImageOriginalFrame)) {
        frame.origin = CGPointZero;
        theMoviPlayer.view.frame = frame;
        [self.videoImage addSubview:theMoviPlayer.view];
    }else{
        if (theMoviPlayer.view != nil) {
            [theMoviPlayer stop];
            [theMoviPlayer.view removeFromSuperview];
        }
        [self showInFullScreen];
     
    }
}
- (void)resetTimer{
    if (_myTimer) {
        [_myTimer invalidate];
//        _myTimer = [self createTimer];
    }
    
    _currentTimeInSeconds = 0;

}
- (void)showInFullScreen{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitedFullscreen:) name:MPMoviePlayerDidExitFullscreenNotification object:nil];

    [theMoviPlayer setFullscreen:YES animated:YES];
    theMoviPlayer.view.frame = self.view.frame;
    [self.view addSubview:theMoviPlayer.view];
    [theMoviPlayer setFullscreen:YES animated:YES];

}
- (void)removeAnnotations {
    id userLocation = [self.mapView userLocation];
    [self.mapView removeAnnotations:[self.mapView annotations]];
    
    if ( userLocation != nil ) {
        [self.mapView addAnnotation:userLocation]; // will cause user location pin to blink
    }
}

- (void)getLocation {
    self.location=[[CLLocationManager alloc]init];
    if ([self.location respondsToSelector:@selector(requestWhenInUseAuthorization)])
        [self.location requestWhenInUseAuthorization];
    
    self.location.delegate=self;
    self.location.desiredAccuracy=kCLLocationAccuracyHundredMeters;
    self.location.distanceFilter=kCLDistanceFilterNone;
    if ([self shouldFetchUserLocation]) {
        [self.location startUpdatingLocation];

    }
}
- (BOOL)shouldFetchUserLocation{
    
    BOOL shouldFetchLocation= NO;
    
    if ([CLLocationManager locationServicesEnabled]) {
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusAuthorizedAlways:
                shouldFetchLocation= YES;
                break;
            case kCLAuthorizationStatusDenied:
            {
                UIAlertView *alertv= [[UIAlertView alloc]initWithTitle:@"Error" message:@"App level settings has been denied" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertv show];
                alertv= nil;
            }
                break;
            case kCLAuthorizationStatusNotDetermined:
            {
                UIAlertView *alertv= [[UIAlertView alloc]initWithTitle:@"Error" message:@"The user is yet to provide the location permission" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertv show];
                alertv= nil;
            }
                break;
            case kCLAuthorizationStatusRestricted:
            {
                UIAlertView *alertv= [[UIAlertView alloc]initWithTitle:@"Error" message:@"The app is recstricted from using location services." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertv show];
                alertv= nil;
            }
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                shouldFetchLocation= YES;
                break;
            default:
                break;
        }
    }
    else{
        UIAlertView *alertv= [[UIAlertView alloc]initWithTitle:@"Error" message:@"The location services seems to be disabled from the settings." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertv show];
        alertv= nil;
    }
    
    return shouldFetchLocation;
}
- (void)getAddresOnMap{
    [self getLocation];
    [self setupMapForLocatoion];
}
- (void)setupMapForLocatoion{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    region.span = span;
    region.center = self.location.location.coordinate;
    [self.mapView setRegion:region animated:YES];

}
- (void)mapView:(MKMapView *)aMapView regionDidChangeAnimated:(BOOL)animated{
    [self reloadAnnotations];

}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    if (annotation == mapView.userLocation)
        return nil;
    if( [annotation isKindOfClass:[QCluster class]] ) {
        ClusterAnnotationView* annotationView = (ClusterAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:[ClusterAnnotationView reuseId]];
        if( !annotationView ) {
            annotationView = [[ClusterAnnotationView alloc] initWithCluster:(QCluster*)annotation];
        }
        annotationView.cluster = (QCluster*)annotation;
        return annotationView;
    }
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
            return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
        }
    return  nil;
        
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    [mapView deselectAnnotation:view.annotation animated:YES];
    id<MKAnnotation> annotation = view.annotation;
    if( [annotation isKindOfClass:[QCluster class]] ) {
        QCluster* cluster = (QCluster*)annotation;
        [mapView setRegion:MKCoordinateRegionMake(cluster.coordinate, MKCoordinateSpanMake(2.5 * cluster.radius, 2.5 * cluster.radius))
                  animated:YES];
    } else if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        JPSThumbnailAnnotation *videoAnn        = (JPSThumbnailAnnotation*)annotation;
        videoUrl                                = videoAnn.videoUrl?videoAnn.videoUrl:@"";
        _videoComment                           = videoAnn.videoComment? videoAnn.videoComment:@"";
        videoUser                               = videoAnn.userName?videoAnn.userName:@"";
        videoId                                 = videoAnn.videoID?videoAnn.videoID:@"";
        videoImageUrl                           = videoAnn.videoImage?videoAnn.videoImage:@"";
        noOfComments                            = [NSString stringWithFormat:@"%i",videoAnn.noOfComments];
        noOfViews                               = [NSString stringWithFormat:@"%i",videoAnn.noOfViews];
        userID                                  = videoAnn.userID;
        self.likeButton.selected                = videoAnn.isLiked;
        self.noOfLikesLabel.text                = [NSString stringWithFormat:@"%i",videoAnn.noOflikes];
        self.locationPOILabel.text              = videoAnn.videoLocation;
        self.videoTimeLabel.text                = videoAnn.videoTime;
        [self showPOIActionsWindow];

    }

}
- (void)closePOIActionsWindow{

    [UIView animateWithDuration:.5f delay:0.f options:UIViewAnimationOptionCurveEaseInOut|!UIViewAnimationOptionAllowUserInteraction animations:^{
        [self.annotationView setAlpha:0];

    } completion:^(BOOL finished) {
        [theMoviPlayer stop];
        [theMoviPlayer.view removeFromSuperview];
        self.videoImage.frame = videoImageOriginalFrame;
    }];
}
- (void)showPOIActionsWindow{
    self.videoUserName.text = videoUser;
    self.commentLabel.text = _videoComment;
    self.noOfComments.text = noOfComments;
    self.noOfViews.text = noOfViews;
    self.videoImage.contentMode = UIViewContentModeCenter;
    [self.videoImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:videoImageUrl]] placeholderImage:[UIImage imageNamed:@"play"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.videoImage.contentMode = UIViewContentModeScaleToFill;
        self.videoImage.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        self.videoImage.contentMode = UIViewContentModeCenter;
    }];
    [self.annotationView setHidden:NO];

    [self.navigationController.view bringSubviewToFront:self.annotationView];
    [UIView animateWithDuration:.6f delay:0.f options:UIViewAnimationOptionCurveEaseInOut|!UIViewAnimationOptionAllowUserInteraction animations:^{
        [self.annotationView setAlpha:1];
        self.navigationController.navigationBarHidden = YES;

    } completion:^(BOOL finished) {

    }];
}
- (void)tap:(UITapGestureRecognizer *)gesture {
    [UIView animateWithDuration:.5f delay:0.f options:UIViewAnimationOptionCurveEaseInOut|!UIViewAnimationOptionAllowUserInteraction animations:^{
        [theMoviPlayer.view  setAlpha:0];
        
    } completion:^(BOOL finished) {
        [theMoviPlayer stop];
        [theMoviPlayer.view removeFromSuperview];
    }];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.location = [locations lastObject];
    CLLocation *newLocation = [locations lastObject];

    // Reverse Geocoding
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            dispatch_async(dispatch_get_main_queue(),^{
                self.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",
                                           placemark.thoroughfare,
                                           placemark.locality,
                                          placemark.administrativeArea,
                                          placemark.country];
            });

       
        } else {
        }
    } ];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"%@",error.userInfo);
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertView    *alertPermission = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                               message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [alertPermission show];
        }
    }
}
- (void)exitedFullscreen:(NSNotification*)notification {
    [UIView animateWithDuration:2.0f delay:0.f options:UIViewAnimationOptionCurveEaseInOut|!UIViewAnimationOptionAllowUserInteraction animations:^{
        [theMoviPlayer.view setAlpha:0];
        
    } completion:^(BOOL finished) {
        [theMoviPlayer.view removeFromSuperview];
        theMoviPlayer = nil;
        
    }];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)playbackFinished:(NSNotification*)notification {
    [UIView animateWithDuration:0.6f delay:0.f options:UIViewAnimationOptionCurveEaseInOut|!UIViewAnimationOptionAllowUserInteraction animations:^{
        [theMoviPlayer.view setAlpha:0];

    } completion:^(BOOL finished) {
        [theMoviPlayer setFullscreen:NO animated:YES];

        }];
}
- (UIImage *)generateThumbImagewithURL:(NSURL *)urlVideo{

    AVURLAsset *asset1 = [[AVURLAsset alloc] initWithURL:urlVideo options:nil];
    AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
    generate1.appliesPreferredTrackTransform = YES;
    NSError *err = NULL;
    CMTime timeX = CMTimeMake(1, 2);
    CGImageRef oneRef = [generate1 copyCGImageAtTime:timeX actualTime:NULL error:&err];
    UIImage *thumbnail = [[UIImage alloc] initWithCGImage:oneRef];
    
    return thumbnail;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    textView.text  = nil;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    CGRect rect =  alert.frame;
    rect.origin.y = alert.frame.origin.y -80;
    [alert setFrame:rect];
    [UIView commitAnimations];
    textView.textColor = [UIColor blackColor];
    return YES;

}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    CGRect rect =  alert.frame;
    rect.origin.y = alert.frame.origin.y +80;
    [alert setFrame:rect];
    [UIView commitAnimations];
    return YES;
}
- (void)didReceiveMemoryWarning {
    if ([self isViewLoaded] && [self.view window] == nil) {
        self.view = nil;
        self.annotationView = nil;
    }
    self.videoComment = nil;
    self.videoImage = nil;
    self.videoUserName = nil;
    self.videoThumbnailImage = nil;
    videoId = nil;
    videoImageUrl = nil;
    videoUrl = nil;
    [super didReceiveMemoryWarning];
}

- (IBAction)getAllGlimps:(id)sender {
    [self removeAnnotations];
    [self getvideos];
}
- (IBAction)likeVideo:(id)sender{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected ;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:KHostURL,KlikeUnlike];
    NSMutableDictionary *parameters =  [NSMutableDictionary new];
    
    [parameters setObject:self.user.userId forKey:@"userId"];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * videoIdNo = [f numberFromString:videoId];
    [parameters setObject:videoIdNo forKey:@"videoId"];
    [parameters setObject:self.user.firstName forKey:@"userFirstName"];
    [parameters setObject:self.user.lastName forKey:@"userLastName"];
    
    [NSURLSessionConfiguration defaultSessionConfiguration];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        SBJSON* parser = [[SBJSON alloc] init];
        NSString *response = [parser stringWithObject:responseObject];
        NSDictionary* myDict = [parser objectWithString:response error:nil];
        NSString *likesNo = [[[myDict objectForKey:@"LikeUnLikeVideoResult"] objectForKey:@"ReturnedObject"] stringValue];
        self.noOfLikesLabel.text = likesNo;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"error"];
    }];
}
- (IBAction)goToComments:(id)sender {
    
    CommentsViewController *comment = [[CommentsViewController alloc]initWithNibName:@"CommentsViewController" bundle:nil];
    comment.videoID = videoId;
    [self.navigationController pushViewController:comment animated:YES];
}
- (IBAction)cancelPostingVideo:(id)sender {
    [self.commentView setHidden:YES];
}
- (IBAction)zoomOut:(id)sender {
    MKCoordinateRegion region = self.mapView.region;
    MKCoordinateSpan span = self.mapView.region.span;
    span.latitudeDelta = span.latitudeDelta * 8;
    span.longitudeDelta = span.longitudeDelta * 8;
    region.span=span;
    if (span.latitudeDelta < 90 && span.latitudeDelta > -90 && span.longitudeDelta < 90 && span.longitudeDelta > -90) {
        [self.mapView setRegion:region animated:YES];

    }
}
- (IBAction)shareButton:(id)sender {
    NSArray *activityItems = [[NSArray alloc] initWithObjects:videoUrl, _videoComment, nil];
    UIActivityViewController *activityController =
    [[UIActivityViewController alloc]
     initWithActivityItems:activityItems
     applicationActivities:nil];
    activityController.excludedActivityTypes = [[NSArray alloc] initWithObjects:
                                                UIActivityTypeCopyToPasteboard,
                                                UIActivityTypePostToWeibo,
                                                UIActivityTypeSaveToCameraRoll,
                                                UIActivityTypeCopyToPasteboard,
                                                UIActivityTypeMessage,
                                                UIActivityTypeAssignToContact,
                                                UIActivityTypePrint,
                                                nil];
    
    [self presentViewController:activityController
                       animated:YES completion:nil];
}
- (IBAction)postVideo:(id)sender {
    [self.recorder dismissViewControllerAnimated:YES completion:^{
        
    }];
    videoTaken = NO;
    [self.commentView setHidden:YES];
    [self sendVideo:videoByteArray withThumbnailImage:imageByteArray];
}
- (IBAction)cameraButton:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.selected) {
        [videoRecorder stopVideoCapture];
        [self.player pause];
        [self.doneButton setEnabled:YES];
        btn.selected =NO;
    }else{
        videoTaken = YES;
        self.sliderProgress.value = 0;
        btn.selected = YES;
        [self.player play];
        [self.doneButton setEnabled:NO];
        [videoRecorder startVideoCapture];

    }
    

}
- (IBAction)doneRecording:(id)sender {
    [self makeMediaITemsByteArray];
    if (videoByteArray.count != 0 && videoTaken) {
        [self.commentView setHidden:NO];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNotificationMethod:) name:UIKeyboardWillShowNotification object:nil];
        
        UITapGestureRecognizer *tapComment =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboardForComment)];
        tapComment.numberOfTapsRequired = 1;
        [self.commentView  addGestureRecognizer:tapComment];
        self.sliderProgress.value = 0.0;
        self.videoComment = @"";
        [self.commentTextView setupView];


    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please Record video First" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }

}
- (IBAction)flipCameraAction:(id)sender {
    UIButton *button  = (UIButton *)sender;
    button.selected = !button.selected;
    if (button.selected)
        videoRecorder.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    else
        videoRecorder.cameraDevice = UIImagePickerControllerCameraDeviceRear;
}
- (IBAction)flashAction:(id)sender {
    UIButton *btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self enableFlash];
    }else
        [self disableFlash];
    
}
- (IBAction)closeCameraView:(id)sender {
    
    [videoRecorder dismissViewControllerAnimated:YES completion:nil];
    if (videoByteArray.count > 0){
        [videoByteArray removeAllObjects];
    }
    [self.playPauseButton setSelected:YES];
    self.sliderProgress.value = 0;
    videoTaken = NO;
    [self cameraButton:self.playPauseButton];
    
}
- (IBAction)getFriednsGlimps:(id)sender {
    [Flurry logEvent:@"Get Friends Videos"];
    [self removeAnnotations];
    NSMutableArray *arrayOfVideos = [NSMutableArray new];
    NSMutableDictionary *parameters =  [NSMutableDictionary new];
    [parameters setObject:[self.user.userId stringValue]   forKey:@"userId"];
    NSString *url = [NSString stringWithFormat:KHostURL,KGetUserFriendsVideos];
    [SVProgressHUD showWithStatus:@"Getting friends Glimps..."];
    [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        VideoModel * video;
        SBJSON* parser = [[SBJSON alloc] init];
        NSString *response = [parser stringWithObject:responseObject];
        NSDictionary* myDict = [parser objectWithString:response error:nil];
        if ([[[myDict objectForKey:@"GetUserFriendsVideosResult"] objectForKey:@"ReturnedObject"] isKindOfClass:[NSArray class]]) {
            NSArray *arr = [[myDict objectForKey:@"GetUserFriendsVideosResult"] objectForKey:@"ReturnedObject"] ;
            for (NSDictionary *dic in arr) {
                video = [[VideoModel alloc]initWithData:dic];
                [arrayOfVideos addObject:video];
            }
        }else{
            NSDictionary *userDict = [[myDict objectForKey:@"GetUserFriendsVideosResult"] objectForKey:@"ReturnedObject"];
            video = [[VideoModel alloc]initWithData:userDict];
            [arrayOfVideos addObject:video];
        }
        [self setPinOnMap:arrayOfVideos];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"Error Getting Glimps"];
    }];
}
- (IBAction)getUserLocation:(id)sender {
    [self getAddresOnMap];
    [self getVeneus];
}
- (IBAction)recordVideo:(id)sender {
    [self startCameraControllerFromViewController:self usingDelegate:self];
    
}
- (IBAction)dismissAnnotationView:(id)sender {
    [self closePOIActionsWindow];
    if(self.tabBar.selectedItem != self.globeTab){
        self.navigationController.navigationBarHidden = NO;
        
    }
}

- (void)keyboardWillHide{
    int height = self.scrollView.frame.size.height-keyboardHeight;
    CGSize size = CGSizeMake(self.scrollView.frame.size.width, height);
    [self.scrollView setContentSize:size];
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}
- (void)hideKeyboardForComment{
    [self.commentView endEditing:YES];
    int height = self.scrollView.frame.size.height-keyboardHeight;
    CGSize size = CGSizeMake(self.scrollView.frame.size.width, height);
    [self.scrollView setContentSize:size];
    [self.scrollView setContentOffset:CGPointZero animated:YES];


}
- (void)myNotificationMethod:(NSNotification*)notification{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    keyboardHeight = keyboardFrameBeginRect.size.height;
    int height = keyboardHeight + self.scrollView.frame.size.height;
    CGSize size = CGSizeMake(self.scrollView.frame.size.width, height);
    [self.scrollView setContentSize:size];
    CGPoint point = CGPointMake(0, keyboardHeight);
    [self.scrollView setContentOffset:point animated:YES];
    [self.scrollView setScrollEnabled:YES];
}
- (void)disableFlash{
    videoRecorder.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    [self.flashButton setImage:[UIImage imageNamed:@"flashicon"] forState:UIControlStateNormal];
    [self.flashButton setTitle:nil forState:UIControlStateNormal];

}
- (void)enableFlash{
    videoRecorder.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
        [self.flashButton setImage:[UIImage imageNamed:@"flash-selected"] forState:UIControlStateSelected];
        [self.flashButton setTitle:nil forState:UIControlStateNormal];

    
}
- (void) player:(CEPlayer *)player didReachPosition:(float)position {
    self.sliderProgress.value = position;
    
}
- (void) playerDidStop:(CEPlayer *)player {
    self.playPauseButton.selected = NO;
    [self.doneButton setEnabled:YES];
    self.sliderProgress.value = 0.0;
}
- (NSTimer *)createTimer {
    return [NSTimer scheduledTimerWithTimeInterval:1.0
                                            target:self
                                          selector:@selector(timerTicked:)
                                          userInfo:nil
                                           repeats:YES];
}
- (void)timerTicked:(NSTimer *)timer {
    
    _currentTimeInSeconds++;
    
    
}
- (NSString *)formattedTime:(int)totalSeconds{
    
    seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    if (totalSeconds>11) {
        [self cameraButton:nil];
        [self.doneButton  setEnabled:YES];
    }
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}
- (void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
}
- (void)getVeneus{

    venuesName = [NSMutableArray new];
    NSString *stringURL = [NSString stringWithFormat: @"https://api.foursquare.com/v2/venues/search?ll=%f,%f&client_id=DPUDNKBQKC12FJ0KBRLVU5BG4JREZV1YAIVRXIULPLFZHMAL&client_secret=PA0I5FS3JWPDMOL0H5XLQNDJYBJPGNOEP4QX1ML23YOFGZ3G&v=20140806",self.location.location.coordinate.latitude,self.location.location.coordinate.longitude];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:stringURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        SBJSON* parser = [[SBJSON alloc] init];
        NSString *response = [parser stringWithObject:responseObject];
        NSDictionary* myDict = [parser objectWithString:response error:nil];
        NSArray *venues = [[myDict objectForKey:@"response"] objectForKey:@"venues"] ;
        for (int i =0; i<venues.count; i++) {

           [venuesName addObject:[[venues objectAtIndex:i]  objectForKey:@"name"]];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);

    }];
}
- (void)showPlaces{\
    if (venuesName.count != 0) {
        LeveyPopListView *lplv = [[LeveyPopListView alloc] initWithTitle:@"Select your Place " options:venuesName];
        lplv.delegate = self;
        [lplv showInView:self.cameraLayout animated:YES];
    }else
        [SVProgressHUD showErrorWithStatus:@"There is no nearby places"];
}
- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex{
    self.addressLabel.text = [venuesName objectAtIndex:anIndex];

}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    UIViewController *newViewController;
    switch (item.tag) {
       
        case 0:
            [self getFriednsGlimps:nil];
            if (self.selectedViewController != nil) {
                [self.selectedViewController.view removeFromSuperview];
            }
            [self.containerView setHidden:YES];
            [self.searchBarView setHidden:YES];
            self.navigationController.navigationBarHidden = NO;
            break;
        case 1:
            [self getAllGlimps:nil];
            if (self.selectedViewController != nil) {
                [self.selectedViewController.view removeFromSuperview];
            }
            self.navigationController.navigationBarHidden = YES;
            [self.searchBarView setHidden:NO];
            [self.containerView setHidden:YES];
            break;
        case 2:
            [self recordVideo:nil];
            break;
        case 3:
            if (self.selectedViewController != nil) {
                [self.selectedViewController.view removeFromSuperview];
            }
            newViewController = [self.viewControllers objectAtIndex:2];
            [self.containerView addSubview:newViewController.view];
            [self.containerView setHidden:NO];
            self.selectedViewController = newViewController;
            self.navigationController.navigationBarHidden = YES;
            [self.searchBarView setHidden:YES];
            break;
        case 4:
            if (self.selectedViewController != nil) {
                [self.selectedViewController.view removeFromSuperview];
            }
            newViewController = [self.viewControllers objectAtIndex:1];
            [self.containerView addSubview:newViewController.view];
            [self.containerView setHidden:NO];
            self.selectedViewController = newViewController;
            self.navigationController.navigationBarHidden = YES;
            [self.searchBarView setHidden:YES];
            break;
        default:
            break;
    }
}
- (void)statusTextView:(JHStatusTextView *)textView postedMessage:(NSString *)message {
    self.videoComment = message;
    
}
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    self.searchBarView.hidden = YES;
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self gotoSearch];
    return YES;
}
@end


