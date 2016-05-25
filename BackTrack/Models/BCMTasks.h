#import <ResearchKit/ResearchKit.h>
#import <CareKit/CareKit.h>

@interface BCMTasks : NSObject

+ (ORKOrderedTask *_Nullable)taskForAssessmentIdentifier:(NSString *_Nonnull)assessmentId;
+ (OCKCarePlanEventResult *_Nullable)carePlanResultForTaskResult:(ORKTaskResult *_Nonnull)taskResult;

@end
