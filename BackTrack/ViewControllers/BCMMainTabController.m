#import "BCMMainTabController.h"
#import "BCMFirstStartTracker.h"
#import "BCMActivities.h"

@interface BCMMainTabController ()

@property (nonatomic, readwrite, nonnull) OCKCarePlanStore *carePlanStore;

@end

@implementation BCMMainTabController

#pragma mark Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (nil ==  self) return nil;

    self.carePlanStore = [[OCKCarePlanStore alloc] initWithPersistenceDirectoryURL:BCMMainTabController.persistenceDirectory];

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

#pragma mark Private

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
