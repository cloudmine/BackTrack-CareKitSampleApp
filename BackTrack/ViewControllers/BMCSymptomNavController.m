#import "BMCSymptomNavController.h"
#import <CareKit/CareKit.h>
#import "BCMMainTabController.h"
#import "UIViewController+BCM.h"

@interface BMCSymptomNavController ()

@end

@implementation BMCSymptomNavController

- (void)viewDidLoad
{
    [super viewDidLoad];

    OCKSymptomTrackerViewController *symptomVC = [[OCKSymptomTrackerViewController alloc] initWithCarePlanStore:self.bcmTabBarController.carePlanStore];

    [self showViewController:symptomVC sender:nil];
}

@end
