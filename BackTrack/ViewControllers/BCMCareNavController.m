#import "BCMCareNavController.h"
#import "UIViewController+BCM.h"
#import "BCMMainTabController.h"
#import "UIColor+BCM.h"
#import <CareKit/CareKit.h>

@interface BCMCareNavController ()

@end

@implementation BCMCareNavController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationBar.tintColor = [UIColor bcmBlueColor];

    OCKCareCardViewController *careViewController = [[OCKCareCardViewController alloc] initWithCarePlanStore:self.bcmTabBarController.carePlanStore];
    careViewController.navigationItem.title = NSLocalizedString(@"Care Plan", nil);
    [self showViewController:careViewController sender:nil];
}

@end
