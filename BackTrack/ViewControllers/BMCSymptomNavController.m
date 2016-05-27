#import "BMCSymptomNavController.h"
#import <CareKit/CareKit.h>
#import "BCMMainTabController.h"
#import "UIViewController+BCM.h"
#import "BCMTasks.h"
#import "OCKCarePlanEvent+BCM.h"
#import "UIColor+BCM.h"
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
    self.symptomViewController.progressRingTintColor = [UIColor bcmBlueColor];
    self.symptomViewController.navigationItem.title = NSLocalizedString(@"Symptom Tracker", nil);
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
    taskViewController.view.tintColor = [UIColor bcmBlueColor];
    [self presentViewController:taskViewController animated:YES completion:nil];
}

#pragma mark ORKTaskViewControllerDelegate

- (void)taskViewController:(ORKTaskViewController *)taskViewController didFinishWithReason:(ORKTaskViewControllerFinishReason)reason error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (reason != ORKTaskViewControllerFinishReasonCompleted) {
        return;
    }

    OCKCarePlanEvent *event = self.symptomViewController.lastSelectedAssessmentEvent;
    ORKTaskResult *taskResult = taskViewController.result;

    NSAssert(nil != event &&
              nil != taskResult &&
              [event.activity.identifier isEqualToString:taskResult.identifier],
             @"Expected care plan event and task result identifier to match. Got %@ and %@", event.activity.identifier, taskResult.identifier);

    [self completeEvent:event
             withResult:[BCMTasks carePlanResultForTaskResult:taskResult]];
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

#pragma mark Helpers

- (void)completeEvent:(OCKCarePlanEvent *_Nonnull)event withResult:(OCKCarePlanEventResult *_Nullable)result
{
    if (nil == result) {
        return;
    }

    [self.bcmTabBarController.carePlanStore updateEvent:event withResult:result state:OCKCarePlanEventStateCompleted completion:^(BOOL success, OCKCarePlanEvent * _Nullable event, NSError * _Nullable error) {
        if (!success) {
            NSLog(@"Failed to update event store: %@", error.localizedDescription);
            return;
        }
    }];
}

@end
