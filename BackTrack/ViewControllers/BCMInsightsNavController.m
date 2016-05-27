#import "BCMInsightsNavController.h"
#import <CareKit/CareKit.h>
#import "UIViewController+BCM.h"
#import "BCMMainTabController.h"
#import "BCMActivities.h"
#import "BCMInsightBuilder.h"
#import "UIColor+BCM.h"

@interface BCMInsightsNavController ()
@property (nonatomic, nonnull) OCKInsightsViewController *insightsViewController;
@end

@implementation BCMInsightsNavController

#pragma mark Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self showViewController:self.insightsViewController sender:nil];
    self.insightsViewController.navigationItem.title = NSLocalizedString(@"Insights", nil);
    [self fetchAndUpdateInsights];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchAndUpdateInsights) name:BCMStoreDidUpdateNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BCMStoreDidUpdateNotification object:nil];
}

#pragma mark Getter-Setters

-  (OCKInsightsViewController *)insightsViewController
{
    if (nil == _insightsViewController) {
        _insightsViewController = [[OCKInsightsViewController alloc] initWithInsightItems:@[]
                                                                  headerTitle:NSLocalizedString(@"Treatment Insights", nil)
                                                               headerSubtitle:NSLocalizedString(@"Data from your treatment over the last week", nil)];
    }

    return _insightsViewController;
}

#pragma mark Private

- (void)fetchAndUpdateInsights
{
    [BCMInsightBuilder fetchInsightsFromStore:self.bcmTabBarController.carePlanStore withCompletion:^(NSArray<OCKInsightItem *> * _Nonnull items) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.insightsViewController.items = items;
        });
    }];
}

@end
