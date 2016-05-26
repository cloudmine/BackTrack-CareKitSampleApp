#import "BCMMainTabController.h"
#import "BCMFirstStartTracker.h"
#import "BCMActivities.h"

NSString * const _Nonnull BCMStoreDidUpdateNotification = @"BCMStoreDidUpdate";

@interface BCMMainTabController ()<OCKCarePlanStoreDelegate>

@property (nonatomic, readwrite, nonnull) OCKCarePlanStore *carePlanStore;

@end

@implementation BCMMainTabController

#pragma mark Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (nil ==  self) return nil;

    self.carePlanStore = [[OCKCarePlanStore alloc] initWithPersistenceDirectoryURL:BCMMainTabController.persistenceDirectory];
    self.carePlanStore.delegate = self;

    if (BCMFirstStartTracker.isFirstStart) {
        [self addActivities];
        [BCMFirstStartTracker recordFirstStart];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Hello");
}

#pragma mark OCKCarePlanStoreDelegate

- (void)carePlanStore:(OCKCarePlanStore *)store didReceiveUpdateOfEvent:(OCKCarePlanEvent *)event
{
    [self postStoreUpdateNotification];
}

- (void)carePlanStoreActivityListDidChange:(OCKCarePlanStore *)store
{
    [self postStoreUpdateNotification];
}

#pragma mark Private

- (void)postStoreUpdateNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BCMStoreDidUpdateNotification object:self];
}

+ (NSURL *)persistenceDirectory
{
    NSURL *appDirURL = [[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask].firstObject;

    NSAssert(nil != appDirURL, @"Failed to create store director URL");

    if (![[NSFileManager defaultManager] fileExistsAtPath:[appDirURL path] isDirectory:nil]) {
        NSError *dirError = nil;
        [[NSFileManager defaultManager] createDirectoryAtURL:appDirURL withIntermediateDirectories:YES attributes:nil error:&dirError];
        NSAssert(nil == dirError, @"Error creating store directory: %@", dirError.localizedDescription);
    }

    return appDirURL;
}

- (void)addActivities
{
    for (OCKCarePlanActivity *activity in BCMActivities.activities) {
        [self.carePlanStore addActivity:activity completion:^(BOOL success, NSError * _Nullable error) {
            if (!success) {
                NSLog(@"Failed to add activity to store: %@", error.localizedDescription);
                return;
            }

            NSLog(@"Activity added to store");
        }];
    }
}

@end
