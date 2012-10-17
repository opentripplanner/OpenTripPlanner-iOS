//
//  OTPTransitTimesViewController.m
//  OpenTripPlanner
//
//  Created by asutula on 9/6/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPTransitTimesViewController.h"
#import "OTPItineraryTableViewController.h"
#import "OTPItineraryCell.h"
#import "OTPLegCell.h"
#import "OTPUnitData.h"
#import "OTPUnitFormatter.h"

#import "Itinerary.h"


@interface OTPTransitTimesViewController ()
{
NSDictionary *_modeIcons;
}
@end

@implementation OTPTransitTimesViewController

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

    _modeIcons = @{
        @"WALK" : [UIImage imageNamed:@"temp_walk.png"],
        @"BICYCLE" : [UIImage imageNamed:@"temp_bicycle.png"],
        @"CAR" : [UIImage imageNamed:@"temp_car.png"],
        @"TRAM" : [UIImage imageNamed:@"temp_tram.png"],
        @"SUBWAY" : [UIImage imageNamed:@"temp_subway.png"],
        @"RAIL" : [UIImage imageNamed:@"temp_train.png"],
        @"BUS" : [UIImage imageNamed:@"temp_bus.png"],
        @"FERRY" : [UIImage imageNamed:@"temp_ferry.png"],
        @"CABLE_CAR" : [UIImage imageNamed:@"temp_cablecar.png"],
        @"GONDOLA" : [UIImage imageNamed:@"temp_gondola.png"],
        // TODO: FIX THESE
        @"FUNICULAR" : [UIImage imageNamed:@"temp_train.png"],
        @"TRANSFER" : [UIImage imageNamed:@"temp_walk.png"]
    };

    
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
    return self.itineraries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"itineraryCell";
    OTPItineraryCell *cell = (OTPItineraryCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Get the itinerary
    Itinerary *itinerary = [self.itineraries objectAtIndex:indexPath.row];
    
    // Store the itinerary for the collection view
    OTPItineraryCollectionView *collView = cell.collectionView;
    collView.exclusiveTouch = NO;
    collView.itinerary = itinerary;
        
    // Set the duration label
    cell.durationLabel.text = [NSString stringWithFormat:@"%d", itinerary.duration.intValue/60000];
    
    // Set start and end times
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm a"];
    cell.startTimeLabel.text = [formatter stringFromDate:itinerary.startTime];
    cell.endTimeLabel.text = [formatter stringFromDate:itinerary.endTime];
    
    return cell;
}

- (NSInteger)collectionView:(OTPItineraryCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (NSInteger)collectionView.itinerary.legs.count;
}

- (UICollectionViewCell *)collectionView:(OTPItineraryCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"legCell";
    OTPLegCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    Leg *leg = [collectionView.itinerary.legs objectAtIndex:indexPath.row];
    
    cell.legImageView.image = [_modeIcons objectForKey:leg.mode];
    if ([leg.mode isEqualToString:@"WALK"] == false) {
        cell.legLabel.text = leg.route;
    } else {
        OTPUnitFormatter *unitFormatter = [[OTPUnitFormatter alloc] init];
        unitFormatter.cutoffMultiplier = @3.28084F;
        unitFormatter.unitData = @[
        [OTPUnitData unitDataWithCutoff:@100 multiplier:@3.28084F roundingIncrement:@10 singularLabel:@"ft" pluralLabel:@"ft"],
        [OTPUnitData unitDataWithCutoff:@528 multiplier:@3.28084F roundingIncrement:@100 singularLabel:@"ft" pluralLabel:@"ft"],
        [OTPUnitData unitDataWithCutoff:@INT_MAX multiplier:@0.000621371F roundingIncrement:@0.1F singularLabel:@"mi" pluralLabel:@"mi"]
        ];
        
        cell.legLabel.text = [unitFormatter numberToString:leg.distance];
    }

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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    [(OTPItineraryTableViewController *)segue.destinationViewController setItinerary:[self.itineraries objectAtIndex:indexPath.row]];
}



- (void)dismiss:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
