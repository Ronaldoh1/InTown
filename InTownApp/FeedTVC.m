//
//  FeedTVC.m
//  InTown
//
//  Created by Ronald Hernandez on 9/4/15.
//  Copyright (c) 2015 inTown. All rights reserved.
//

#import "FeedTVC.h"
#import "User.h"
<<<<<<< HEAD
#import "MRProgressOverlayView.h"
#import "MRProgress.h"
#import "Post.h"
#import "PostCustomCell.h"
=======
>>>>>>> parent of bb7bc3e... able to tweet

@interface FeedTVC ()
@property UIImage *tempImage;
@property User *currentUser;
<<<<<<< HEAD
@property UIWindow *window;
@property NSMutableArray *postsArray;
@property CLLocation *currentLocation;
@property CLLocationManager *locationManager;
@property CLLocation *initialLocation;
@property PFGeoPoint *currentGeoPoint;
@property (weak, nonatomic) IBOutlet UITextView *postTextView;
=======
>>>>>>> parent of bb7bc3e... able to tweet

@end

@implementation FeedTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpProfileImage];
<<<<<<< HEAD
    [self performInitialSetup];
}


-(void)viewDidAppear:(BOOL)animated{

    [super viewWillAppear:YES];

    if ([User currentUser] != nil) {


        [self setUpProfileImage];
        
    }

}




//helper method for initial set up

-(void)performInitialSetup{


    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

    //Get Current User
    self.currentUser = [User currentUser];

    self.currentLocation = [CLLocation new];



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
                       self.currentUser.userAdministrativeArea = placemark.administrativeArea;
                       self.currentUser.userCountryCode = placemark.country;


                       
                   }];
=======
>>>>>>> parent of bb7bc3e... able to tweet
}
//helper method to set up profile image button
-(void)setUpProfileImage{

    if (self.currentUser != nil){
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

<<<<<<< HEAD
- (void)refresh:(UIRefreshControl *)refreshControl {
    // Do your job, when done:

    [self downloadPosts];
    
    [refreshControl endRefreshing];
}
-(void)downloadPosts{


    if (self.currentLocation == nil) {
        NSLog(@" location is nil");
    }else{
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:self.currentLocation];
        NSLog(@"%@",geoPoint);
    PFQuery *query = [Post query];
        [query whereKey:@"locationGeoPoint" nearGeoPoint:geoPoint];
       [query orderByDescending:@"createdAt"];
       query.limit = 100;
    [query includeKey:@"postOwner"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *Posts, NSError *error){
        if (!error) {

            self.postsArray = [[NSArray alloc]initWithArray:Posts].mutableCopy;


            NSLog(@"%@ booom", self.postsArray);


            [self.tableView reloadData];

        }
    }];
    }
}

- (IBAction)onPostButtonDone:(UIButton *)sender {


    Post *post = [Post new];

    post.postText = self.postTextView.text;
    post.postOwner = [User currentUser];
    post.postOnwerUsername = [User currentUser].username;
    post.locationGeoPoint = self.currentGeoPoint;

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


=======
>>>>>>> parent of bb7bc3e... able to tweet
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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
<<<<<<< HEAD
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    PostCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    Post *tempPost = [Post new];

    tempPost = (Post *)(self.postsArray[indexPath.row]);

    cell.postText.text = tempPost.postText;
    cell.posterUserName.titleLabel.text = [NSString stringWithFormat:@"@%@", tempPost.postOnwerUsername];





    return cell;


}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UITextView Delegate Methods

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"In Town? Let others know what you're up to!"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
=======
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
>>>>>>> parent of bb7bc3e... able to tweet
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
