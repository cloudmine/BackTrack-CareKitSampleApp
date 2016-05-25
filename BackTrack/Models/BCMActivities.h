#import <Foundation/Foundation.h>
#import <CareKit/CareKit.h>

@interface BCMActivities : NSObject

+ (NSArray<OCKCarePlanActivity *> *_Nonnull)activities;
+ (OCKCarePlanActivity *_Nonnull)hamstringStretchIntervention;

@end
