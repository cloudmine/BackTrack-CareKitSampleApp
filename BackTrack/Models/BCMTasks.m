#import "BCMTasks.h"
#import "BCMIdentifiers.h"

@implementation BCMTasks

+ (ORKOrderedTask *_Nullable)taskForAssessmentIdentifier:(NSString *_Nonnull)assessmentId
{
    if ([BCMIdentifierAssessmentPainTrack isEqualToString:assessmentId]) {
        return [self painTrackTask];
    } else if ([BCMIdentifierAssessmentMoodTrack isEqualToString:assessmentId]) {
        return [self moodTrackTask];
    } else if ([BCMIdentifierAssessmentWeightTrack isEqualToString:assessmentId]) {
        return [self weightTrackTask];
    }

    return nil;
}

#pragma mark Generators

+ (ORKOrderedTask *_Nonnull)painTrackTask
{
    ORKScaleAnswerFormat *painScale = [[ORKScaleAnswerFormat alloc] initWithMaximumValue:10 minimumValue:1 defaultValue:5 step:1];
    ORKQuestionStep *painQuestion = [ORKQuestionStep questionStepWithIdentifier:BCMIdentifierAssessmentPainTrack
                                                                          title:NSLocalizedString(@"How was your lower back pain today?", nil)
                                                                           text:NSLocalizedString(@"Where 1 is no pain and 10 is the worst pain imaginable", nil)
                                                                         answer:painScale];
    painQuestion.optional = NO;

    return [[ORKOrderedTask alloc] initWithIdentifier:BCMIdentifierAssessmentPainTrack
                                                steps:@[painQuestion]];
}

+ (ORKOrderedTask *_Nonnull)moodTrackTask
{
    ORKScaleAnswerFormat *moodScale = [[ORKScaleAnswerFormat alloc] initWithMaximumValue:10 minimumValue:1 defaultValue:5 step:1];
    ORKQuestionStep *moodQuestion = [ORKQuestionStep questionStepWithIdentifier:BCMIdentifierAssessmentMoodTrack
                                                                          title:NSLocalizedString(@"How was your mood today?", nil)
                                                                           text:NSLocalizedString(@"Where 1 is very poor and 10 very good", nil)
                                                                         answer:moodScale];
    moodQuestion.optional = NO;

    return [[ORKOrderedTask alloc] initWithIdentifier:BCMIdentifierAssessmentMoodTrack
                                                steps:@[moodQuestion]];
}

+ (ORKOrderedTask *_Nonnull)weightTrackTask
{
    ORKNumericAnswerFormat *weightAnswer = [[ORKNumericAnswerFormat alloc] initWithStyle:ORKNumericAnswerStyleDecimal
                                                                                    unit:NSLocalizedString(@"lbs", nil)
                                                                                 minimum:@50
                                                                                 maximum:@500];

    ORKQuestionStep *weightQuestion = [ORKQuestionStep questionStepWithIdentifier:BCMIdentifierAssessmentWeightTrack
                                                                            title:NSLocalizedString(@"Weight", nil)
                                                                           answer:weightAnswer];
    weightQuestion.optional = NO;

    return [[ORKOrderedTask alloc] initWithIdentifier:BCMIdentifierAssessmentWeightTrack steps:@[weightQuestion]];
}


@end
