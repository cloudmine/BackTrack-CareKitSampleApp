#import "BMCSymptomNavController.h"
#import <CareKit/CareKit.h>
#import "BCMMainTabController.h"
#import "UIViewController+BCM.h"
#import "BCMTasks.h"
#import "OCKCarePlanEvent+BCM.h"
#import <ResearchKit/ResearchKit.h>
#import <CareKit/CareKit.h>

@interface BMCSymptomNavController ()<OCKSymptomTrackerViewControllerDelegate, ORKTaskViewControllerDelegate>

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

    if (![assessmentEvent isAvailable]) {
        return;
    }

    ORKOrderedTask *task = [BCMTasks taskForAssessmentIdentifier:assessmentEvent.activity.identifier];
    if (nil == task) {
        return;
    }

    ORKTaskViewController *taskViewController = [[ORKTaskViewController alloc] initWithTask:task taskRunUUID:nil];
    taskViewController.delegate = self;
    [self presentViewController:taskViewController animated:YES completion:nil];
}

#pragma mark ORKTaskViewControllerDelegate

- (void)taskViewController:(ORKTaskViewController *)taskViewController didFinishWithReason:(ORKTaskViewControllerFinishReason)reason error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
