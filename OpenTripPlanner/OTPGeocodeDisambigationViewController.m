//
//  OTPGeocodeDisambigationViewController.m
//  OpenTripPlanner
//
//  Created by asutula on 11/16/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPGeocodeDisambigationViewController.h"

@interface OTPGeocodeDisambigationViewController ()

@end

@implementation OTPGeocodeDisambigationViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.placemarks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    CLPlacemark *result = [self.placemarks objectAtIndex:indexPath.row];
    NSArray *formattedAddressLines = (NSArray *)[result.addressDictionary objectForKey:@"FormattedAddressLines"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF != %@", result.country];
    NSArray *filteredAddressLines = [formattedAddressLines filteredArrayUsingPredicate:predicate];
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = [filteredAddressLines componentsJoinedByString:@", "];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(OTPGeocodeDisambigationViewControllerDelegate)]) {
        [self.delegate userSelectedPlacemark:[self.placemarks objectAtIndex:indexPath.row]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel:(id)sender
{
    if ([self.delegate conformsToProtocol:@protocol(OTPGeocodeDisambigationViewControllerDelegate)]) {
        [self.delegate userCanceledDisambiguation];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
