#import <CareKit/CareKit.h>

typedef void(^BCMCarePlanReloadCompletion)(NSError *_Nullable error);

@interface OCKCarePlanStore (BCM)

- (void)bcm_reloadAllRemoteEventsWithCompletion:(_Nullable BCMCarePlanReloadCompletion)block;

@end