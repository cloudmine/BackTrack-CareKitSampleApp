#import "BCMCareNavController.h"
#import "UIViewController+BCM.h"
#import "BCMMainTabController.h"
#import <CareKit/CareKit.h>

@interface BCMCareNavController ()

@end

@implementation BCMCareNavController

- (void)viewDidLoad
{
    [super viewDidLoad];

    OCKCareCardViewController *careVC = [[OCKCareCardViewController alloc] initWithCarePlanStore:self.bcmTabBarController.carePlanStore];

    [self showViewController:careVC sender:nil];
}

@end
