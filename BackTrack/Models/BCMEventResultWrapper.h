#import <CloudMine/CloudMine.h>
#import <CareKit/CareKit.h>

@interface BCMEventResultWrapper : NSObject<CMCoding>

- (_Nonnull instancetype)initWithEventResult:(OCKCarePlanEventResult *_Nonnull)result;
- (BOOL)isDataEquivalentOf:(OCKCarePlanEventResult *_Nullable)result;

@property (nonatomic, nullable, readonly) OCKCarePlanEventResult *result;

@end
