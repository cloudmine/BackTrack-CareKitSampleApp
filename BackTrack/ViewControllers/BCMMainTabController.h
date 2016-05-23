#import <UIKit/UIKit.h>
#import <CareKit/CareKit.h>

@interface BCMMainTabController : UITabBarController

@property (nonatomic, readonly, nonnull) OCKCarePlanStore *carePlanStore;

@end

