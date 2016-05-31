#import "BCMMainThread.h"

void on_main_thread(dispatch_block_t block)
{
    if ([NSOperationQueue currentQueue] == [NSOperationQueue mainQueue]) {
        block();
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        block();
    });
}