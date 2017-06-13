#import "BCMCareNavController.h"
#import <CareKit/CareKit.h>
#import "UIViewController+BCM.h"
#import "BCMMainTabController.h"
#import "UIColor+BCM.h"
#import "BCMMainThread.h"

@interface BCMCareNavController ()

@property (nonatomic) OCKCareContentsViewController *careContentsViewController;

@end

@implementation BCMCareNavController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationBar.tintColor = [UIColor bcmBlueColor];
    [self reloadCareViewController];
}

- (void)reloadCareViewController
{
    on_main_thread(^{
        self.careContentsViewController = [[OCKCareContentsViewController alloc] initWithCarePlanStore:self.bcmTabBarController.carePlanStore];
        self.careContentsViewController.navigationItem.title = NSLocalizedString(@"Care Plan", nil);
        self.viewControllers = @[self.careContentsViewController];
    });
}

@end
