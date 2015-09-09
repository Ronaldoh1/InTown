//
//  FeedTVC.m
//  InTown
//
//  Created by Ronald Hernandez on 9/4/15.
//  Copyright (c) 2015 inTown. All rights reserved.
//

#import "FeedTVC.h"
#import "User.h"
#import "MRProgressOverlayView.h"
#import "MRProgress.h"
#import "Post.h"
#import "PostCustomCell.h"
#import "AppDelegate.h"
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Alert.h"
#import "GIBadgeView.h"
#import "BBBadgeBarButtonItem.h"
#import "UIBarButtonItem+Badge.h"

@interface FeedTVC ()<CLLocationManagerDelegate>
@property UIImage *tempImage;
@property User *currentUser;
@property UIWindow *window;
@property NSMutableArray *postsArray;
@property CLLocation *currentLocation;
@property CLLocationManager *locationManager;
@property CLLocation *initialLocation;
@property PFGeoPoint *currentGeoPoint;
@property NSString *currentCity;
@property (weak, nonatomic) IBOutlet UITextView *postTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *messageButton;


@end

@implementation FeedTVC

- (void)viewDidLoad {
    [super viewDidLoad];
     [self getUserCurrentLocation];
    [self setUpProfileImage];
    [self performInitialSetup];
    [self checkForNewMessages];
}


-(void)viewDidAppear:(BOOL)animated{

    [super viewWillAppear:YES];

    if ([User currentUser] != nil) {


        [self setUpProfileImage];
        
    }
      [self checkForNewMessages];

}




//helper method for initial set up

-(void)performInitialSetup{


    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

    //Get Current User
    self.currentUser = [User currentUser];

  //  self.currentLocation = [CLLocation new];



    [self setUpProfileImage];

    //set up the textView
    self.postTextView.text = @"In Town? Let others know what you're up to!";
    self.postTextView.textColor = [UIColor lightGrayColor];

    //Get User's Location
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];

    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"In Town?";
    titleView.textColor = [UIColor colorWithRed:12.0/255.0 green:134/255.0 blue:243/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];
  //  [self downloadPosts];

//
//    //Get reference to entire window
//    self.window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
//
//
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"neulynxRedLogo.png"]];
//    CGSize imageSize = CGSizeMake(150, 60);
//    CGFloat marginX = (self.navigationController.navigationBar.frame.size.width / 2) - (imageSize.width / 2);
//
//    imageView.frame = CGRectMake(marginX, -10, imageSize.width, imageSize.height);
//    [self.navigationController.navigationBar addSubview:imageView];




//    //*check if the application has been previously run. If it's hasn't then present, the tutorial.*//
//
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasBeenRun"]) {
//
//        UIStoryboard *tutorialStoryboard = [UIStoryboard storyboardWithName:@"Tutorial" bundle:nil];
//        UITabBarController *tutorialNavVC = [tutorialStoryboard instantiateViewControllerWithIdentifier:@"tutorialNavVC"];
//
//
//        [self presentViewController:tutorialNavVC animated:true completion:nil];
//
//    }

//    //*if it has displayed the map then we say it has been run...therefore we do not show the Tutorial again*//
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasBeenRun"];
//
//    //Dismiss Keyboard when user touches outside of the search bar.
//    //first - create a tap gesture.
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
//
//    //add the tap gesture to the current view.
//    [self.view addGestureRecognizer:tap];


    //Get user's information and display current location and profile picture.
    [MRProgressOverlayView showOverlayAddedTo:self.window title:@"Loading..." mode:MRProgressOverlayViewModeIndeterminate animated:YES];
    [self getUserInformationFromParse:^{
       [self getUserCurrentLocation];
        [self setUpProfileImage];
        [self downloadPosts];

        [MRProgressOverlayView dismissOverlayForView: self.window animated:YES];
    } afterDelay:2.0];



    //
    //    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //    //BOOL tmpBool = (appDelegate.hideDoneButtonForRequests);
    //


    //    tmpBool = YES;
    //
    //    appDelegate.hideDoneButtonForRequests = &(tmpBool);
    //    appDelegate.hideDoneButtonForMessages = &(tmpBool);
    

    
    
    
    
}

//Get user's current location
-(void)getUserCurrentLocation{

    //GETING THE USER'S LOCATION
    //set up settings for location managers.
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];


}

