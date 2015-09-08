//
//  UserDetail.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 8/21/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "UserDetailTVC.h"
#import "User.h"
#import "AppDelegate.h"
#import "Inbox.h"

@interface UserDetailTVC ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextView *aboutMeTextView;


//*********Define Current User*******

@property User *selectedUser;

//****Language Buttons******
@property NSMutableArray *languageArray;

@property (weak, nonatomic) IBOutlet UIButton *portugueseButton;
@property (weak, nonatomic) IBOutlet UIButton *spanishButton;

@property (weak, nonatomic) IBOutlet UIButton *englishButton;
@property (weak, nonatomic) IBOutlet UIButton *frenchButton;

@property  (weak, nonatomic)  NSString *selectedEntry;

@property (assign) BOOL genderArraySelected;


@property  (weak, nonatomic) UIWindow *window;

@property  (weak, nonatomic)  NSArray *preferencesSelectionArray;

@end

@implementation UserDetailTVC


- (void)viewDidLoad {
    [super viewDidLoad];

    [self performInitialSetUp];
    //get user's profile Image
    [self getUsersProfileImage];
    //get Uer's personal information
    [self getUsersPersonalInformation];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Initial set up of Nav Bar, User, Profile Image, Set up Delegates.
-(void)performInitialSetUp{

    //*******Setup Current User*********//


    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    self.selectedUser = [User new];

    self.selectedUser = appDelegate.selectedUser;
    //Make profile image round

    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth = 4.0;
    self.profileImage.layer.borderColor = [UIColor colorWithRed:254.0/255.0 green:94/255.0 blue:1.0/255.0 alpha:1].CGColor;


    //setting image to Navigation Bar's title
    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = self.selectedUser.name;
    titleView.textColor = [UIColor colorWithRed:12.0/255.0 green:134/255.0 blue:243/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];


    //Dim the colors of language buttons
    self.portugueseButton.alpha = 0.3;
    self.spanishButton.alpha = 0.3;
    self.englishButton.alpha = 0.3;
    self.frenchButton.alpha = 0.3;


}


//helper method to get user's languages
-(void)getUsersPersonalInformation{
    //******Get the information of the current user********//i

    //change the color of the basic info label.
    self.nameLabel.textColor = [UIColor colorWithRed:12.0/255.0 green:134/255.0 blue:243/255.0 alpha:1];
    self.genderLabel.textColor = [UIColor colorWithRed:12.0/255.0 green:134/255.0 blue:243/255.0 alpha:1];
    self.ageLabel.textColor = [UIColor colorWithRed:12.0/255.0 green:134/255.0 blue:243/255.0 alpha:1];

    //get basic information

    self.nameLabel.text = self.selectedUser.name;
    self.ageLabel.text = [NSString stringWithFormat:@"%@ Years Old", self.selectedUser.age];
    self.genderLabel.text = [NSString stringWithFormat: @"%@, %@", self.selectedUser.gender, self.selectedUser.orientation];

    self.aboutMeTextView.text = self.selectedUser.aboutMe;






    //get user's languages
    self.languageArray = [[NSMutableArray alloc] initWithArray:self.selectedUser.languageArray.mutableCopy];

    for (int i = 0; i<self.languageArray.count; i++) {
        if ([self.languageArray[i] isEqualToString:@"Portuguese"]) {
            self.portugueseButton.alpha = 1.0;

        }else if([self.languageArray[i] isEqualToString:@"Spanish"]){
            self.spanishButton.alpha = 1.0;

        }else if([self.languageArray[i] isEqualToString:@"English"]){
            self.englishButton.alpha = 1.0;

        }else if([self.languageArray[i] isEqualToString:@"French"]){
            self.frenchButton.alpha = 1.0;

        }

    }




}
- (IBAction)onDoneButtonTapped:(UIBarButtonItem *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

//Helper method to download user's profile image
-(void)getUsersProfileImage{

    [self.selectedUser.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            self.profileImage.image = image;
        }

    }];
}



#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];


    if (indexPath.section == 3 && indexPath.row == 0) {
        Inbox *newInboxItem = [Inbox new];

        newInboxItem.messageContact = [User currentUser];
        newInboxItem.messageContactUsername = [User currentUser].username;
        newInboxItem.inboxOwner = self.selectedUser;
        newInboxItem.inboxOwnerUsername = self.selectedUser.username;

        [newInboxItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {

                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Mail" bundle:nil];
                UIViewController *NavVC = [storyBoard instantiateViewControllerWithIdentifier:@"mailNavVC"];
                [self presentViewController:NavVC animated:YES completion:nil];

            }

        }];
    }
}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 3) {
        return indexPath;
        
    }else{
        return nil;
    }
}

@end
