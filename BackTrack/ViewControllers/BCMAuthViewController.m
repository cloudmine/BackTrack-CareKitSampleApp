#import "BCMAuthViewController.h"
#import "UIViewController+BCM.h"
#import <CMHealth/CMHealth.h>

@interface BCMAuthViewController ()<CMHAuthViewDelegate>

@end

@implementation BCMAuthViewController

#pragma mark Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark Target-Action

- (IBAction)didPressJoinButton:(UIButton *)sender
{
    CMHAuthViewController* signupViewController = [CMHAuthViewController signupViewController];
    signupViewController.delegate = self;

    [self presentViewController:signupViewController animated:YES completion:nil];
}

- (IBAction)didPressLoginButton:(UIButton *)sender
{
    CMHAuthViewController *loginViewController = [CMHAuthViewController loginViewController];
    loginViewController.delegate = self;

    [self presentViewController:loginViewController animated:YES completion:nil];
}

#pragma mark CMHAuthViewDelegate

- (void)authViewCancelledType:(CMHAuthType)authType
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)authViewOfType:(CMHAuthType)authType didSubmitWithEmail:(NSString *)email andPassword:(NSString *)password
{
    switch (authType) {
        case CMHAuthTypeLogin:
            [self loginWithEmail:email andPassword:password];
            break;
        case CMHAuthTypeSignup:
            [self signupWithEmail:email andPassword:password];
            break;
        default:
            break;
    }
}

#pragma mark Private

- (void)loginWithEmail:(NSString *_Nonnull)email andPassword:(NSString *_Nonnull)password
{
    [[CMHUser currentUser] loginWithEmail:email password:password andCompletion:^(NSError * _Nullable error) {
        if (nil != error) {
            [self.presentedViewController showAlertWithMessage:NSLocalizedString(@"Error Logging In", nil) andError:error];
            return;
        }

        NSLog(@"Logged in successfully");
    }];
}

- (void)signupWithEmail:(NSString *_Nonnull)email andPassword:(NSString *_Nonnull)password
{
    [[CMHUser currentUser] signUpWithEmail:email password:password andCompletion:^(NSError * _Nullable error) {
        if (nil != error) {
            [self.presentedViewController showAlertWithMessage:NSLocalizedString(@"Error Signing Up", nil) andError:error];
            return;
        }

        NSLog(@"Successfully Signed Up");
    }];
}

@end
