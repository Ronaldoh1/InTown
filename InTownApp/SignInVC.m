//
//  SignInVC.m
//  
//
//  Created by Ronald Hernandez on 9/4/15.
//
//

#import "SignInVC.h"
#import "User.h"

@interface SignInVC ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property CGFloat animatedDistance;

@end

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@implementation SignInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onSignInButtonTapped:(UIButton *)sender {

    [User logInWithUsernameInBackground:self.emailTextField.text password:self.passwordTextField.text  block:^(PFUser *user, NSError *error) {
      if (user) {

          // Do stuff after successful login.
          UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Feed" bundle:nil];
          UIViewController *feedNavVC = [storyBoard instantiateViewControllerWithIdentifier:@"FeedNavVC"];
          [self presentViewController:feedNavVC animated:YES completion:nil];
      } else {
          // The login failed. Check error to see why.
          [self displayAlertWithTitle:@"Error Loggin in" andWithMessage:error.localizedDescription];
      }
  }];

}

- (IBAction)onSignUpButtonTapped:(UIButton *)sender {


    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"SignUp" bundle:nil];
    UIViewController *signInVC = [storyBoard instantiateViewControllerWithIdentifier:@"SignUpVC"];
    [self presentViewController:signInVC animated:YES completion:nil];


}


- (IBAction)onCancelButtonTapped:(UIButton *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)onForgotButtonTapped:(UIButton *)sender{


    UIAlertController *alertController = [ UIAlertController alertControllerWithTitle:@"Reset Password" message:@"Enter your email address" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Email Address";
    }];


    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    UIAlertAction *resetPasswordAction = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

        UITextField *textField = alertController.textFields.firstObject;
        [PFUser requestPasswordResetForEmail:textField.text];
    }];

    [alertController addAction:resetPasswordAction];
    [alertController addAction:cancelAction];

    [self presentViewController:alertController animated:YES
                     completion:nil];

    
}

//************Helper Methods ****************************//
//Display general alert

-(void)displayAlertWithTitle:(NSString *)title andWithMessage:(NSString *)message{

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];

    [alertView show];


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
