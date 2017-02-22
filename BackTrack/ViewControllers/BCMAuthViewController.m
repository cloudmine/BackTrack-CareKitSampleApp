#import <CMHealth/CMHealth.h>
#import "BCMAuthViewController.h"
#import "UIViewController+BCM.h"
#import "UIButton+BCM.h"
#import "BCMAppDelegate.h"
#import "BCMStoreUtils.h"
#import "BCMActivities.h"

@interface BCMAuthViewController ()<CMHLoginViewControllerDelegate, ORKTaskViewControllerDelegate>
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
    ORKRegistrationStepOption registrationOptions = (ORKRegistrationStepDefault|ORKRegistrationStepIncludeGivenName|ORKRegistrationStepIncludeFamilyName);
    ORKRegistrationStep *registrationStep = [[ORKRegistrationStep alloc] initWithIdentifier:@"BCMRegistrationStep"
                                                                                     title:NSLocalizedString(@"Registration", nil)
                                                                                      text:NSLocalizedString(@"Create an account", nil)
                                                                                   options:registrationOptions];

    ORKOrderedTask *registrationTask = [[ORKOrderedTask alloc] initWithIdentifier:@"BMCRegistrationTask" steps:@[registrationStep]];

    ORKTaskViewController *registrationVC = [[ORKTaskViewController alloc] initWithTask:registrationTask taskRunUUID:nil];
    registrationVC.delegate = self;

    [self presentViewController:registrationVC animated:YES completion:nil];
}

- (IBAction)didPressLoginButton:(UIButton *)sender
{
    CMHLoginViewController *loginVC = [[CMHLoginViewController alloc] initWithTitle:NSLocalizedString(@"Log In", nil)
                                                                               text:NSLocalizedString(@"Please log in to you account to store and access your personal health data.", nil)
                                                                           delegate:self];

    [self presentViewController:loginVC animated:YES completion:nil];
}

#pragma mark ORKTaskViewControllerDelegate

- (void)taskViewController:(ORKTaskViewController *)taskViewController didFinishWithReason:(ORKTaskViewControllerFinishReason)reason error:(NSError *)error
{
    if (nil != error) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self.presentedViewController showAlertWithMessage:NSLocalizedString(@"Error During Registration", nil) andError:error];
        }];
        return;
    }

    if (reason != ORKTaskViewControllerFinishReasonCompleted) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }

    [[CMHUser currentUser] signUpWithRegistration:taskViewController.result andCompletion:^(NSError * _Nullable error) {
        if (nil != error) {
            [self.presentedViewController showAlertWithMessage:NSLocalizedString(@"Something went wrong signing up", nil)
                                                      andError:error];
            return;
        }
        
        CMHCarePlanStore *store = [CMHCarePlanStore storeWithPersistenceDirectoryURL:BCMStoreUtils.persistenceDirectory];
        [BCMStoreUtils addActivities:BCMActivities.activities toStore:store];
        
        [self.bcmAppDelegate loadMainPanel];
    }];
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

@end
