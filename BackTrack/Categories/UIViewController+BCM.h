#import <UIKit/UIKit.h>

@class BCMMainTabController;

@interface UIViewController (BCM)

@property (nonatomic, readonly, nullable) BCMMainTabController *bcmTabBarController;

- (void)showAlertWithMessage:(NSString *_Nonnull)message andError:(NSError *_Nullable)error;

@end
