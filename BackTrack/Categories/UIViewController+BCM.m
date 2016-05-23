#import "UIViewController+BCM.h"
#import "BCMMainTabController.h"

@implementation UIViewController (BCM)

- (BCMMainTabController *)bcmTabBarController
{
    for (UIViewController *vc = self; nil != vc.parentViewController; vc = vc.parentViewController) {
        if ([vc isKindOfClass:[BCMMainTabController class]]) {
            return (BCMMainTabController *)vc;
        }
    }

    return nil;
}

@end