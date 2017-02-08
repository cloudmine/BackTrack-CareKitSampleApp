#import "BCMProfileViewController.h"
#import <CMHealth/CMHealth.h>
#import <MessageUI/MessageUI.h>
#import "UIViewController+BCM.h"
#import "BCMAppDelegate.h"
#import "BCMMainTabController.h"
#import "UIButton+BCM.h"
#import "BCMMainThread.h"
#import "BCMFirstStartTracker.h"

@interface BCMProfileViewController ()<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;
@property (nonatomic, nullable) MFMailComposeViewController *mailViewController;
@end

@implementation BCMProfileViewController

#pragma mark Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[CMHUser currentUser] addObserver:self forKeyPath:@"userData" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:nil];

    [self.logOutButton setCornerRadius:4.0f andBorderWidth:1.0f];
    self.mailViewController = [BCMProfileViewController mailComposeViewControllerWithDelegate:self];
}

- (void)dealloc
{
    [[CMHUser currentUser] removeObserver:self forKeyPath:@"userData"];
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == [CMHUser currentUser] && [@"userData" isEqualToString:keyPath]) {
        on_main_thread(^{
            self.userEmailLabel.text = [CMHUser currentUser].userData.email;
        });
    }
}

#pragma mark Target-Action

- (IBAction)didPressLogoutButton:(UIButton *)sender
{
    [self confirmAndLogout];
}

- (IBAction)didPressWebsiteButton:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://cloudmineinc.com"]];
}

- (IBAction)didPressEmailButton:(UIButton *)sender
{
    if (nil == self.mailViewController) {
        [self showAlertWithMessage:NSLocalizedString(@"The mail app is not configured on your device.", nil) andError:nil];
        return;
    }

    [self presentViewController:self.mailViewController animated:YES completion:nil];
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultFailed) {
        [self.presentedViewController showAlertWithMessage:NSLocalizedString(@"Something went wrong sending your message", nil) andError:error];
        return;
    }

    [self dismissViewControllerAnimated:YES completion:nil];

    if (result != MFMailComposeResultSent) {
        return;
    }

    [self showAlertWithMessage:NSLocalizedString(@"Thanks for reaching out! Someone will get back to your shortly.", nil) andError:error];
}

#pragma mark Private

- (void)confirmAndLogout
{
    UIAlertController *logoutAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Are you sure you want to log out?", nil)
                                                                         message:nil
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) { }];

    UIAlertAction *logout = [UIAlertAction actionWithTitle:NSLocalizedString(@"Log Out", nil)
                                                     style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [self logUserOut];
                                                   }];

    [logoutAlert addAction:cancel];
    [logoutAlert addAction:logout];

    [self presentViewController:logoutAlert animated:YES completion:nil];
}

- (void)logUserOut
{
    [[CMHUser currentUser] logoutWithCompletion:^(NSError * _Nullable error) {
        if (nil != error) {
            [self showAlertWithMessage:NSLocalizedString(@"Something went wrong logging out", nil) andError:error];
            return;
        }

        [BCMFirstStartTracker forgetFirstStart];
        [self.bcmTabBarController.carePlanStore clearLocalStore];
        
        [self.bcmAppDelegate loadAuthentication];
    }];
}

+ (MFMailComposeViewController *)mailComposeViewControllerWithDelegate:(id<MFMailComposeViewControllerDelegate>)delegate
{
    if (![MFMailComposeViewController canSendMail]) {
        return nil;
    }

    MFMailComposeViewController* composeVC = [MFMailComposeViewController new];
    composeVC.mailComposeDelegate = delegate;
    [composeVC setToRecipients:@[@"sales@cloudmineinc.com"]];
    [composeVC setSubject:@"CHC inquiry - BackTrack"];
    [composeVC setMessageBody:@"I would like to learn more about CareKit and the CloudMine Connected Health Cloud." isHTML:NO];

    return composeVC;
}

@end
