#import <Foundation/Foundation.h>

@interface BCMFirstStartTracker : NSObject

+ (BOOL)isFirstStart;
+ (void)recordFirstStart;
+ (void)forgetFirstStart;

@end
