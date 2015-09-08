//
//  WelcomeVC.m
//  InTown
//
//  Created by Ronald Hernandez on 9/4/15.
//  Copyright (c) 2015 inTown. All rights reserved.
//

#import "WelcomeVC.h"
#import "User.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <PFTwitterUtils.h>

#import <Accounts/Accounts.h>

@interface WelcomeVC ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;

@end

@implementation WelcomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.loginButton.layer.borderWidth = 2.0;
    self.signupButton.layer.borderWidth = 2.0;
    self.loginButton.layer.borderColor  = [UIColor whiteColor].CGColor;
    self.signupButton.layer.borderColor = [UIColor whiteColor].CGColor;

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];

    if ([User currentUser] != nil) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Feed" bundle:nil];
        UIViewController *feedNavVC = [storyBoard instantiateViewControllerWithIdentifier:@"FeedNavVC"];
        [self presentViewController:feedNavVC animated:YES completion:nil];
    }
}

- (IBAction)onSignInButtonTapped:(UIButton *)sender {

    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"SignIn" bundle:nil];
    UIViewController *signInVC = [storyBoard instantiateViewControllerWithIdentifier:@"SignInVC"];
    [self presentViewController:signInVC animated:YES completion:nil];

}


- (IBAction)onSignUpButtonTapped:(UIButton *)sender {

    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"SignUp" bundle:nil];
    UIViewController *signInVC = [storyBoard instantiateViewControllerWithIdentifier:@"SignUpVC"];
    [self presentViewController:signInVC animated:YES completion:nil];


    
}

- (IBAction)onSignInWithFacebookButtonTapped:(UIButton *)sender {


    NSArray *permissionsArray = @[ @"email", @"public_profile"];

    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");


            [self getFacebookUserData];

            //if the user is new, then we want to get his information from facebook and store it in parse.
            [self saveFbUserInfoToParse:^{
                //If the user is new then present the profile


                self.navigationItem.leftBarButtonItem.enabled = YES;
                


                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Username" message:@"Enter a unique username" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    textField.placeholder = @"Username";
                }];


                UIAlertAction *cancelAction = [UIAlertAction
                                               actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                               style:UIAlertActionStyleCancel
                                               handler:^(UIAlertAction *action)
                                               {
                                                   NSLog(@"Cancel action");
                                               }];
                UIAlertAction *setUsername = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                    UITextField *textField = alertController.textFields.firstObject;
                    [User currentUser].username = textField.text;
                    [[User currentUser] saveInBackground];


                    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Feed" bundle:nil];
                    UIViewController *feedNavVC = [storyBoard instantiateViewControllerWithIdentifier:@"FeedNavVC"];
                    [self presentViewController:feedNavVC animated:YES completion:nil];
                }];
                
                [alertController addAction:setUsername];
                [alertController addAction:cancelAction];
                
                [self presentViewController:alertController animated:YES
                                 completion:nil];
                
            } afterDelay:2];


        } else {
            NSLog(@"User logged in through Facebook!");

            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Feed" bundle:nil];
            UIViewController *feedNavVC = [storyBoard instantiateViewControllerWithIdentifier:@"FeedNavVC"];
            [self presentViewController:feedNavVC animated:YES completion:nil];
        }
    }];



}
- (IBAction)onSignInWithTwitterButtonTapped:(UIButton *)sender {


    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Twitter login.");
            return;
        } else if (user.isNew) {


            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Username" message:@"Enter a unique username" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"Username";
            }];


            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                               NSLog(@"Cancel action");
                                           }];
            UIAlertAction *setUsername = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                UITextField *textField = alertController.textFields.firstObject;
                [User currentUser].username = textField.text;


                NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"defaultImage.png"]);
                PFFile *imageFile = [PFFile fileWithData:imageData];


                [User currentUser].profileImage = imageFile;
                
                [[User currentUser] saveInBackground];


                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Feed" bundle:nil];
                UIViewController *feedNavVC = [storyBoard instantiateViewControllerWithIdentifier:@"FeedNavVC"];
                [self presentViewController:feedNavVC animated:YES completion:nil];
            }];

            [alertController addAction:setUsername];
            [alertController addAction:cancelAction];

            [self presentViewController:alertController animated:YES
                             completion:nil];


        } else {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Feed" bundle:nil];
            UIViewController *feedNavVC = [storyBoard instantiateViewControllerWithIdentifier:@"FeedNavVC"];
            [self presentViewController:feedNavVC animated:YES completion:nil];
        }
    }];


}

//this helper method is used to retrieve the facebook data from the user and store in parse.

- (void)getFacebookUserData{


    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        // handle response
        [User currentUser].name = result[@"name"];
        [User currentUser].email = result[@"email"];
        [User currentUser].isFbUser = true;
        [[User currentUser] saveInBackground];


        [self getFbUserProfileImage:result[@"id"]];

    }];
}

//helper method to retrieve user's profile image from facebook..

-(void)getFbUserProfileImage:(id)facebookID{


    // URL should point to https://graph.facebook.com/{facebookId}/picture?type=large&return_ssl_resources=1
    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];

    // Run network request asynchronously
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         if (connectionError == nil && data != nil) {
             // Set the image in the imageView
             // UIImage *image = [UIImage imageWithData:data];

             PFFile *file = [ PFFile fileWithData:data];

             dispatch_async(dispatch_get_main_queue(), ^{

                 [User currentUser].profileImage = file;
             });

             [[User currentUser] saveInBackground];
             
         }
     }];
    
}
#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView lickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        default:
            NSLog(@"did not accept Terms & Conditions...");
            break;
        case 1:
            NSLog(@"accepted Terms & Conditions...");



            [[User currentUser] saveInBackground];
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Feed" bundle:nil];
            UIViewController *feedNavVC = [storyBoard instantiateViewControllerWithIdentifier:@"FeedNavVC"];
            [self presentViewController:feedNavVC animated:YES completion:nil];

            break;
    }
}

//**********************BLOCKS***********************************************//

-(void)saveFbUserInfoToParse:(void(^)())block afterDelay:(NSTimeInterval)delay{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime,dispatch_get_main_queue(), block);
}

@end
