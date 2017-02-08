#import "BCMMainTabController.h"
#import "BCMFirstStartTracker.h"
#import "BCMActivities.h"
#import "UIColor+BCM.h"
#import "BCMWaitUntil.h"
#import "BCMStoreUtils.h"

NSString * const _Nonnull BCMStoreDidUpdateNotification = @"BCMStoreDidUpdate";
NSString * const _Nonnull BCMStoreDidReloadEventData    = @"BCMStoreDidReloadEventData";

@interface BCMMainTabController ()<OCKCarePlanStoreDelegate>

@property (nonatomic, readwrite, nonnull) CMHCarePlanStore *carePlanStore;

@end

@implementation BCMMainTabController

#pragma mark Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (nil ==  self) return nil;

    self.carePlanStore = [CMHCarePlanStore storeWithPersistenceDirectoryURL:BCMStoreUtils.persistenceDirectory];
    self.carePlanStore.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncRemoteActivitiesAndEvents) name:UIApplicationWillEnterForegroundNotification object:nil];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.tintColor = [UIColor bcmBlueColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self syncRemoteActivitiesAndEvents];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark OCKCarePlanStoreDelegate

- (void)carePlanStore:(OCKCarePlanStore *)store didReceiveUpdateOfEvent:(OCKCarePlanEvent *)event
{
    NSLog(@"[CMHealth] Received Event Update Notification");
    [self postStoreUpdateNotification];
}

- (void)carePlanStoreActivityListDidChange:(OCKCarePlanStore *)store
{
    NSLog(@"[CMHealth] Received Activity Update Notification");
    [self postStoreUpdateNotification];
}

#pragma mark Private

- (void)syncRemoteActivitiesAndEvents
{
    [self.carePlanStore syncFromRemoteWithCompletion:^(BOOL success, NSArray<NSError *> * _Nonnull errors) {
        if (!success) {
            NSLog(@"[CMHEALTH] Error syncing remote data %@", errors);
            return;
        }
        
        NSLog(@"[CMHEALTH] Successful sync of remote data");
        [self postStoreUpdateNotification];
    }];
}

- (void)postStoreUpdateNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BCMStoreDidUpdateNotification object:self];
}

- (void)postDataDidReloadNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BCMStoreDidReloadEventData object:self];
}

@end
