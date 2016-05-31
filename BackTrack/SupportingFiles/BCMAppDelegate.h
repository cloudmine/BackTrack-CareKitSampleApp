#import <UIKit/UIKit.h>

@interface BCMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)loadAuthentication;
- (void)loadMainPanel;

@end

