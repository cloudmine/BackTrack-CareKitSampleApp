#import "BCMCareNavController.h"
#import <CareKit/CareKit.h>
#import "UIViewController+BCM.h"
#import "BCMMainTabController.h"
#import "UIColor+BCM.h"
#import "BCMMainThread.h"

@interface BCMCareNavController ()

@end

@implementation BCMCareNavController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationBar.tintColor = [UIColor bcmBlueColor];
    [self reloadCareViewController];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCareViewController) name:BCMStoreDidReloadEventData object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BCMStoreDidReloadEventData object:nil];
}

- (void)reloadCareViewController
{
    on_main_thread(^{
        OCKCareCardViewController *careViewController = [[OCKCareCardViewController alloc] initWithCarePlanStore:self.bcmTabBarController.carePlanStore];
        careViewController.navigationItem.title = NSLocalizedString(@"Care Plan", nil);
        self.viewControllers = @[careViewController];
    });
}

@end
