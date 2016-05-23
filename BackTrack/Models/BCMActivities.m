#import "BCMActivities.h"

@implementation BCMActivities

#pragma mark Public

+ (NSArray<OCKCarePlanActivity *> *)activities
{
    return @[self.hamstringStretchIntervention];
}

#pragma mark Generators

+ (OCKCarePlanActivity *_Nonnull)hamstringStretchIntervention
{
    NSDateComponents *components = [[NSCalendar currentCalendar] componentsInTimeZone:[NSTimeZone defaultTimeZone] fromDate:[NSDate new]];
    OCKCareSchedule *schedule = [OCKCareSchedule dailyScheduleWithStartDate:components occurrencesPerDay:3];

    return [[OCKCarePlanActivity alloc] initWithIdentifier:@"BCMHamstringStretch"
                                           groupIdentifier:@"BCMExerciseInterventions"
                                                      type:OCKCarePlanActivityTypeIntervention
                                                     title:NSLocalizedString(@"Hamstring Stretch", nil)
                                                      text:nil
                                                 tintColor:nil
                                              instructions:nil
                                                  imageURL:nil
                                                  schedule:schedule
                                          resultResettable:YES
                                                  userInfo:nil];
        }

@end
