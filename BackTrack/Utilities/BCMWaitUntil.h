#import <Foundation/Foundation.h>

typedef void(^BCMDoneBlock)(void);
typedef void(^BCMWaitBlock)(_Nonnull BCMDoneBlock done);

void bcm_wait_until(_Nonnull BCMWaitBlock block);
