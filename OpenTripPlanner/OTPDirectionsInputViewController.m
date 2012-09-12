//
//  OTPDirectionsInputViewController.m
//  OpenTripPlanner
//
//  Created by asutula on 9/10/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "OTPDirectionsInputViewController.h"

@interface OTPDirectionsInputViewController ()

- (void)switchFromAndTo:(id)sender;
- (void)geocodeStringInTextField:(OTPGeocodedTextField *)textField;

@end

@implementation OTPDirectionsInputViewController

@synthesize modeControl = _modeControl;
@synthesize cancelButton = _cancelButton;
@synthesize textFieldContainer = _textFieldContainer;
@synthesize fromTextField = _fromTextField;
@synthesize toTextField = _toTextField;
@synthesize dummyField = _dummyField;
@synthesize switchFromAndToButton = _switchFromAndToButton;
@synthesize delegate = _delegate;

CLGeocoder *geocoder;
CLPlacemark *fromPlacemark;
CLPlacemark *toPlacemark;

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
    
    geocoder = [[CLGeocoder alloc] init];
    
    self.dummyField.hidden = YES;
	
    self.switchFromAndToButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"S", nil]];
    self.switchFromAndToButton.segmentedControlStyle = UISegmentedControlStyleBar;
    CGRect controlFrame = self.switchFromAndToButton.frame;
    controlFrame.size.height = 40.f;
    controlFrame.size.width = 40.f;
    
    self.switchFromAndToButton.frame = controlFrame;
    //self.switchFromAndToButton.selectedSegmentIndex = 0;
    self.switchFromAndToButton.momentary = YES;
    self.switchFromAndToButton.center = CGPointMake(26, 40);
    [self.switchFromAndToButton addTarget:self action:@selector(switchFromAndTo:) forControlEvents:UIControlEventAllEvents];
    
    [self.textFieldContainer addSubview:self.switchFromAndToButton];
    
    UILabel *fromLabel = [[UILabel alloc] init];
    fromLabel.textColor = [UIColor grayColor];
    fromLabel.backgroundColor = [UIColor clearColor];
    fromLabel.font = [UIFont systemFontOfSize:14];
    fromLabel.text = @"From: ";
    [fromLabel sizeToFit];
    
    self.fromTextField.leftViewMode = UITextFieldViewModeAlways;
    self.fromTextField.leftView = fromLabel;
    
    UILabel *toLabel = [[UILabel alloc] init];
    toLabel.textColor = [UIColor grayColor];
    toLabel.backgroundColor = [UIColor clearColor];
    toLabel.font = [UIFont systemFontOfSize:14];
    toLabel.text = @"To: ";
    [toLabel sizeToFit];
    
    self.toTextField.leftViewMode = UITextFieldViewModeAlways;
    self.toTextField.leftView = toLabel;
    
    self.fromTextField.otherTextField = self.toTextField;
    self.toTextField.otherTextField = self.fromTextField;
    
    self.fromTextField.rightViewMode = UITextFieldViewModeUnlessEditing;
    self.toTextField.rightViewMode = UITextFieldViewModeUnlessEditing;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.fromTextField becomeFirstResponder];
}

