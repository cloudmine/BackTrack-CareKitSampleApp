#import <UIKit/UIKit.h>

@class BCMMainTabController;
@class BCMAppDelegate;

@interface UIViewController (BCM)

@property (nonatomic, readonly, nullable) BCMMainTabController *bcmTabBarController;
@property (nonatomic, readonly, nullable) BCMAppDelegate *bcmAppDelegate;

- (void)showAlertWithMessage:(NSString *_Nonnull)message andError:(NSError *_Nullable)error;

@end
