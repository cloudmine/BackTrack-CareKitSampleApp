#import <CareKit/CareKit.h>

@interface OCKCarePlanEvent (BCM)

@property (nonatomic, readonly) BOOL isAvailable;
@property (nonatomic, nonnull, readonly) NSString *bcm_objectId;

@end
