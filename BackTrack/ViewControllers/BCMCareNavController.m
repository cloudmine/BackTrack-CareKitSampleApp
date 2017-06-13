#import "BCMCareNavController.h"
#import <CareKit/CareKit.h>
#import "UIViewController+BCM.h"
#import "BCMMainTabController.h"
#import "UIColor+BCM.h"
#import "BCMMainThread.h"
#import "OCKCarePlanEvent+BCM.h"
#import "BCMTasks.h"

@interface BCMCareNavController () <OCKCareContentsViewControllerDelegate, ORKTaskViewControllerDelegate>

@property (nonatomic) OCKCareContentsViewController *careContentsViewController;

@end

@implementation BCMCareNavController


#pragma mark Lifecycle

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
        self.careContentsViewController.delegate = self;
        self.viewControllers = @[self.careContentsViewController];
    });
}

#pragma mark OCKCareContentsViewControllerDelegate

- (void)careContentsViewController:(OCKCareContentsViewController *)viewController didSelectRowWithAssessmentEvent:(OCKCarePlanEvent *)assessmentEvent
{
    NSLog(@"[BCM] Selected Assessment: %@", assessmentEvent.activity.identifier);
    
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
}

@end
