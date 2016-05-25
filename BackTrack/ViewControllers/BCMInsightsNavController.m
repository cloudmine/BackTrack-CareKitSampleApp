#import "BCMInsightsNavController.h"
#import <CareKit/CareKit.h>

@interface BCMInsightsNavController ()

@end

@implementation BCMInsightsNavController

- (void)viewDidLoad
{
    [super viewDidLoad];

    OCKMessageItem *testMessage = [[OCKMessageItem alloc] initWithTitle:NSLocalizedString(@"Perform your exercises!", nil)
                                                                   text:NSLocalizedString(@"Staying active is the number one way to mitigate your pain", nil)
                                                              tintColor:nil
                                                            messageType:OCKMessageItemTypeTip];

    OCKInsightsViewController *insightsVC = [[OCKInsightsViewController alloc] initWithInsightItems:@[testMessage]
                                                                                        headerTitle:NSLocalizedString(@"Treatment Insights", nil)
                                                                                     headerSubtitle:NSLocalizedString(@"Data from your treatment over the last week", nil)];
    [self showViewController:insightsVC sender:nil];
}

@end
