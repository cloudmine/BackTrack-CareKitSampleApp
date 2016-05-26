#import <UIKit/UIKit.h>
#import <CareKit/CareKit.h>

extern  NSString * const _Nonnull BCMStoreDidUpdateNotification;

@interface BCMMainTabController : UITabBarController

@property (nonatomic, readonly, nonnull) OCKCarePlanStore *carePlanStore;

@end

