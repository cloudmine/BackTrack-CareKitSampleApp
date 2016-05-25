#import "BCMTasks.h"
#import "BCMIdentifiers.h"

@implementation BCMTasks

+ (ORKOrderedTask *_Nullable)taskForAssessmentIdentifier:(NSString *_Nonnull)assessmentId
{
    if ([BCMIdentifierAssessmentPainTrack isEqualToString:assessmentId]) {
        return [self painTrackTask];
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

    return [[ORKOrderedTask alloc] initWithIdentifier:BCMIdentifierAssessmentPainTrack
                                                steps:@[painQuestion]];
}


@end
