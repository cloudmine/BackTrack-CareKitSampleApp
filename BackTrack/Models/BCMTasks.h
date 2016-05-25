#import <ResearchKit/ResearchKit.h>

@interface BCMTasks : NSObject

+ (ORKOrderedTask *_Nullable)taskForAssessmentIdentifier:(NSString *_Nonnull)assessmentId;

@end
