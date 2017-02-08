#import <CareKit/CareKit.h>

@interface BCMStoreUtils : NSObject

+ (nonnull NSURL *)persistenceDirectory;
+ (void)addActivities:(nonnull NSArray<OCKCarePlanActivity *> *)activities toStore:(nonnull OCKCarePlanStore *)store;

@end
