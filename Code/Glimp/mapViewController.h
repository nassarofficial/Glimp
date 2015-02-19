//
//  mapViewController.h
//  Glimp
//
//  Created by Ahmed Salah on 9/13/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Annotation.h"
#import "AudioButton.h"
#import "JNJProgressButton.h"
#import "CERoundProgressView.h"
#import "CEPlayer.h"
@interface mapViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate, CLLocationManagerDelegate,MKMapViewDelegate,CEPlayerDelegate>
@property (weak, nonatomic) IBOutlet JHStatusTextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *flashButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UILabel *noOfViews;
@property (weak, nonatomic) IBOutlet UILabel *noOfComments;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UILabel *locationPOILabel;
@property (strong, nonatomic) IBOutlet UIView *cameraLayout;
@property (weak, nonatomic) IBOutlet UIView *searchBarView;
@property (weak, nonatomic) IBOutlet UILabel *videoUserName;
@property (weak, nonatomic) IBOutlet UILabel *noOfLikesLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UITabBarItem *homeTab;
@property (weak, nonatomic) IBOutlet UITabBarItem *cameraTap;
@property (weak, nonatomic) IBOutlet UITabBarItem *notificationTap;
@property (weak, nonatomic) IBOutlet UITabBarItem *profileTab;
@property (weak, nonatomic) IBOutlet UISlider *sliderProgress;

@property (weak, nonatomic) IBOutlet UITabBarItem *globeTab;
@property (strong, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *videoThumbnailImage;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (nonatomic, strong) IBOutlet UIView *annotationView;
@property (nonatomic, strong) QTree* qTree;
@property (nonatomic, assign)BOOL getFriends;
@property (nonatomic, strong)UserModel *user;
@property (nonatomic, strong)CLLocationManager *location;
@property (nonatomic, strong)NSMutableArray *videosArr;
@property (nonatomic, assign)BOOL fromSearch;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (retain, nonatomic) CEPlayer *player;
@property (nonatomic, strong)NSArray *viewControllers;

- (IBAction)cancelPostingVideo:(id)sender;
- (IBAction)zoomOut:(id)sender;
- (IBAction)shareButton:(id)sender;
- (IBAction)postVideo:(id)sender;
- (IBAction)cameraButton:(id)sender;
- (IBAction)doneRecording:(id)sender;
- (IBAction)share:(id)sender;
- (IBAction)closeCameraView:(id)sender;
- (IBAction)flipCameraAction:(id)sender;
- (IBAction)flashAction:(id)sender;
- (IBAction)likeVideo:(id)sender;
- (void)setPinOnMap:(NSMutableArray *)videos;
- (IBAction)getUserLocation:(id)sender;
- (BOOL)startCameraControllerFromViewController:(UIViewController*)controller
                                 usingDelegate:(id )delegate;
- (IBAction)dismissAnnotationView:(id)sender;
@end


