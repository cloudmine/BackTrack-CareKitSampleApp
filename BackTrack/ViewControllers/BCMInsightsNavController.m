#import "BCMInsightsNavController.h"
#import <CareKit/CareKit.h>
#import "UIViewController+BCM.h"
#import "BCMMainTabController.h"
#import "BCMActivities.h"

@interface BCMInsightsNavController ()
@property (nonatomic, nonnull) OCKInsightsViewController *insightsVC;
@end

@implementation BCMInsightsNavController

#pragma mark Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

//    OCKMessageItem *testMessage = [[OCKMessageItem alloc] initWithTitle:NSLocalizedString(@"Perform your exercises!", nil)
//                                                                   text:NSLocalizedString(@"Staying active is the number one way to mitigate your pain", nil)
//                                                              tintColor:nil
//                                                            messageType:OCKMessageItemTypeTip];
//    self.insightsVC.items = @[testMessage];
    [self showViewController:self.insightsVC sender:nil];

    [self fetchInsights];
}

- (void)fetchInsights
{
    __block NSInteger hamstringCount = 0;

    [self.bcmTabBarController.carePlanStore enumerateEventsOfActivity:BCMActivities.hamstringStretchIntervention
                                                            startDate:[BCMInsightsNavController weekAgo]
                                                              endDate:[[NSDateComponents alloc] initWithDate:[NSDate new] calendar:[NSCalendar currentCalendar]]
                                                              handler:^(OCKCarePlanEvent * _Nullable event, BOOL * _Nonnull stop)
    {
        if (event.state != OCKCarePlanEventStateCompleted) {
            return;
        }
        
        hamstringCount += 1;
        
    } completion:^(BOOL completed, NSError * _Nullable error) {
        NSString *message = [NSString localizedStringWithFormat:@"You've completed %li hamstring stretches over the past week", hamstringCount];

        OCKMessageItem *hamstringMessage = [[OCKMessageItem alloc] initWithTitle:NSLocalizedString(@"Hamstring Stretches", nil)
                                                                            text:message
                                                                       tintColor:nil
                                                                     messageType:OCKMessageItemTypeAlert];
        self.insightsVC.items = @[hamstringMessage];
    }];
}

+ (NSDateComponents *_Nonnull)weekAgo
{
    NSDate *weekAgoIsh = [NSDate dateWithTimeIntervalSinceNow:-7*24*60*60];
    return [[NSDateComponents alloc] initWithDate:weekAgoIsh calendar:[NSCalendar currentCalendar]];
}

-  (OCKInsightsViewController *)insightsVC
{
    if (nil == _insightsVC) {
        _insightsVC = [[OCKInsightsViewController alloc] initWithInsightItems:@[]
                                                                  headerTitle:NSLocalizedString(@"Treatment Insights", nil)
                                                               headerSubtitle:NSLocalizedString(@"Data from your treatment over the last week", nil)];
    }

    return _insightsVC;
}

@end
