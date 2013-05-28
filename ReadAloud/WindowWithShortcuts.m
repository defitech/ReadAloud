//
//  WindowWithShortcuts.m
//  lecteur
//
//  Created by dev on 06.05.13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "WindowWithShortcuts.h"

@implementation WindowWithShortcuts
- (void)close
{
    NSLog(@"window closed");
    [super close];
}

- (void)sendEvent:(NSEvent *)event
{
    [super sendEvent:event];
    if (event.type == NSRightMouseDown) {
        NSLog(@"mouse down");
    }
}
@end
