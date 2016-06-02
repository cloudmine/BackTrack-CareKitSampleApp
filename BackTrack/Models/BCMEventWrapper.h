#import <CloudMine/CloudMine.h>
#import <CareKit/CareKit.h>

@interface BCMEventWrapper : CMObject

- (_Nonnull instancetype)initWithEvent:(OCKCarePlanEvent *_Nonnull)event;

@end
