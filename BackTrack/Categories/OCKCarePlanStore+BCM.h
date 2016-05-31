#import <CareKit/CareKit.h>

typedef void(^BCMCarePlanSaveCompletion)(NSError *_Nullable error);

@interface OCKCarePlanStore (BCM)

- (void)bcm_saveActivtiesWithCompletion:(_Nullable BCMCarePlanSaveCompletion)block;

@end