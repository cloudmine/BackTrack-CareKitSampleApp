#import <CMHealth/CMHealth.h>
#import "BCMAuthViewController.h"
#import "UIViewController+BCM.h"
#import "UIButton+BCM.h"
#import "BCMAppDelegate.h"

@interface BCMAuthViewController ()<CMHLoginViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@end

@implementation BCMAuthViewController

#pragma mark Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.joinButton setCornerRadius:4.0f andBorderWidth:1.0f];
}

#pragma mark Target-Action

- (IBAction)didPressJoinButton:(UIButton *)sender
{
    ORKRegistrationStep *registrationStep = [[ORKRegistrationStep alloc] initWithIdentifier:@"BCMRegistrationStep"
                                                                                     title:NSLocalizedString(@"Registration", nil)
                                                                                      text:NSLocalizedString(@"Create an account", nil)
                                                                                   options:ORKRegistrationStepDefault];

    ORKOrderedTask *registrationTask = [[ORKOrderedTask alloc] initWithIdentifier:@"BMCRegistrationTask" steps:@[registrationStep]];

    ORKTaskViewController *registrationVC = [[ORKTaskViewController alloc] initWithTask:registrationTask taskRunUUID:nil];

    [self presentViewController:registrationVC animated:YES completion:nil];
//    CMHAuthViewController* signupViewController = [CMHAuthViewController signupViewController];
//    signupViewController.delegate = self;
//
//    [self presentViewController:signupViewController animated:YES completion:nil];
}

- (IBAction)didPressLoginButton:(UIButton *)sender
{
//    CMHAuthViewController *loginViewController = [CMHAuthViewController loginViewController];
//    loginViewController.delegate = self;
//
//    [self presentViewController:loginViewController animated:YES completion:nil];

    CMHLoginViewController *loginVC = [[CMHLoginViewController alloc] initWithTitle:NSLocalizedString(@"Log In", nil)
                                                                               text:NSLocalizedString(@"Please log in to you account to store and access your personal health data.", nil)
                                                                           delegate:self];

    [self presentViewController:loginVC animated:YES completion:nil];
}

#pragma mark CMHLoginViewControllerDelegate

- (void)loginViewControllerCancelled:(CMHLoginViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginViewController:(CMHLoginViewController *)viewController didLogin:(BOOL)success error:(NSError *)error
{
    if (!success) {
        [self.presentedViewController showAlertWithMessage:NSLocalizedString(@"Error Logging In", nil) andError:error];
        return;
    }

    [self.bcmAppDelegate loadMainPanel];
}

//- (void)authViewCancelledType:(CMHAuthType)authType
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)authViewOfType:(CMHAuthType)authType didSubmitWithEmail:(NSString *)email andPassword:(NSString *)password
//{
//    switch (authType) {
//        case CMHAuthTypeLogin:
//            [self loginWithEmail:email andPassword:password];
//            break;
//        case CMHAuthTypeSignup:
//            [self signupWithEmail:email andPassword:password];
//            break;
//        default:
//            break;
//    }
//}

#pragma mark Private

- (void)loginWithEmail:(NSString *_Nonnull)email andPassword:(NSString *_Nonnull)password
{
    [[CMHUser currentUser] loginWithEmail:email password:password andCompletion:^(NSError * _Nullable error) {
        if (nil != error) {
            [self.presentedViewController showAlertWithMessage:NSLocalizedString(@"Error Logging In", nil) andError:error];
            return;
        }

        [self.bcmAppDelegate loadMainPanel];
    }];
}

- (void)signupWithEmail:(NSString *_Nonnull)email andPassword:(NSString *_Nonnull)password
{
    [[CMHUser currentUser] signUpWithEmail:email password:password andCompletion:^(NSError * _Nullable error) {
        if (nil != error) {
            [self.presentedViewController showAlertWithMessage:NSLocalizedString(@"Error Signing Up", nil) andError:error];
            return;
        }

        [self.bcmAppDelegate loadMainPanel];
    }];
}

@end
