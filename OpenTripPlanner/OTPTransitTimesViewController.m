//
//  OTPTransitTimesViewController.m
//  OpenTripPlanner
//
//  Created by asutula on 9/6/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPTransitTimesViewController.h"
#import "OTPItineraryViewController.h"
#import "OTPItineraryCell.h"
#import "OTPLegCell.h"
#import "OTPPlaceCell.h"
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
    [TestFlight passCheckpoint:@"ITINERARIES_VIEW"];
    [super viewDidLoad];

    _modeIcons = @{
    @"WALK" : [UIImage imageNamed:@"walk_32.png"],
    @"BICYCLE" : [UIImage imageNamed:@"bike_32.png"],
    @"CAR" : [UIImage imageNamed:@"car_32.png"],
    @"TRAM" : [UIImage imageNamed:@"gondola_32.png"],
    @"SUBWAY" : [UIImage imageNamed:@"train_32.png"],
    @"RAIL" : [UIImage imageNamed:@"train_32.png"],
    @"BUS" : [UIImage imageNamed:@"bus_32.png"],
    @"FERRY" : [UIImage imageNamed:@"ferry_32.png"],
    @"CABLE_CAR" : [UIImage imageNamed:@"cable-car_32.png"],
    @"GONDOLA" : [UIImage imageNamed:@"gondola_32.png"],
    @"TRANSFER" : [UIImage imageNamed:@"transfer_32.png"],
    @"FUNICULAR" : [UIImage imageNamed:@"funicular_32.png"]
    };

    self.headerFromLabel.text = self.fromTextField.text;
    self.headerToLabel.text = self.toTextField.text;
    self.headerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.headerView.layer.shadowOpacity = 0.2;
    self.headerView.layer.shadowRadius = 2;
    self.headerView.layer.shadowOffset = CGSizeMake(0, 2);
    
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
    if (section == 0) {
        return self.itineraries.count;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return @"Select a Trip:";
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"itineraryCell";
        OTPItineraryCell *cell = (OTPItineraryCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.tag = indexPath.row;
        
        // Get the itinerary
        Itinerary *itinerary = [self.itineraries objectAtIndex:indexPath.row];
        
        // Store the itinerary for the collection view
        OTPItineraryCollectionView *collView = cell.collectionView;
        collView.itinerary = itinerary;
            
        // Set the duration label
        cell.durationLabel.text = [NSString stringWithFormat:@"%d min", itinerary.duration.intValue/60000];
        
        // Set start and end times
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"h:mm a"];
        cell.startTimeLabel.text = [NSString stringWithFormat:@"START %@", [formatter stringFromDate:itinerary.startTime]];
        cell.endTimeLabel.text = [NSString stringWithFormat:@"END %@", [formatter stringFromDate:itinerary.endTime]];

        int legCnt = 0;
        for(Leg *leg in itinerary.legs)
        {
            if ([leg.mode isEqualToString:@"TRANSFER"] == false) {
                legCnt++;
            }
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)collectionView:(OTPItineraryCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // We have to adjust the number of cells to ignore transfer legs.
    int transferCount = 0;
    for (Leg *leg in collectionView.itinerary.legs) {
        if ([leg.mode isEqualToString:@"TRANSFER"]) {
            transferCount++;
        }
    }
    return collectionView.itinerary.legs.count - transferCount;
}

- (UICollectionViewCell *)collectionView:(OTPItineraryCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"legCell";
    OTPLegCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // We have to find the leg to display ignoring transfer legs. We can't use the indexPath.row directly because of this.
    Leg *leg;
    int nonTransferCount = 0;
    for (Leg *legToTry in collectionView.itinerary.legs) {
        if ([legToTry.mode isEqualToString:@"TRANSFER"]) {
            continue;
        }
        
        if (nonTransferCount == indexPath.row) {
            leg = legToTry;
            break;
        }
        nonTransferCount++;
    }
    
    if ([leg.mode isEqualToString:@"TRANSFER"] == false) {
        cell.legImageView.image = [_modeIcons objectForKey:leg.mode];
        if ([leg.mode isEqualToString:@"WALK"] || [leg.mode isEqualToString:@"BICYCLE"]) {
            OTPUnitFormatter *unitFormatter = [[OTPUnitFormatter alloc] init];
            unitFormatter.cutoffMultiplier = @3.28084F;
            unitFormatter.unitData = @[
            [OTPUnitData unitDataWithCutoff:@100 multiplier:@3.28084F roundingIncrement:@10 singularLabel:@"ft" pluralLabel:@"ft"],
            [OTPUnitData unitDataWithCutoff:@528 multiplier:@3.28084F roundingIncrement:@100 singularLabel:@"ft" pluralLabel:@"ft"],
            [OTPUnitData unitDataWithCutoff:@INT_MAX multiplier:@0.000621371F roundingIncrement:@0.1F singularLabel:@"mi" pluralLabel:@"mi"]
            ];
            
            cell.legLabel.text = [unitFormatter numberToString:leg.distance];
        } else {
            cell.legLabel.text = leg.route.capitalizedString;
        }
        
        return cell;
    } else {
        return nil;
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [TestFlight passCheckpoint:@"ITINERARIES_SELECTED_ONE"];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    OTPItineraryViewController *vc = (OTPItineraryViewController *)segue.destinationViewController;
    vc.itinerary = [self.itineraries objectAtIndex:indexPath.row];
    vc.fromTextField = self.fromTextField;
    vc.toTextField = self.toTextField;
    vc.mapShowedUserLocation = self.mapShowedUserLocation;
}


- (void)dismiss:(id)sender
{
    [TestFlight passCheckpoint:@"ITINERARIES_DONE"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
