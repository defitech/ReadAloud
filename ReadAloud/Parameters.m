//
//  Parameters.m
//  lecteur
//
//  Created by dev on 21.05.13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "Parameters.h"
#import "MasterViewController.h"


@interface Parameters ()
@property (nonatomic,strong) IBOutlet MasterViewController *masterViewController;
@end

@implementation Parameters

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}




- (IBAction)buttonGoToSpeechSynthesizer:(id)sender {
    // 1. Create the master View Controller
    self.masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
    
    // 2. Add the view controller to the Window's content view
    while ([self.view.subviews count] >0) {
        [[self.view.subviews objectAtIndex:0] removeFromSuperview];
    }
    
    [self.view addSubview:self.masterViewController.view];
    self.masterViewController.view.frame = ((NSView*)self.view).bounds;
}

@end
