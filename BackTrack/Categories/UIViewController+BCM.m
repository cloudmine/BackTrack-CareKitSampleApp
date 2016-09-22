#import "UIViewController+BCM.h"
#import "BCMMainTabController.h"
#import "BCMMainThread.h"
#import "BCMAppDelegate.h"

@implementation UIViewController (BCM)

- (BCMMainTabController *)bcmTabBarController
{
    for (UIViewController *vc = self; nil != vc; vc = vc.parentViewController) {
        if ([vc isKindOfClass:[BCMMainTabController class]]) {
            return (BCMMainTabController *)vc;
        }
    }

    return nil;
}

- (BCMAppDelegate *)bcmAppDelegate
{
    id<UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;
    NSAssert([delegate isKindOfClass:[BCMAppDelegate class]], @"App Delegate was of class %@ instead of %@", [delegate class], [BCMAppDelegate class]);
    return (BCMAppDelegate *)delegate;
}

- (void)showAlertWithMessage:(NSString *_Nonnull)message andError:(NSError *_Nullable)error
{
    NSString *composedMessage = message;

    if (nil != error && nil != error.localizedDescription) {
        composedMessage = [NSString stringWithFormat:@"%@; %@", composedMessage, error.localizedDescription];
    }

    on_main_thread(^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:composedMessage
                                                                preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) { }];
        [alert addAction:okAction];

        [self presentViewController:alert animated:YES completion:nil];
    });
}

@end
