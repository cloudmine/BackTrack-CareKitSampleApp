#import "BCMActivities.h"

static NSString *const ExerciseInterventionsGroupIdentifier = @"BCMExerciseInterventions";

@implementation BCMActivities

#pragma mark Public

+ (NSArray<OCKCarePlanActivity *> *)activities
{
    return @[self.hamstringStretchIntervention, self.briskWalkIntervention];
}

#pragma mark Generators

+ (OCKCarePlanActivity *_Nonnull)hamstringStretchIntervention
{
    OCKCareSchedule *schedule = [OCKCareSchedule dailyScheduleWithStartDate:self.todaysDateComponents occurrencesPerDay:3];

    return [[OCKCarePlanActivity alloc] initWithIdentifier:@"BCMHamstringStretch"
                                           groupIdentifier:ExerciseInterventionsGroupIdentifier
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

+ (OCKCarePlanActivity *_Nonnull)briskWalkIntervention
{
    OCKCareSchedule *schedule = [OCKCareSchedule dailyScheduleWithStartDate:self.todaysDateComponents occurrencesPerDay:1];

    return [[OCKCarePlanActivity alloc] initWithIdentifier:@"BCMBriskWalk"
                                           groupIdentifier:ExerciseInterventionsGroupIdentifier
                                                      type:OCKCarePlanActivityTypeIntervention
                                                     title:NSLocalizedString(@"Brisk Walk", nil)
                                                      text:NSLocalizedString(@"15 minutes", nil)
                                                 tintColor:nil
                                              instructions:nil
                                                  imageURL:nil
                                                  schedule:schedule
                                          resultResettable:YES
                                                  userInfo:nil];
}

#pragma mark Helpers

+ (NSDateComponents *_Nonnull)todaysDateComponents
{
    return [[NSCalendar currentCalendar] componentsInTimeZone:[NSTimeZone defaultTimeZone] fromDate:[NSDate new]];
}

@end
