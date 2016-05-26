#import "BCMInsightsNavController.h"
#import <CareKit/CareKit.h>
#import "UIViewController+BCM.h"
#import "BCMMainTabController.h"
#import "BCMActivities.h"
#import "BCMInsightBuilder.h"

@interface BCMInsightsNavController ()
@property (nonatomic, nonnull) OCKInsightsViewController *insightsVC;
@end

@implementation BCMInsightsNavController

#pragma mark Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self showViewController:self.insightsVC sender:nil];

    [BCMInsightBuilder fetchInsightsFromStore:self.bcmTabBarController.carePlanStore withCompletion:^(NSArray<OCKInsightItem *> * _Nonnull items) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.insightsVC.items = items;
        });
    }];
}

-  (OCKInsightsViewController *)insightsVC
{
    if (nil == _insightsVC) {
        _insightsVC = [[OCKInsightsViewController alloc] initWithInsightItems:@[]
                                                                  headerTitle:NSLocalizedString(@"Treatment Insights", nil)
                                                               headerSubtitle:NSLocalizedString(@"Data from your treatment over the last week", nil)];
    }

    return _insightsVC;
}

@end
