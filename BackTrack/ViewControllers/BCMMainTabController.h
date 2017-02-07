#import <UIKit/UIKit.h>
#import <CareKit/CareKit.h>
#import <CMHealth/CMHealth.h>

extern  NSString * const _Nonnull BCMStoreDidUpdateNotification;
extern  NSString * const _Nonnull BCMStoreDidReloadEventData;

@interface BCMMainTabController : UITabBarController

@property (nonatomic, readonly, nonnull) CMHCarePlanStore *carePlanStore;

@end

