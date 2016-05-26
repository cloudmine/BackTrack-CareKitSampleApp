#import <CareKit/CareKit.h>

typedef void(^BCMBuildInsightsCompletion)(NSArray<OCKInsightItem *> *_Nonnull items);

@interface BCMInsightBuilder : NSObject

+ (void)fetchInsightsFromStore:(OCKCarePlanStore *_Nonnull)store withCompletion:(_Nonnull BCMBuildInsightsCompletion)block;

@end
