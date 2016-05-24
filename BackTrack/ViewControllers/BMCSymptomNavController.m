#import "BMCSymptomNavController.h"
#import <CareKit/CareKit.h>
#import "BCMMainTabController.h"
#import "UIViewController+BCM.h"
#import <CareKit/CareKit.h>

@interface BMCSymptomNavController ()<OCKSymptomTrackerViewControllerDelegate>

@end

@implementation BMCSymptomNavController

#pragma mark Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    OCKSymptomTrackerViewController *symptomVC = [[OCKSymptomTrackerViewController alloc] initWithCarePlanStore:self.bcmTabBarController.carePlanStore];
    symptomVC.delegate = self;
    [self showViewController:symptomVC sender:nil];
}

#pragma mark OCKSymptomTrackerViewControllerDelegate

- (void)symptomTrackerViewController:(OCKSymptomTrackerViewController *)viewController didSelectRowWithAssessmentEvent:(OCKCarePlanEvent *)assessmentEvent
{
    NSLog(@"Selected Assessment: %@", assessmentEvent.activity.identifier);
}

@end
