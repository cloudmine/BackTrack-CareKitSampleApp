#import "BCMProfileViewController.h"
#import <CMHealth/CMHealth.h>
#import <MessageUI/MessageUI.h>
#import "UIViewController+BCM.h"
#import "BCMAppDelegate.h"
#import "BCMMainTabController.h"
#import "UIButton+BCM.h"
#import "BCMMainThread.h"
#import "BCMFirstStartTracker.h"
#import "UIImage+BCM.h"
#import "UIColor+BCM.h"

@interface BCMProfileViewController ()<MFMailComposeViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *profileImageActivityIndicator;
@property (strong, nonatomic) IBOutlet UIButton *updateProfileButton;
@property (nonatomic, nullable) MFMailComposeViewController *mailViewController;
@end

@implementation BCMProfileViewController

#pragma mark Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[CMHUser currentUser] addObserver:self forKeyPath:@"userData" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:nil];

    [self.logOutButton setCornerRadius:4.0f andBorderWidth:1.0f];
    
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth = 1.5f;
    self.profileImageView.layer.borderColor = [UIColor bcmBlueColor].CGColor;
    self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width / 2.0f;
    
    self.mailViewController = [BCMProfileViewController mailComposeViewControllerWithDelegate:self];
    
    [self fetchAndShowProfilePhoto];
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
            self.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", [CMHUser currentUser].userData.givenName, [CMHUser currentUser].userData.familyName];
        });
    }
}

#pragma mark Target-Action
- (IBAction)didPressUpdateProfilePhotoButton:(UIButton *)sender
{
    [self requestProfilePhoto];
}

- (IBAction)didPressLogoutButton:(UIButton *)sender
{
    [self confirmAndLogout];
}

- (IBAction)didPressWebsiteButton:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://cloudmineinc.com"] options:@{} completionHandler:nil];
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

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *pickedImage = info[UIImagePickerControllerOriginalImage];
    if (nil == pickedImage) {
        return;
    }
    
    [self cropAndUploadProfileImage:pickedImage];
}

#pragma mark Private

- (void)requestProfilePhoto
{
    UIAlertController *photoTypeAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Update Profile Photo", nil)
                                                                            message:nil
                                                                     preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {}];
    [photoTypeAlert addAction:cancelAction];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Camera", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showImagePickerForType:UIImagePickerControllerSourceTypeCamera];
        }];
        
        [photoTypeAlert addAction:cameraAction];
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Photo Library", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showImagePickerForType:UIImagePickerControllerSourceTypePhotoLibrary];
        }];
        
        [photoTypeAlert addAction:libraryAction];
    }
    
    if (photoTypeAlert.actions.count > 1) {
        [self presentViewController:photoTypeAlert animated:YES completion:nil];
    }
}

- (void)showImagePickerForType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.sourceType = sourceType;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)cropAndUploadProfileImage:(UIImage *)image
{
    on_main_thread(^{
        [self.profileImageActivityIndicator startAnimating];
    });
    
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(backgroundQueue, ^{
        UIImage *croppedImage = [UIImage imageSquareCroppingImage:image toSideLength:200.0f];
        if (nil == croppedImage) {
            [self showAlertWithMessage:NSLocalizedString(@"Failed to crop the selected image", nil) andError:nil];
            on_main_thread(^{
                [self.profileImageActivityIndicator stopAnimating];
            });
            return;
        }
        
        [[CMHUser currentUser] uploadProfileImage:croppedImage withCompletion:^(BOOL success, NSError * _Nullable error) {
            if (!success) {
                [self showAlertWithMessage:NSLocalizedString(@"Failed to upload profile image", nil) andError:error];
                on_main_thread(^{
                    [self.profileImageActivityIndicator stopAnimating];
                });
                return;
            }
            
            [self fetchAndShowProfilePhoto];
        }];
    });
}

- (void)fetchAndShowProfilePhoto
{
    on_main_thread(^{
        [self.profileImageActivityIndicator startAnimating];
    });
    
    [[CMHUser currentUser] fetchProfileImageWithCompletion:^(BOOL success, UIImage *image, NSError *error) {
        if (!success) {
            NSLog(@"[CMHealth] Error fetching profile image: %@", error.localizedDescription);
        }
        
        if (nil == image) {
            image = [UIImage imageNamed:@"ProfilePlaceholder"];
        }
        
        on_main_thread(^{
            [self.profileImageActivityIndicator stopAnimating];
            self.profileImageView.image = image;
        });
    }];
}

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
