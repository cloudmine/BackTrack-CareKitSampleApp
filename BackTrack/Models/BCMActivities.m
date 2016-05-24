#import "BCMActivities.h"

static NSString *const ExerciseInterventionsGroupIdentifier   = @"BCMExerciseInterventions";
static NSString *const MedicationInterventionsGroupIdentifier = @"BCMMedicationInterventions";
static NSString *const SubjectiveAssessmentsGroupIdentifier   = @"BCMSubjectiveAssessments";
static NSString *const ObjectiveAssessmentsGroupIdentifier    = @"BCMObjectiveAssessments";

@implementation BCMActivities

#pragma mark Public

+ (NSArray<OCKCarePlanActivity *> *)activities
{
    return @[self.hamstringStretchIntervention, self.briskWalkIntervention,
             self.warmCompressIntervention, self.painKillerIntervention,
             self.painTrackAssessment, self.moodTrackAssessment,
             self.weightTrackAssessment];
}

#pragma mark Generators

+ (OCKCarePlanActivity *_Nonnull)hamstringStretchIntervention
{
    OCKCareSchedule *schedule = [OCKCareSchedule dailyScheduleWithStartDate:self.todaysDateComponents occurrencesPerDay:3];

    return [[OCKCarePlanActivity alloc] initWithIdentifier:@"BCMHamstringStretch"
                                           groupIdentifier:ExerciseInterventionsGroupIdentifier
                                                      type:OCKCarePlanActivityTypeIntervention
                                                     title:NSLocalizedString(@"Hamstring Stretch", nil)
                                                      text:NSLocalizedString(@"5 minutes", nil)
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

+ (OCKCarePlanActivity *_Nonnull)warmCompressIntervention
{
    OCKCareSchedule *schedule = [OCKCareSchedule weeklyScheduleWithStartDate:self.todaysDateComponents
                                                        occurrencesOnEachDay:@[@0, @1, @0, @1, @0, @1, @0]]; // Mon/Wed/Fri

    return [[OCKCarePlanActivity alloc] initWithIdentifier:@"BMCWarmCompress"
                                           groupIdentifier:MedicationInterventionsGroupIdentifier
                                                      type:OCKCarePlanActivityTypeIntervention
                                                     title:NSLocalizedString(@"Warm Compress", nil)
                                                      text:NSLocalizedString(@"Morning", nil)
                                                 tintColor:nil
                                              instructions:nil
                                                  imageURL:nil
                                                  schedule:schedule
                                          resultResettable:YES
                                                  userInfo:nil];
}

+ (OCKCarePlanActivity *_Nonnull)painKillerIntervention
{
    OCKCareSchedule *schedule = [OCKCareSchedule dailyScheduleWithStartDate:self.todaysDateComponents
                                                          occurrencesPerDay:2
                                                                 daysToSkip:1
                                                                    endDate:nil];

    return [[OCKCarePlanActivity alloc] initWithIdentifier:@"BCMPainKiller"
                                           groupIdentifier:MedicationInterventionsGroupIdentifier
                                                      type:OCKCarePlanActivityTypeIntervention
                                                     title:NSLocalizedString(@"Ibuprofen", nil)
                                                      text:NSLocalizedString(@"200 mg, Morning/Evening", nil)
                                                 tintColor:nil
                                              instructions:nil
                                                  imageURL:nil
                                                  schedule:schedule
                                          resultResettable:YES
                                                  userInfo:nil];
}

+ (OCKCarePlanActivity *_Nonnull)painTrackAssessment
{
    OCKCareSchedule *schedule = [OCKCareSchedule dailyScheduleWithStartDate:self.todaysDateComponents occurrencesPerDay:1];

    return [[OCKCarePlanActivity alloc] initWithIdentifier:@"BCMPainTrack"
                                           groupIdentifier:SubjectiveAssessmentsGroupIdentifier
                                                      type:OCKCarePlanActivityTypeAssessment
                                                     title:NSLocalizedString(@"Pain", nil)
                                                      text:NSLocalizedString(@"Lower Back", nil)
                                                 tintColor:nil
                                              instructions:nil
                                                  imageURL:nil
                                                  schedule:schedule
                                          resultResettable:YES
                                                  userInfo:nil];
}

+ (OCKCarePlanActivity *_Nonnull)moodTrackAssessment
{
    OCKCareSchedule *schedule = [OCKCareSchedule dailyScheduleWithStartDate:self.todaysDateComponents occurrencesPerDay:1];

    return [[OCKCarePlanActivity alloc] initWithIdentifier:@"BCMMoodTrack"
                                           groupIdentifier:SubjectiveAssessmentsGroupIdentifier
                                                      type:OCKCarePlanActivityTypeAssessment
                                                     title:NSLocalizedString(@"Mood", nil)
                                                      text:nil
                                                 tintColor:nil
                                              instructions:nil
                                                  imageURL:nil
                                                  schedule:schedule
                                          resultResettable:YES
                                                  userInfo:nil];
}

+ (OCKCarePlanActivity *_Nonnull)weightTrackAssessment
{
    OCKCareSchedule *schedule = [OCKCareSchedule dailyScheduleWithStartDate:self.todaysDateComponents occurrencesPerDay:1];

    return [[OCKCarePlanActivity alloc] initWithIdentifier:@"BCMWeightTrack"
                                           groupIdentifier:ObjectiveAssessmentsGroupIdentifier
                                                      type:OCKCarePlanActivityTypeAssessment
                                                     title:NSLocalizedString(@"Weight", nil)
                                                      text:NSLocalizedString(@"Early Morning", nil)
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