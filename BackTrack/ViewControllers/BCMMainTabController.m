#import "BCMMainTabController.h"

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

    if (![[NSFileManager defaultManager] fileExistsAtPath:[appDirURL path]]) {
        NSError *dirError = nil;
        [[NSFileManager defaultManager] createDirectoryAtURL:appDirURL withIntermediateDirectories:YES attributes:nil error:&dirError];
        NSAssert(nil == dirError, @"Error creating store directory: %@", dirError.localizedDescription);
    }

    return appDirURL;
}

@end
