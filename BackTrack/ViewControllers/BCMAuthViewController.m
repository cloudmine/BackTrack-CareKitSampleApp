#import "BCMAuthViewController.h"
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
    NSLog(@"Auth Complete");
}

@end
