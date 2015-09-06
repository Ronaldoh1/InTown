////
////  InboxVC.m
////  NeuLynx
////
////  Created by Ronald Hernandez on 7/11/15.
////  Copyright (c) 2015 NeuLynx. All rights reserved.
////
//
//#import "InboxVC.h"
//#import <Parse/Parse.h>
//#import "User.h"
//#import "DialogVC.h"
//#import "AppDelegate.h"
//
//#import "InboxCustomCell.h"
//#import "Inbox.h"
//#import "InboxSearchResultTVC.h"
//#import "Alert.h"
//
//
//@interface InboxVC ()<UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating>
//
////Search Controller
//@property (nonatomic, strong) UISearchController *searchController;
//@property (nonatomic, strong) NSMutableArray *searchResults;
//
//
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, atomic) NSMutableArray *inboxArray;
//@property (strong, atomic) DialogVC *activeDialogVC;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;
//
//
////alerts
//@property NSMutableArray *alertArray;
//@end
//
//@implementation InboxVC
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    [self initialSetUp]; 
//}
//
//-(void)viewWillAppear:(BOOL)animated{
//
//    self.activeDialogVC = nil;
//
//   
//
//    [self initialSetUp];
//    [self downloadNewAlerts];
//}
//-(void)initialSetUp{
//    //setting image to Navigation Bar's title
//
//    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
//    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
//    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
//    titleView.text = @"Inbox";
//    titleView.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];
//    [self.navigationItem setTitleView:titleView];
//
//    //initialize the inboxArray
//
//    [self downloadInboxForCurrentUser];
//
////    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
////    BOOL tmpBool = *(appDelegate.hideDoneButtonForMessages);
////
////    if (tmpBool == YES) {
////        tmpBool = NO;
////        appDelegate.hideDoneButtonForMessages = nil;
////        self.navigationItem.rightBarButtonItem = nil;
////        self.doneBarButton.enabled = NO;
////
////    }
//
//    //Instantiate View Controller with Iddentifier - this is necessary because there is no connection in our storyboard to our search results.
//
//    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"TableSearchResultsNavController"];
//
//    //get an instance of UISearch Controller
//    self.searchController = [[UISearchController alloc]initWithSearchResultsController:searchResultsController];
//
//    self.searchController.searchResultsUpdater = self;
//
//    // We need to create our SearchBar Programatically
//    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
//
//    self.tableView.tableHeaderView = self.searchController.searchBar;
//
//    UITabBarController *tabController = (UITabBarController *)self.tabBarController;
//    [[tabController.viewControllers objectAtIndex:1] tabBarItem].badgeValue = nil;
//
//
//}
//
//
//
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:YES];
//
//    [self downloadInboxForCurrentUser];
//}
//- (IBAction)onDoneButtonDone:(UIBarButtonItem *)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//
//#pragma mark - UITableView Delegate
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//
//    return self.inboxArray.count;
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//
//     InboxCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fromCell"];
//    User *sender = (User *)(self.inboxArray[indexPath.row]);
//    [sender fetchIfNeededInBackground];
//   // Message *message = ((Message *)(self.inboxArray[indexPath.row]));
//    cell.senderNameLabel.text = sender.name;
//
//    [sender.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//        if (!error) {
//            UIImage *image = [UIImage imageWithData:data];
//            cell.userProfileImage.image = image;
//        }
//
//    }];
//
//
//    for (Alert *alert in self.alertArray) {
//
//
//        if ([sender.username isEqualToString:alert.senderUsername] && [alert.messageIsNew isEqualToNumber:@1]) {
//
//            cell.blueDot.alpha = 1.0;
//        }
//
//    }
//
//       //cell.detailTextLabel.text = @"You got a Message";
//    return cell;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    //deselect the cell that was selected.
//    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//    //need to remove the blue dot from the cell.
//    ((InboxCustomCell *)[self.tableView cellForRowAtIndexPath:indexPath]).blueDot.alpha = 0;
//    //we need to mark our alerts as read.
//
//
//    User *sender = [User new];
//    sender = (User *)self.inboxArray[indexPath.row];
//    Alert *selectedAlert = [Alert new];
//
//    for (Alert *alert in self.alertArray) {
//
//
//        if ([sender.username isEqualToString:alert.senderUsername] && [alert.messageIsNew isEqualToNumber:@1]) {
//
//            alert.messageIsNew = @0;
//            selectedAlert = alert;
//        }
//        
//    }
//    [selectedAlert saveInBackground];
//
//
//
//    UIStoryboard *detailStoryboard = [UIStoryboard storyboardWithName:@"Mail" bundle:nil];
//    UIViewController *detailVC = [detailStoryboard instantiateViewControllerWithIdentifier:@"navVC"];
//
//    //set the activity that is goign to be shared through out the app - to dispay to the user when the user clicks on detail.
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.selectedRecepient = (User *) self.inboxArray[indexPath.row];
//
//    [self presentViewController:detailVC animated:YES completion:nil];
//}
//
//#pragma mark Prepare For Segue
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Segue to open a dialog
//    if ([segue.identifier isEqualToString:@"OpenDialogSegue"]) {
//        self.activeDialogVC = segue.destinationViewController;
//        NSInteger chatMateIndex = [[self.tableView indexPathForCell:(UITableViewCell *)sender] row];
//        self.activeDialogVC.selectedRecipient = (User *)self.inboxArray[chatMateIndex];
//
//        self.searchController.active = NO;
//
//        return;
//    }
//}
//
//
//#pragma mark - UISearchControllerDelegate & UISearchResultsDelegate
//
//// Called when the search bar becomes first responder
//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
//
//    // Set searchString equal to what's typed into the searchbar
//    NSString *searchString = self.searchController.searchBar.text;
//
//    [self updateFilteredContentForActivity:searchString];
//
//    // If searchResultsController
//    if (self.searchController.searchResultsController) {
//
//        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
//
//        // Present SearchResultsTableViewController as the topViewController
//        InboxSearchResultTVC *vc = (InboxSearchResultTVC *)navController.topViewController;
//
//        // Update searchResults
//        vc.searchResults = self.searchResults;
//
//        // And reload the tableView with the new data
//        [vc.tableView reloadData];
//    }
//}
//
//// Update self.searchResults based on searchString, which is the argument in passed to this method
//- (void)updateFilteredContentForActivity:(NSString *)searchStr{
//
//    if (searchStr == nil) {
//
//        // If empty the search results are the same as the original data
//        self.searchResults = [self.inboxArray mutableCopy];
//
//    } else {
//
//        NSMutableArray *searchResults = [[NSMutableArray alloc] init];
//
//        //here we want to make sure that we return the activities that contain the string for non-case sensitive strings.
//
//        for (User *user in self.inboxArray){
//            NSRange NameRange = [user.name rangeOfString:searchStr options:NSCaseInsensitiveSearch];
////            NSRange descriptionRange = [activity.activityDescription rangeOfString:searchStr options:NSCaseInsensitiveSearch];
////
//            if (NameRange.location != NSNotFound) {
//
//                [searchResults addObject:user];
//            }
//        }
//        
//        self.searchResults = searchResults;
//        
//    }
//}
//
//#pragma mark - Helper methods
////This helper method allows us retrieve an array which contains the messages that have been sent the current user. Query the database where the recepient is the current user and then iterate through each object found and add message object and sender pointer to the inboxArray if and only if it has not been previously added.
//
//-(void)downloadInboxForCurrentUser{
//    NSMutableArray *array = [NSMutableArray new];
//
//
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat: @"(messageContactUsername = '%@') OR (inboxOwnerUsername = '%@')", [User currentUser].username, [User currentUser].username]];
//
//
//
//    PFQuery *query = [PFQuery queryWithClassName:@"Inbox" predicate:predicate];
//
//    //[query orderByAscending:@"updatedAt"];
//
////
////    PFQuery *query = [PFQuery queryWithClassName:@"Inbox"];
////    [query whereKey:@"inboxOwner" equalTo:[User currentUser]];
////    [query whereKey:@"messageContact" equalTo:[User currentUser]];
//    [query includeKey:@"messageContact"];
//    [query includeKey:@"inboxOwner"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
//
//
//        if (!error) {
//            for (Inbox *contact in objects) {
//
//
//
//                if (![array containsObject:contact.messageContact] && contact.messageContact != [User currentUser])  {
//                    [array addObject:contact.messageContact];
//
//                }else if (![array containsObject:contact.inboxOwner]  && contact.inboxOwner != [User currentUser]){
//                    
//                    [array addObject:contact.inboxOwner];
//                }
//                }
//
//
//            self.inboxArray = [NSMutableArray arrayWithArray:array];
//            [self.tableView reloadData];
//            
//        }
//        
//    }];
//}
//
//-(void)downloadNewAlerts{
//    NSMutableArray *array = [NSMutableArray new];
//
//
//
//
//    PFQuery *query = [Alert query];
//
//    [query whereKey:@"recipientUsername" equalTo:[User currentUser].username];
//
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
//
//
//        if (!error) {
//            for (Alert *alert in objects) {
//
//
//
//                if (![array containsObject:alert.senderUsername] )  {
//                    [array addObject:alert];
//
//                }
//            }
//
//            self.alertArray = [NSMutableArray arrayWithArray:array];
//            [self.tableView reloadData];
//            
//        }
//        
//    }];
//}
//@end
