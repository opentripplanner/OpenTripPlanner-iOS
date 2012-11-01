//
//  OTPAboutViewController.m
//  OpenTripPlanner
//
//  Created by Jeff Maki on 10/26/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPAboutViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface OTPAboutViewController ()

@end

@implementation OTPAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: @"http://www.joyrideit.com/THANKS.txt"]
                     cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];

    self.connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.receivedData = [NSMutableData data];
    
    [self.aboutTextView.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
    [self.aboutTextView.layer setShadowOffset:CGSizeMake(0, 1.0)];
    [self.aboutTextView.layer setShadowOpacity:1.0];
    [self.aboutTextView.layer setShadowRadius:0.3];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self.receivedData setLength: 0];
}

- (void)viewDidUnload {
    if(self.connection != nil) {
        [self.connection cancel];
    }
    [self setAboutTextView:nil];
    [self.receivedData setLength: 0];
    [super viewDidUnload];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *dataString = [[NSString alloc] initWithData: self.receivedData encoding: NSASCIIStringEncoding];
    self.aboutTextView.text = [self.aboutTextView.text stringByAppendingString:dataString];
}

@end
