#import "BCMInsightBuilder.h"
#import "BCMActivities.h"
#import "NSDateComponents+BCM.h"

typedef void(^BCMInsightValuesCompletion)(OCKBarSeries *_Nullable series, NSArray <NSString *> *_Nullable axisLabels,
                                          NSArray <NSString *> *_Nullable axisSubs, NSError *_Nullable error);

@implementation BCMInsightBuilder

#pragma mark Public

+ (void)fetchInsightsFromStore:(OCKCarePlanStore *_Nonnull)store withCompletion:(_Nonnull BCMBuildInsightsCompletion)block
{
    NSMutableArray<OCKInsightItem *> *allItems = [NSMutableArray new];

    [self fetchHamstringCountFromStore:store withCompletion:^(NSArray<OCKInsightItem *> * _Nonnull hamstringItems) {

        [allItems addObjectsFromArray:hamstringItems];

        [self fetchPainFromStore:store withCompletion:^(NSArray<OCKInsightItem *> * _Nonnull painItems) {
            [allItems addObjectsFromArray:painItems];

            block([allItems copy]);
        }];
    }];
}

+ (void)fetchHamstringCountFromStore:(OCKCarePlanStore *_Nonnull)store withCompletion:(_Nonnull BCMBuildInsightsCompletion)block
{
    __block NSInteger hamstringCount = 0;

    [store enumerateEventsOfActivity:BCMActivities.hamstringStretchIntervention
                                                            startDate:[NSDateComponents weekAgoComponents]
                                                              endDate:[NSDateComponents tomorrowComponents]
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
        block(@[hamstringMessage]);
    }];
}

+ (void)fetchPainFromStore:(OCKCarePlanStore *_Nonnull)store withCompletion:(_Nonnull BCMBuildInsightsCompletion)block
{
    [self fetchDailySeriesForActivity:BCMActivities.painTrackAssessment
                            fromStore:store
                       withCompletion:^(OCKBarSeries * _Nullable series, NSArray<NSString *> * _Nullable axisLabels,
                                        NSArray<NSString *> * _Nullable axisSubs, NSError * _Nullable error)
    {
        if (nil != error) {
            NSLog(@"Error fetching insight data: %@", error.localizedDescription);
            return;
        }

        OCKBarChart *barChart = [[OCKBarChart alloc] initWithTitle:NSLocalizedString(@"Pain Chart", nil)
                                                              text:nil
                                                         tintColor:nil
                                                        axisTitles:axisLabels
                                                     axisSubtitles:nil
                                                        dataSeries:@[series]];
        block(@[barChart]);
    }];
}

+ (void)fetchDailySeriesForActivity:(OCKCarePlanActivity *_Nonnull)activity
                          fromStore:(OCKCarePlanStore *_Nonnull)store
                     withCompletion:(_Nonnull BCMInsightValuesCompletion)block
{
    NSMutableArray <NSNumber *>*values = [NSMutableArray new];
    NSMutableArray <NSString *>*labels = [NSMutableArray new];
    NSMutableArray <NSString *>*axisLabels = [NSMutableArray new];
    NSMutableArray <NSString *>*axisSubs = [NSMutableArray new];

    [store enumerateEventsOfActivity:activity
                           startDate:[NSDateComponents weekAgoComponents]
                             endDate:[NSDateComponents tomorrowComponents]
                             handler:^(OCKCarePlanEvent * _Nullable event, BOOL * _Nonnull stop)
     {
         NSDateFormatter *dayFormatter = [NSDateFormatter new];
         dayFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"Md" options:0 locale:dayFormatter.locale];
         NSString *dayString = [dayFormatter stringFromDate:[[NSCalendar currentCalendar] dateFromComponents:event.date]];
         [axisLabels addObject:dayString];

         if (event.state != OCKCarePlanEventStateCompleted) {
             [values addObject:@0];
             [labels addObject:@"N/A"];
             return;
         }

         NSNumberFormatter *numForatter = [NSNumberFormatter new];
         numForatter.numberStyle = NSNumberFormatterDecimalStyle;
         NSNumber *aValue = [numForatter numberFromString:event.result.valueString];

         [values addObject:aValue];
         [labels addObject:event.result.valueString];

     } completion:^(BOOL completed, NSError * _Nullable error) {
         if (!completed) {
             block(nil, nil, nil, error);
             return;
         }

         OCKBarSeries *series = [[OCKBarSeries alloc] initWithTitle:@"Pain"
                                                                 values:[values copy]
                                                            valueLabels:[labels copy]
                                                              tintColor:nil];
         block(series, [axisLabels copy], [axisSubs copy], nil);
     }];
}

@end
