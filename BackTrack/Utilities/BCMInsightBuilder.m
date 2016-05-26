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

        [self fetchChartInsightsFromStore:store withCompletion:^(NSArray<OCKInsightItem *> * _Nonnull chartItems) {
            [allItems addObjectsFromArray:chartItems];

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
        NSString *message = [NSString localizedStringWithFormat:@"You've completed %li hamstring stretches over the past week", (long)hamstringCount];

        OCKMessageItem *hamstringMessage = [[OCKMessageItem alloc] initWithTitle:NSLocalizedString(@"Hamstring Stretches", nil)
                                                                            text:message
                                                                       tintColor:nil
                                                                     messageType:OCKMessageItemTypeAlert];
        block(@[hamstringMessage]);
    }];
}

// This assumes that data comes out in order, consistently. Neither of these assumptions is documented as guarenteed
// so this isn't really safe.
+ (void)fetchChartInsightsFromStore:(OCKCarePlanStore *_Nonnull)store withCompletion:(_Nonnull BCMBuildInsightsCompletion)block
{
    [self fetchDailySeriesForActivity:BCMActivities.painTrackAssessment
                            fromStore:store
                            withTitle:NSLocalizedString(@"Pain", nil)
                            tintColor:[UIColor redColor]
                        andCompletion:^(OCKBarSeries * _Nullable painSeries, NSArray<NSString *> * _Nullable axisLabels,
                                        NSArray<NSString *> * _Nullable axisSubs, NSError * _Nullable painError)
    {
        if (nil != painError) {
            NSLog(@"Error fetching pain insight data: %@", painError.localizedDescription);
            return;
        }

        [self fetchDailySeriesForActivity:BCMActivities.moodTrackAssessment
                                fromStore:store
                                withTitle:NSLocalizedString(@"Mood", nil)
                                tintColor:nil
                            andCompletion:^(OCKBarSeries * _Nullable moodSeries, NSArray<NSString *> * _Nullable _axisLables,
                                            NSArray<NSString *> * _Nullable _axisSubs, NSError * _Nullable moodError)
        {
            if (nil != moodError) {
                NSLog(@"Error fetching weight insight data: %@", moodError.localizedDescription);
                return;
            }

            OCKBarChart *barChart = [[OCKBarChart alloc] initWithTitle:NSLocalizedString(@"Pain vs. Mood", nil)
                                                                  text:NSLocalizedString(@"", nil)
                                                             tintColor:nil
                                                            axisTitles:axisLabels
                                                         axisSubtitles:axisSubs
                                                            dataSeries:@[painSeries, moodSeries]];
            block(@[barChart]);
        }];
    }];
}

+ (void)fetchDailySeriesForActivity:(OCKCarePlanActivity *_Nonnull)activity
                          fromStore:(OCKCarePlanStore *_Nonnull)store
                          withTitle:(NSString *_Nonnull)title
                          tintColor:(UIColor *_Nullable)color
                      andCompletion:(_Nonnull BCMInsightValuesCompletion)block
{
    NSMutableArray <NSNumber *>*values = [NSMutableArray new];
    NSMutableArray <NSString *>*labels = [NSMutableArray new];
    NSMutableArray <NSString *>*axisLabels = [NSMutableArray new];
    NSMutableArray <NSString *>*axisSubs = [NSMutableArray new];

    NSDateFormatter *dayFormatter = [NSDateFormatter new];
    dayFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"Md" options:0 locale:dayFormatter.locale];
    NSDateFormatter *nameFormatter = [NSDateFormatter new];
    nameFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"E" options:0 locale:dayFormatter.locale];


    [store enumerateEventsOfActivity:activity
                           startDate:[NSDateComponents weekAgoComponents]
                             endDate:[NSDateComponents tomorrowComponents]
                             handler:^(OCKCarePlanEvent * _Nullable event, BOOL * _Nonnull stop)
     {

         NSString *dayString = [dayFormatter stringFromDate:[[NSCalendar currentCalendar] dateFromComponents:event.date]];
         [axisLabels addObject:dayString];
         NSString *nameString = [nameFormatter stringFromDate:[[NSCalendar currentCalendar] dateFromComponents:event.date]];
         [axisSubs addObject:nameString];

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

         OCKBarSeries *series = [[OCKBarSeries alloc] initWithTitle:title
                                                                 values:[values copy]
                                                            valueLabels:[labels copy]
                                                              tintColor:color];
         block(series, [axisLabels copy], [axisSubs copy], nil);
     }];
}

@end
