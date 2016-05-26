#import "BCMInsightsNavController.h"
#import <CareKit/CareKit.h>
#import "UIViewController+BCM.h"
#import "BCMMainTabController.h"
#import "BCMActivities.h"

typedef void(^BCMHamstringCountCompletion)(NSInteger hamstringCount);

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
    [self fetchHamstringCountWithCompletion:^(NSInteger hamstringCount) {
        NSString *message = [NSString localizedStringWithFormat:@"You've completed %li hamstring stretches over the past week", hamstringCount];

        OCKMessageItem *hamstringMessage = [[OCKMessageItem alloc] initWithTitle:NSLocalizedString(@"Hamstring Stretches", nil)
                                                                            text:message
                                                                       tintColor:nil
                                                                     messageType:OCKMessageItemTypeAlert];
        self.insightsVC.items = @[hamstringMessage];

        [self fetchPain];
    }];
}

- (void)fetchHamstringCountWithCompletion:(BCMHamstringCountCompletion)block
{
    __block NSInteger hamstringCount = 0;

    [self.bcmTabBarController.carePlanStore enumerateEventsOfActivity:BCMActivities.hamstringStretchIntervention
                                                            startDate:[BCMInsightsNavController weekAgo]
                                                              endDate:[[NSDateComponents alloc] initWithDate:[NSDate new] calendar:[NSCalendar currentCalendar]]
                                                              handler:^(OCKCarePlanEvent * _Nullable event, BOOL * _Nonnull stop) {
         if (event.state != OCKCarePlanEventStateCompleted) {
             return;
         }

         hamstringCount += 1;

     } completion:^(BOOL completed, NSError * _Nullable error) {
         block(hamstringCount);
     }];
}

- (void)fetchPain
{
    NSMutableArray <NSNumber *>*painValues = [NSMutableArray new];
    NSMutableArray <NSString *>*painLabels = [NSMutableArray new];
    NSMutableArray <NSString *>*axisLabels = [NSMutableArray new];

    [self.bcmTabBarController.carePlanStore enumerateEventsOfActivity:BCMActivities.painTrackAssessment
                                                            startDate:[BCMInsightsNavController weekAgo]
                                                              endDate:[BCMInsightsNavController tomorrow]
                                                              handler:^(OCKCarePlanEvent * _Nullable event, BOOL * _Nonnull stop)
    {
        NSDateFormatter *dayFormatter = [NSDateFormatter new];
        dayFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"Md" options:0 locale:dayFormatter.locale];
        NSString *dayString = [dayFormatter stringFromDate:[[NSCalendar currentCalendar] dateFromComponents:event.date]];
        [axisLabels addObject:dayString];

        if (event.state != OCKCarePlanEventStateCompleted) {
            [painValues addObject:@0];
            [painLabels addObject:@"N/A"];
            return;
        }

        NSNumberFormatter *numForatter = [NSNumberFormatter new];
        numForatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *weight = [numForatter numberFromString:event.result.valueString];

        [painValues addObject:weight];
        [painLabels addObject:event.result.valueString];

    } completion:^(BOOL completed, NSError * _Nullable error) {
        OCKBarSeries *painSeries = [[OCKBarSeries alloc] initWithTitle:@"Pain"
                                                                values:[painValues copy]
                                                           valueLabels:[painLabels copy]
                                                             tintColor:nil];

        OCKBarChart *barChart = [[OCKBarChart alloc] initWithTitle:@"Pain Chart"
                                                              text:nil
                                                         tintColor:nil
                                                        axisTitles:[axisLabels copy]
                                                     axisSubtitles:nil
                                                        dataSeries:@[painSeries]];

        self.insightsVC.items = @[barChart];
    }];
}

+ (NSDateComponents *_Nonnull)weekAgo
{
    NSDate *weekAgoIsh = [NSDate dateWithTimeIntervalSinceNow:-7*24*60*60];
    return [[NSDateComponents alloc] initWithDate:weekAgoIsh calendar:[NSCalendar currentCalendar]];
}

+ (NSDateComponents *_Nonnull)tomorrow
{
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:24*60*60];
    return [[NSDateComponents alloc] initWithDate:yesterday calendar:[NSCalendar currentCalendar]];
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
