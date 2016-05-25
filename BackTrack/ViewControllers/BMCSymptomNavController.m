#import "BMCSymptomNavController.h"
#import <CareKit/CareKit.h>
#import "BCMMainTabController.h"
#import "UIViewController+BCM.h"
#import "BCMTasks.h"
#import "OCKCarePlanEvent+BCM.h"
#import <ResearchKit/ResearchKit.h>
#import <CareKit/CareKit.h>

@interface BMCSymptomNavController ()<OCKSymptomTrackerViewControllerDelegate, ORKTaskViewControllerDelegate>

@property (nonatomic, nonnull) OCKSymptomTrackerViewController *symptomViewController;

@end

@implementation BMCSymptomNavController

#pragma mark Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showViewController:self.symptomViewController sender:nil];
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
    if (reason != ORKTaskViewControllerFinishReasonCompleted) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }

    OCKCarePlanEvent *event = self.symptomViewController.lastSelectedAssessmentEvent;
    ORKTaskResult *taskResult = taskViewController.result;

    NSAssert(nil != event &&
              nil != taskResult &&
              [event.activity.identifier isEqualToString:taskResult.identifier],
             @"Expected care plan event and task result identifier to match. Got %@ and %@", event.activity.identifier, taskResult.identifier);

    OCKCarePlanEventResult *result = [BCMTasks carePlanResultForTaskResult:taskResult];
    if (nil == result) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }

    [self.bcmTabBarController.carePlanStore updateEvent:event withResult:result state:OCKCarePlanEventStateCompleted completion:^(BOOL success, OCKCarePlanEvent * _Nullable event, NSError * _Nullable error) {
        if (!success) {
            NSLog(@"Failed to update event store: %@", error.localizedDescription);
            return;
        }
    }];

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Getters-Setters

- (OCKSymptomTrackerViewController *)symptomViewController
{
    if (nil == _symptomViewController) {
        _symptomViewController = [[OCKSymptomTrackerViewController alloc] initWithCarePlanStore:self.bcmTabBarController.carePlanStore];
        _symptomViewController.delegate = self;
    }

    return _symptomViewController;
}


@end
