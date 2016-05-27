#import "BCMActivities.h"
#import "BCMIdentifiers.h"
#import "NSDateComponents+BCM.h"
#import "UIColor+BCM.h"

@implementation BCMActivities

+ (NSArray<OCKCarePlanActivity *> *)activities
{
    return @[self.hamstringStretchIntervention, self.briskWalkIntervention,
             self.warmCompressIntervention, self.painKillerIntervention,
             self.painTrackAssessment, self.moodTrackAssessment,
             self.weightTrackAssessment];
}

+ (OCKCarePlanActivity *_Nonnull)hamstringStretchIntervention
{
    OCKCareSchedule *schedule = [OCKCareSchedule dailyScheduleWithStartDate:[NSDateComponents weekAgoComponents] occurrencesPerDay:3];

    NSString *instructions = NSLocalizedString(@"With your feet spread shoulder width apart, gently bend at the waist reaching toward"
                                                "your feet until you feel tension. Stop and hold for 10-16 seconds.", nil);

    return [[OCKCarePlanActivity alloc] initWithIdentifier:BCMIdentifierInterventionHamstringStretch
                                           groupIdentifier:BCMIdentifierExerciseInterventionsGroup
                                                      type:OCKCarePlanActivityTypeIntervention
                                                     title:NSLocalizedString(@"Hamstring Stretch", nil)
                                                      text:NSLocalizedString(@"5 minutes", nil)
                                                 tintColor:[UIColor bcmBlueColor]
                                              instructions:instructions
                                                  imageURL:nil
                                                  schedule:schedule
                                          resultResettable:YES
                                                  userInfo:nil];
}

+ (OCKCarePlanActivity *_Nonnull)briskWalkIntervention
{
    OCKCareSchedule *schedule = [OCKCareSchedule dailyScheduleWithStartDate:[NSDateComponents weekAgoComponents] occurrencesPerDay:1];

    NSString *instructions = NSLocalizedString(@"Walk for fifteen minutes at a pace above a leisurely stroll. "
                                                "Be sure to maintain good posture during the walk.", nil);

    return [[OCKCarePlanActivity alloc] initWithIdentifier:BCMIdentifierInterventionBriskWalk
                                           groupIdentifier:BCMIdentifierExerciseInterventionsGroup
                                                      type:OCKCarePlanActivityTypeIntervention
                                                     title:NSLocalizedString(@"Brisk Walk", nil)
                                                      text:NSLocalizedString(@"15 minutes", nil)
                                                 tintColor:[UIColor bcmGreenColor]
                                              instructions:instructions
                                                  imageURL:nil
                                                  schedule:schedule
                                          resultResettable:YES
                                                  userInfo:nil];
}

+ (OCKCarePlanActivity *_Nonnull)warmCompressIntervention
{
    OCKCareSchedule *schedule = [OCKCareSchedule weeklyScheduleWithStartDate:[NSDateComponents weekAgoComponents]
                                                        occurrencesOnEachDay:@[@0, @1, @0, @1, @0, @1, @0]]; // Mon/Wed/Fri

    NSString *instructions = NSLocalizedString(@"Soak a towel in warm to hot water and drain. Laying on your stomach, "
                                                "place the folded towel on your lower back for 5-10 minutes", nil);

    return [[OCKCarePlanActivity alloc] initWithIdentifier:BCMIdentifierInterventionWarmCompress
                                           groupIdentifier:BCMIdentifierMedicationInterventionsGroup
                                                      type:OCKCarePlanActivityTypeIntervention
                                                     title:NSLocalizedString(@"Warm Compress", nil)
                                                      text:NSLocalizedString(@"Morning", nil)
                                                 tintColor:[UIColor bcmPurpleColor]
                                              instructions:instructions
                                                  imageURL:nil
                                                  schedule:schedule
                                          resultResettable:YES
                                                  userInfo:nil];
}

+ (OCKCarePlanActivity *_Nonnull)painKillerIntervention
{
    OCKCareSchedule *schedule = [OCKCareSchedule dailyScheduleWithStartDate:[NSDateComponents weekAgoComponents]
                                                          occurrencesPerDay:2
                                                                 daysToSkip:1
                                                                    endDate:nil];
    NSString *instructions = NSLocalizedString(@"Take a 200 mg dose of Ibuprofen two times a day, "
                                                "once in the morning and another in the evening.", nil);


    return [[OCKCarePlanActivity alloc] initWithIdentifier:BCMIdentifierInterventionPainKiller
                                           groupIdentifier:BCMIdentifierMedicationInterventionsGroup
                                                      type:OCKCarePlanActivityTypeIntervention
                                                     title:NSLocalizedString(@"Ibuprofen", nil)
                                                      text:NSLocalizedString(@"200 mg, Morning/Evening", nil)
                                                 tintColor:[UIColor bcmPainColor]
                                              instructions:instructions
                                                  imageURL:nil
                                                  schedule:schedule
                                          resultResettable:YES
                                                  userInfo:nil];
}

+ (OCKCarePlanActivity *_Nonnull)painTrackAssessment
{
    OCKCareSchedule *schedule = [OCKCareSchedule dailyScheduleWithStartDate:[NSDateComponents weekAgoComponents] occurrencesPerDay:1];

    return [[OCKCarePlanActivity alloc] initWithIdentifier:BCMIdentifierAssessmentPainTrack
                                           groupIdentifier:BCMIdentifierSubjectiveAssessmentsGroup
                                                      type:OCKCarePlanActivityTypeAssessment
                                                     title:NSLocalizedString(@"Pain", nil)
                                                      text:NSLocalizedString(@"Lower Back", nil)
                                                 tintColor:[UIColor bcmPainColor]
                                              instructions:nil
                                                  imageURL:nil
                                                  schedule:schedule
                                          resultResettable:YES
                                                  userInfo:nil];
}

+ (OCKCarePlanActivity *_Nonnull)moodTrackAssessment
{
    OCKCareSchedule *schedule = [OCKCareSchedule dailyScheduleWithStartDate:[NSDateComponents weekAgoComponents] occurrencesPerDay:1];

    return [[OCKCarePlanActivity alloc] initWithIdentifier:BCMIdentifierAssessmentMoodTrack
                                           groupIdentifier:BCMIdentifierSubjectiveAssessmentsGroup
                                                      type:OCKCarePlanActivityTypeAssessment
                                                     title:NSLocalizedString(@"Mood", nil)
                                                      text:nil
                                                 tintColor:[UIColor bcmMoodColor]
                                              instructions:nil
                                                  imageURL:nil
                                                  schedule:schedule
                                          resultResettable:NO
                                                  userInfo:nil];
}

+ (OCKCarePlanActivity *_Nonnull)weightTrackAssessment
{
    OCKCareSchedule *schedule = [OCKCareSchedule dailyScheduleWithStartDate:[NSDateComponents weekAgoComponents] occurrencesPerDay:1];

    return [[OCKCarePlanActivity alloc] initWithIdentifier:BCMIdentifierAssessmentWeightTrack
                                           groupIdentifier:BCMIdentifierObjectiveAssessmentsGroup
                                                      type:OCKCarePlanActivityTypeAssessment
                                                     title:NSLocalizedString(@"Weight", nil)
                                                      text:NSLocalizedString(@"Early Morning", nil)
                                                 tintColor:[UIColor bcmBlueColor]
                                              instructions:nil
                                                  imageURL:nil
                                                  schedule:schedule
                                          resultResettable:YES
                                                  userInfo:nil];
}

@end
