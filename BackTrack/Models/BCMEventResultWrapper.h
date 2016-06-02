#import <CloudMine/CloudMine.h>
#import <CareKit/CareKit.h>

@interface BCMEventResultWrapper : CMObject

- (_Nonnull instancetype)initWithEventResult:(OCKCarePlanEventResult *_Nonnull)result;

@end
