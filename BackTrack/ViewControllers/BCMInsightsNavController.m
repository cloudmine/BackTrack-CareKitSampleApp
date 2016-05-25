#import "BCMInsightsNavController.h"
#import <CareKit/CareKit.h>

@interface BCMInsightsNavController ()

@end

@implementation BCMInsightsNavController

- (void)viewDidLoad
{
    [super viewDidLoad];

    OCKInsightsViewController *insightsVC = [[OCKInsightsViewController alloc] initWithInsightItems:@[]
                                                                                        headerTitle:NSLocalizedString(@"Treatment Insights", nil)
                                                                                     headerSubtitle:NSLocalizedString(@"Data from your treatment over the last week", nil)];
    [self showViewController:insightsVC sender:nil];
}

@end
