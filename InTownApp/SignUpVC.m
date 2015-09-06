//
//  SignUpVC.m
//  InTown
//
//  Created by Ronald Hernandez on 9/4/15.
//  Copyright (c) 2015 inTown. All rights reserved.
//

#import "SignUpVC.h"
#import "User.h"

@interface SignUpVC ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property CGFloat animatedDistance;

@end

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;


@implementation SignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}






- (IBAction)onSignUpButtonTapped:(UIButton *)sender {


    NSString *signUpError = @"";

    //all fields are required for signup
    if ([self.emailTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]) {

        signUpError = @"All fields are required, please try again!";

        //passwords must match
    }else if([self.passwordTextField.text length] < 6 ){
        signUpError = @"Your Password must be at least 6 characters";

        //if the user has met all of these conditions, then we sign him up.
    }else{
        [self signUp];
        
    }


}



-(void)signUp{
    User *user = [User new];
    user.username = self.usernameTextField.text;
    user.password = self.passwordTextField.text;
    user.email = self.emailTextField.text;



    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {   // Hooray! Let them use the app now.
            //If the user is new then present the profile
            //Enable the message and requests tabs.


            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Feed" bundle:nil];
            UIViewController *feedNavVC = [storyBoard instantiateViewControllerWithIdentifier:@"FeedNavVC"];
            [self presentViewController:feedNavVC animated:YES completion:nil];

        } else { //show the error
            NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
            [self displaySignUpErrorAlert:errorString];
        }
    }];
}

- (IBAction)onTermsAndConditionsButtonTapped:(UIButton *)sender {

    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Policy" bundle:nil];
    UIViewController *termAndConditionsNavVC = [storyBoard instantiateViewControllerWithIdentifier:@"TermAndConditionsNavVC"];
    [self presentViewController:termAndConditionsNavVC animated:YES completion:nil];
}


- (IBAction)onCancelButtonTapped:(UIButton *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
    
}


//*Helper Method to display alert*//

//helper method to show error alert to the user
-(void)displaySignUpErrorAlert:(NSString *)error{
    //create the alert
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //display the alert
    [alert show];

}


#pragma Marks - hiding keyboard
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0){
        heightFraction = 0.0;
    }
    else if(heightFraction > 1.0){
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown){
        self.animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else{
        self.animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= self.animatedDistance;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];

    [self.view setFrame:viewFrame];

    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textfield{

    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += self.animatedDistance;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];

    [self.view setFrame:viewFrame];

    [UIView commitAnimations];
}
////hide keyboard when the user clicks return
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    [self.view endEditing:true];
    return true;
}
//hide keyboard when user touches outside.
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