#pragma mark CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.currentLocation = [CLLocation new];
    self.currentLocation = locations.firstObject;

    if (self.currentLocation) {
        //[self downloadActivitiesAndDisplayOnMap];

        [self downloadPosts];

    }

   // [self.locationManager stopUpdatingLocation];
    //Save the user's current Location in Background

    self.currentGeoPoint = [PFGeoPoint new];

    self.currentGeoPoint.latitude = self.currentLocation.coordinate.latitude;
    self.currentGeoPoint.longitude = self.currentLocation.coordinate.latitude;

    [User currentUser].currentLoccation = self.currentGeoPoint;


    [[User currentUser] saveInBackground];


    [self.locationManager stopUpdatingLocation];

    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:self.currentLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (error){
                           return;
                       }
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];


                       self.currentUser.currentCity = placemark.locality;
                       self.currentCity = placemark.locality;
                       self.currentUser.userAdministrativeArea = placemark.administrativeArea;
                       self.currentUser.userCountryCode = placemark.country;


                       
                   }];
}


//helper method to set up profile image button
-(void)setUpProfileImage{

    if ([User currentUser] != nil){
        //create an image and assign it to defualt image

        [self getUsersProfileImage];

        
            [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
            [[PFInstallation currentInstallation] saveEventually];


    }else if (self.currentUser == nil){


        self.tempImage = [UIImage imageNamed:@"defaultImage.png"];

    }


    UIImage *profileImage = self.tempImage;


    //create button frame
    CGRect buttonFrame = CGRectMake(0, 0, 40, 40);

    //Create left Button
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];

    //make the button rounded
    button.layer.cornerRadius = button.frame.size.height / 2;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 2.0;
    button.layer.borderColor = [UIColor colorWithRed:254.0/255.0 green:94/255.0 blue:1.0/255.0 alpha:1].CGColor;

    [button setImage:profileImage forState:UIControlStateNormal];
    [button reloadInputViews];

    //add at tap gesture recognizer to the left button
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(profileImageTapped:)];
    [button addGestureRecognizer:tapGesture];


    //create a custom view for the button
    UIView *profileButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    profileButtonView.bounds = CGRectOffset(profileButtonView.bounds, 10, 0);

    //add the button to the custom view
    [profileButtonView addSubview:button];

    UIBarButtonItem *profileButtonItem = [[UIBarButtonItem alloc]initWithCustomView:profileButtonView];
    
    self.navigationItem.leftBarButtonItem = profileButtonItem;
    
    
}



////Helper method to download user's profile image
-(void)getUsersProfileImage{

    [self.currentUser.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                dispatch_async(dispatch_get_main_queue(), ^(void) {

                    self.tempImage = image;

                });
            });
        }
        
    }];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    // Do your job, when done:

    [self downloadPosts];
    
    [refreshControl endRefreshing];
}
-(void)downloadPosts{


    if (self.currentLocation == nil) {
        NSLog(@" location is nil");

        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Connection" message:@"Please Ensure that you're connected to a network/WiFi" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }else{
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:self.currentLocation];
    PFQuery *query = [Post query];
        [query whereKey:@"locationGeoPoint" nearGeoPoint:geoPoint];
       [query orderByDescending:@"createdAt"];
       query.limit = 100;
    [query includeKey:@"postOwner"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *Posts, NSError *error){
        if (!error) {

            self.postsArray = [[NSArray alloc]initWithArray:Posts].mutableCopy;



            [self.tableView reloadData];

        }
    }];
    }
}

- (IBAction)onUsernameTapped:(UIButton *)sender {

    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    Post *selectedPost = (Post *)self.postsArray[indexPath.row];

    User *user = [User new];


    user = selectedPost.postOwner;

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];


    appDelegate.selectedUser = user;

    UIStoryboard *UserDetailStoryboard = [UIStoryboard storyboardWithName:@"UserProfile" bundle:nil];
    UINavigationController *userDetailNavVC = [UserDetailStoryboard instantiateViewControllerWithIdentifier:@"userDetailNavVC"];

    [self presentViewController:userDetailNavVC animated:YES completion:nil];


}

- (IBAction)onRepostButtonTapped:(UIButton *)sender {

    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    Post *selectedPost = (Post *)self.postsArray[indexPath.row];

    Post *tempPost = [Post new];

    tempPost.postOwner = [User currentUser];
    tempPost.postOnwerUsername = [User currentUser].username;
    tempPost.postText = [NSString stringWithFormat:@"Re: @%@ %@",selectedPost.postOnwerUsername, selectedPost.postText];

    tempPost.locationGeoPoint = self.currentGeoPoint;

    if (selectedPost.postOwner != [User currentUser] ) {



    [tempPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

        if (succeeded) {



//            // Create our Installation query
//            PFQuery *pushQuery = [PFInstallation query];
//            // only return Installations that belong to a User that
//
//            [pushQuery whereKey:@"user" equalTo:tempPost.postOwner];
//
//            // Send push notification to query
//            PFPush *push = [[PFPush alloc] init];
//
//            [push setQuery:pushQuery]; // Set our Installation query
//            [push setMessage:[NSString stringWithFormat:@"%@ Sent you a message", [User currentUser].name]];
//
//            [push sendPushInBackground];
//
            [self.postTextView resignFirstResponder];
            //set up the textView
            self.postTextView.text = @"In Town? Let others know what you're up to!";
            self.postTextView.textColor = [UIColor lightGrayColor];
            [self downloadPosts];
            [self.tableView reloadData];

            
        }
        
        
    }];

    }else{
        NSLog(@"Cannot retweet your own tweet");
    }

  indexPath = nil;
}

