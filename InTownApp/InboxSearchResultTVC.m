//
//  InboxSearchResultTVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 8/24/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "InboxSearchResultTVC.h"
#import "User.h"
#import "DialogVC.h"
#import "InboxCustomCell.h"
#import "AppDelegate.h"

@interface InboxSearchResultTVC ()
@property (strong, atomic) DialogVC *activeDialogVC;

@end

@implementation InboxSearchResultTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.searchResults.count;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //deselect the cell that was selected.
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];


    UIStoryboard *detailStoryboard = [UIStoryboard storyboardWithName:@"Mail" bundle:nil];
    UIViewController *detailVC = [detailStoryboard instantiateViewControllerWithIdentifier:@"navVC"];

    //set the activity that is goign to be shared through out the app - to dispay to the user when the user clicks on detail.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.selectedRecepient = (User *) self.searchResults[indexPath.row];

    [self presentViewController:detailVC animated:YES completion:nil];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    InboxCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fromCell"];
    User *sender = (User *)(self.searchResults[indexPath.row]);
    [sender fetchIfNeededInBackground];
    // Message *message = ((Message *)(self.inboxArray[indexPath.row]));
    cell.senderNameLabel.text = sender.name;

    [sender.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            cell.userProfileImage.image = image;
        }

    }];
    //cell.detailTextLabel.text = @"You got a Message";
    return cell;
}

#pragma mark Prepare For Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Segue to open a dialog
    if ([segue.identifier isEqualToString:@"OpenDialogSegueFromSearch"]) {
        self.activeDialogVC = segue.destinationViewController;
        NSInteger chatMateIndex = [[self.tableView indexPathForCell:(UITableViewCell *)sender] row];
        self.activeDialogVC.selectedRecipient = (User *)self.searchResults[chatMateIndex];

        

        //Instantiate View Controller with Iddentifier - this is necessary because there is no connection in our storyboard to our search results.
    
               
        return;
    }
}

@end
