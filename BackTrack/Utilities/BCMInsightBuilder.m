#import "BCMInsightBuilder.h"
#import "BCMActivities.h"
#import "NSDateComponents+BCM.h"

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
    NSMutableArray <NSNumber *>*painValues = [NSMutableArray new];
    NSMutableArray <NSString *>*painLabels = [NSMutableArray new];
    NSMutableArray <NSString *>*axisLabels = [NSMutableArray new];

    [store enumerateEventsOfActivity:BCMActivities.painTrackAssessment
                                                            startDate:[NSDateComponents weekAgoComponents]
                                                              endDate:[NSDateComponents tomorrowComponents]
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
         block(@[barChart]);
     }];
}

@end
