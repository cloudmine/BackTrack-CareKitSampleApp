#import "BCMConnectNavController.h"
#import <CMHealth/CMHealth.h>
#import "UIColor+BCM.h"
#import "UIViewController+BCM.h"
#import "BCMMainTabController.h"
#import "BCMMainThread.h"

@interface BCMConnectNavController ()

@property (nonatomic) OCKPatient *patient;
@property (nonatomic) OCKConnectViewController *connectVC;

@end

@implementation BCMConnectNavController

#pragma mark Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationBar.tintColor = [UIColor bcmBlueColor];
    
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", CMHUser.currentUser.userData.givenName, CMHUser.currentUser.userData.familyName];
    self.patient = [[OCKPatient alloc] initWithIdentifier:[CMHUser currentUser].userData.userId
                                            carePlanStore:self.bcmTabBarController.carePlanStore
                                                     name:fullName
                                               detailInfo:nil
                                         careTeamContacts:nil
                                                tintColor:nil
                                                 monogram:nil
                                                    image:nil
                                               categories:nil];

    self.connectVC = [[OCKConnectViewController alloc] initWithContacts:BCMConnectNavController.contacts
                                                                patient:self.patient];
    [self fetchProfileImage];
    
    self.connectVC.navigationItem.title = NSLocalizedString(@"Connect", nil);
    [self showViewController:self.connectVC sender:nil];
}

- (void)fetchProfileImage
{
    [[CMHUser currentUser] fetchProfileImageWithCompletion:^(BOOL success, UIImage *image, NSError *error) {
        if (!success) {
            NSLog(@"[CMHealth] Error fetching profile image: %@", error.localizedDescription);
            return;
        }
        
        if (nil == image) {
            return;
        }
        
        on_main_thread(^{
            NSLog(@"[CMHealth] Successfully fetched profile image");
            self.patient.image = image;
            
            // TODO: Mention this to Umer
            // Yikes! The only way to force the header view to consider the image now set to the patient
            // is to call viewDidLoad:, i.e. re-initialize it. To do this, I'm creating a new instance
            // and swapping it out for the existing one in the nav controllers VC stack. Probably
            // not a great idea!
            if (self.viewControllers.count >= 1) {
                NSMutableArray *newVCs = [NSMutableArray new];
                self.connectVC = [[OCKConnectViewController alloc] initWithContacts:BCMConnectNavController.contacts
                                                                            patient:self.patient];
                [newVCs addObject:self.connectVC];
                
                for (int i = 1; i < self.viewControllers.count; i++) {
                    [newVCs addObject:self.viewControllers[i]];
                }
                
                self.viewControllers = [newVCs copy];
            }
        });
    }];
}

# pragma mark Generators

+ (NSArray <OCKContact *> *_Nonnull)contacts
{
    return @[self.cloudMineContact, self.doctorContact, self.physicalTherapistContact];
}

+ (OCKContact *_Nonnull)cloudMineContact
{
    NSString *cloudMinePhone = @"(855) 662-7722";
    NSString *cloudMineEmail = @"support@cloudmineinc.com";
    
    OCKContactInfo *phoneInfo = [[OCKContactInfo alloc] initWithType:OCKContactInfoTypePhone displayString:cloudMinePhone actionURL:nil label:cloudMinePhone];
    OCKContactInfo *emailInfo = [[OCKContactInfo alloc] initWithType:OCKContactInfoTypeEmail displayString:cloudMineEmail actionURL:nil label:cloudMineEmail];
    
    return [[OCKContact alloc] initWithContactType:OCKContactTypePersonal
                                              name:@"CloudMine"
                                          relation:NSLocalizedString(@"Connected Care Partner", nil)
                                  contactInfoItems:@[phoneInfo, emailInfo]
                                         tintColor:[UIColor bcmBlueColor]
                                          monogram:@"CM"
                                             image:nil];

}

+ (OCKContact *_Nonnull)doctorContact
{
    NSString *doctorPhone = @"(555) 555-5555";
    NSString *doctorEmail = @"jane@fakebackdoctor.com";
    
    OCKContactInfo *phoneInfo   = [[OCKContactInfo alloc] initWithType:OCKContactInfoTypePhone displayString:doctorPhone actionURL:nil label:doctorPhone];
    OCKContactInfo *messageInfo = [[OCKContactInfo alloc] initWithType:OCKContactInfoTypeMessage displayString:doctorPhone actionURL:nil label:doctorPhone];
    OCKContactInfo *emailInfo   = [[OCKContactInfo alloc] initWithType:OCKContactInfoTypeEmail displayString:doctorEmail actionURL:nil label:doctorEmail];
    
    return [[OCKContact alloc] initWithContactType:OCKContactTypeCareTeam
                                              name:@"Dr. Jane Smith"
                                          relation:@"Orthopedist"
                                  contactInfoItems:@[phoneInfo, messageInfo, emailInfo]
                                         tintColor:[UIColor bcmGreenColor]
                                          monogram:@"JS"
                                             image:nil];
}

+ (OCKContact *_Nonnull)physicalTherapistContact
{
    NSString *therapistPhone = @"(555) 555-1234";
    NSString *therapistEmail = @"John@notreallyapt.com";
    
    OCKContactInfo *phoneInfo   = [[OCKContactInfo alloc] initWithType:OCKContactInfoTypePhone displayString:therapistPhone actionURL:nil label:therapistPhone];
    OCKContactInfo *messageInfo = [[OCKContactInfo alloc] initWithType:OCKContactInfoTypeMessage displayString:therapistPhone actionURL:nil label:therapistPhone];
    OCKContactInfo *emailInfo   = [[OCKContactInfo alloc] initWithType:OCKContactInfoTypeEmail displayString:therapistEmail actionURL:nil label:therapistEmail];
    
    return [[OCKContact alloc] initWithContactType:OCKContactTypeCareTeam
                                              name:@"John Doe"
                                          relation:@"Physical Therapist"
                                  contactInfoItems:@[phoneInfo, messageInfo, emailInfo]
                                         tintColor:[UIColor bcmPurpleColor]
                                          monogram:@"JD"
                                             image:nil];
}

@end