- (IBAction)onPostButtonDone:(UIButton *)sender {


    Post *post = [Post new];

    post.postText = self.postTextView.text;
    post.postOwner = [User currentUser];
    post.postOnwerUsername = [User currentUser].username;
    post.locationGeoPoint = self.currentGeoPoint;
    post.postCity = self.currentCity;

    if (![self.postTextView.text isEqualToString:@""]) {

    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

        if (succeeded) {

          [self.postTextView resignFirstResponder];
            //set up the textView
            self.postTextView.text = @"In Town? Let others know what you're up to!";
            self.postTextView.textColor = [UIColor lightGrayColor];
            [self downloadPosts];
            [self.tableView reloadData];


            }


    }];
    }
    [self.postTextView resignFirstResponder];






}


/*helper method to show user's profile. present the account view controller to display menus for user
 if the current user does not exist, then make him/her sign up.*/

-(void)profileImageTapped:(UIBarButtonItem* )sender{


    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    UIViewController *NavVC = [storyBoard instantiateViewControllerWithIdentifier:@"ProfileNavVC"];
    [self presentViewController:NavVC animated:YES completion:nil];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.postsArray.count;
}
- (IBAction)onInboxButtonTapped:(UIBarButtonItem *)sender {

    self.messageButton.badgeValue = nil;

    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Mail" bundle:nil];
    UIViewController *NavVC = [storyBoard instantiateViewControllerWithIdentifier:@"mailNavVC"];
    [self presentViewController:NavVC animated:YES completion:nil];


}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    PostCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    Post *tempPost = [Post new];

    tempPost = (Post *)(self.postsArray[indexPath.row]);

    cell.postText.text = tempPost.postText;

     [cell.posterUserName setTitle:[NSString stringWithFormat:@"@%@", tempPost.postOnwerUsername] forState:UIControlStateNormal];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-YYYY"];

    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm "];

    NSDate *date = tempPost.createdAt;

    NSString *theDate = [dateFormat stringFromDate:date];
    NSString *theTime = [timeFormat stringFromDate:date];


    cell.postDate.text = [NSString stringWithFormat:@"%@ %@", theTime, theDate];
//    if ([((Post *)self.postsArray[indexPath.row]).LikerArray containsObject:[User currentUser]]){
//        cell.likeButton.enabled = NO;
//        cell.likeButton.alpha = 0.5;
//    }else {
//        cell.likeButton.enabled = YES;
//        cell.likeButton.alpha = 1.0;
//    }

    //Use CoreLocation to get distance between activity and user's location.
//    CLLocation *postLocation = [[CLLocation alloc]initWithLatitude:tempPost.locationGeoPoint.latitude longitude:tempPost.locationGeoPoint.longitude];
    // CLLocationDistance distance = [postLocation distanceFromLocation:self.currentLocation];
    //double distanceInMiles = distance * (0.00062137);

    cell.postDistanceFromCurrentUser.text = tempPost.postCity;

    

    return cell;


}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    return indexPath;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


}
//retrieve messages count

-(void)checkForNewMessages{
    NSMutableArray *array = [NSMutableArray new];




    PFQuery *query = [Alert query];

    [query whereKey:@"recipientUsername" equalTo:[User currentUser].username];
    [query whereKey:@"messageIsNew" equalTo:@1];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){

        // NSLog(@"YOOOOOOOOOOOOOO, %@", objects);

        if (!error) {
            for (Alert *alert in objects) {



                if (![array containsObject:alert.senderUsername] )  {
                    [array addObject:alert];

                }
            }

         NSLog(@"%lu runnningggg ", (unsigned long)array.count);


            if ([array count] != 0) {



                self.messageButton.badgeValue = [NSString stringWithFormat:@"%lu", (unsigned long)array.count];
            }

        }
        
    }];
}

#pragma mark - UITextView Delegate Methods

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"In Town? Let others know what you're up to!"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"In Town? Let others know what you're up to!";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}


#pragma Marks - hiding keyboard
//hide keyboard when the user clicks return
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    [self.view endEditing:true];
    return true;
}
//helper method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}



-(void)getUserInformationFromParse:(void(^)())block afterDelay:(NSTimeInterval)delay{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime,dispatch_get_main_queue(), block);
}


-(void)saveFbUserInfoToParse:(void(^)())block afterDelay:(NSTimeInterval)delay{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime,dispatch_get_main_queue(), block);
}



@end