- (void)geocodeStringInTextField:(OTPGeocodedTextField *)textField
{
    // TODO: If we want to pass a region to the geocoder, we should have a coordinate property on this thing
    // that the parent view controller can optionally set using the user's location or map center.
//    CLLocationCoordinate2D regionCoordinate;
//    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:regionCoordinate radius:2000 identifier:@"test"];
    
    UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingIndicator startAnimating];
    textField.rightView = loadingIndicator;
    textField.isDirty = NO;
    textField.placemark = nil;
    textField.returnKeyType = UIReturnKeyNext;
    self.dummyField.returnKeyType = UIReturnKeyNext;
    [textField reloadInputViews];
    [self.dummyField reloadInputViews];
    
    [geocoder geocodeAddressString:textField.text inRegion:nil completionHandler:^(NSArray* placemarks, NSError* error) {
        if (placemarks.count == 0) {
            // no results
            textField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"x.png"]];
        } else if (placemarks.count > 1) {
            // TODO: disambigate
            UILabel *l = [[UILabel alloc] init];
            l.text = @"?";
            textField.rightView = l;
        } else {
            // Got one result, process it.
            CLPlacemark *result = [placemarks objectAtIndex:0];
            textField.placemark = result;
            textField.text = [(NSArray *)[result.addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            textField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]];
            
            if (self.delegate != nil) {
                [self.delegate directionsInputView:self geocodedPlacemark:result];
            }
            
            if (textField.otherTextField.placemark != nil && textField.otherTextField.text != nil && ![textField.otherTextField.text isEqualToString:@""]) {
                textField.returnKeyType = UIReturnKeyRoute;
                textField.otherTextField.returnKeyType = UIReturnKeyRoute;
                self.dummyField.returnKeyType = UIReturnKeyRoute;
                [textField reloadInputViews];
                [textField.otherTextField reloadInputViews];
                [self.dummyField reloadInputViews];
            }
        }
    }];
    
}

- (void)cancelButtonClicked:(id)sender
{
    NSLog(@"Cacel button clicked.");
    if (self.delegate) {
        [self.delegate directionsInputViewCancelButtonClicked:self];
    }
}

//- (void)routeButtonClicked:(id)sender
//{
//    NSLog(@"Route button clicked.");
//    if (self.delegate) {
//        [self.delegate directionsInputViewRouteButtonClicked:self];
//    }
//}

- (void)switchFromAndTo:(id)sender
{
    NSString *tmpText = self.fromTextField.text;
    CLPlacemark *tmpPlacemark = self.fromTextField.placemark;
    UIView *tmpView = self.fromTextField.rightView;
    BOOL tmpIsDirty = self.fromTextField.isDirty;
    
    self.fromTextField.text = self.toTextField.text;
    self.fromTextField.placemark = self.toTextField.placemark;
    self.fromTextField.rightView = self.toTextField.rightView;
    self.fromTextField.isDirty = self.toTextField.isDirty;
    
    self.toTextField.text = tmpText;
    self.toTextField.placemark = tmpPlacemark;
    self.toTextField.rightView = tmpView;
    self.toTextField.isDirty = tmpIsDirty;
    
    [self.fromTextField reloadInputViews];
    [self.toTextField reloadInputViews];
}

- (void)updatedTextField:(id)sender
{
    NSLog(@"updated text field");
    OTPGeocodedTextField *textField = (OTPGeocodedTextField *)sender;
    textField.isDirty = YES;
    textField.rightView = nil;
    textField.returnKeyType = UIReturnKeyNext;
    textField.otherTextField.returnKeyType = UIReturnKeyNext;
    self.dummyField.returnKeyType = UIReturnKeyNext;
    [textField reloadInputViews];
    [textField.otherTextField reloadInputViews];
    [self.dummyField reloadInputViews];
}

- (void)doneEditingTextField:(id)sender
{
    OTPGeocodedTextField *textField = (OTPGeocodedTextField *)sender;
    if ([textField isDirty] && ![textField.text isEqualToString:@""]) {
        [self geocodeStringInTextField:(OTPGeocodedTextField *)sender];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    OTPGeocodedTextField *field = (OTPGeocodedTextField *)textField;
    
    // If the user is submitting a route query, don't do anything other than launch the query
    if (field.returnKeyType == UIReturnKeyRoute) {
        // Launch query through delegate
        if (self.delegate != nil) {
            [self.delegate directionsInputView:self choseRouteFrom:self.fromTextField.placemark to:self.toTextField.placemark];
        }
        [self.fromTextField resignFirstResponder];
        [self.toTextField resignFirstResponder];
        [self.dummyField resignFirstResponder];
        return NO;
    }
    // If the other text field has valid geocoded data, we don't need to do anything
    if (field.otherTextField.placemark != nil && field.otherTextField.text != nil && ![field.otherTextField.text isEqualToString:@""]) {
        [self.dummyField becomeFirstResponder];
        return YES;
    }
    // The other text field needs input so make it the first responder
    [((OTPGeocodedTextField *)textField).otherTextField becomeFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
