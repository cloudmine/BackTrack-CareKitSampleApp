#import "BCMMainTabController.h"
#import "BCMFirstStartTracker.h"
#import "BCMActivities.h"
#import "UIColor+BCM.h"
#import "OCKCarePlanStore+BCM.h"
#import "CareKit+BCM.h"

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
        [self.carePlanStore bcm_fetchActivitiesWithCompletion:^(NSArray<OCKCarePlanActivity *> * _Nullable activities, NSError * _Nullable error) {
            if (nil == activities || activities.count < 1) {
                [self addInitialActivities];
                return;
            }

            NSLog(@"Adding fetched activities");
            [BCMMainTabController addActivities:activities toStore:self.carePlanStore];
        }];

        [BCMFirstStartTracker recordFirstStart];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.tintColor = [UIColor bcmBlueColor];

    [self.carePlanStore bcm_saveActivtiesWithCompletion:^(NSError * _Nullable error) {
        NSLog(@"Did Save Activities");
    }];
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

- (void)addInitialActivities
{
    NSLog(@"Adding Hardcoded Activities");
    [BCMMainTabController addActivities:BCMActivities.activities toStore:self.carePlanStore];
}

+ (void)addActivities:(NSArray<OCKCarePlanActivity *> *_Nonnull)activities toStore:(OCKCarePlanStore *_Nonnull)store
{
    for (OCKCarePlanActivity *activity in activities) {
        [store addActivity:activity completion:^(BOOL success, NSError * _Nullable error) {
            if (!success) {
                NSLog(@"Failed to add activity to store: %@", error.localizedDescription);
                return;
            }

            NSLog(@"Activity added to store");
        }];
    }
}

@end
