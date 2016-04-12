//
//  AddOtherToTripTableViewController.m
//  hikeIt
//
//  Created by Boruch Chalk on 20/09/2015.
//  Copyright © 2015 bchalk. All rights reserved.
//

#import "AddOtherToTripTableViewController.h"

@interface AddOtherToTripTableViewController ()

//Saving Flight Data
@property (strong, nonatomic) NSDictionary *flightInfo;
@property (strong, nonatomic) NSMutableDictionary *allFlights;
@property (strong, nonatomic) NSMutableArray *flightsOnDay;

//Saving Other Activity Data
@property (strong, nonatomic) NSDictionary *otherActivityInfo;
@property (strong, nonatomic) NSMutableDictionary *allOtherActivity;
@property (strong, nonatomic) NSMutableArray *allOtherActivityOnDay;

//Flight Info
@property (strong, nonatomic) NSString *depatureDate;
@property (strong, nonatomic) NSString *destination;
@property (strong, nonatomic) NSString *flightNumber;
@property (strong, nonatomic) NSString *airline;

//Other Activity Info
@property (strong, nonatomic) NSString *otherName;
@property (strong, nonatomic) NSString *otherLocation;
@property (strong, nonatomic) NSString *otherDate;
@property (strong, nonatomic) NSString *otherNotes;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation AddOtherToTripTableViewController
- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)savePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.flightViewController.hidden == NO) {
            Firebase *activityRef = [[self.ref childByAppendingPath:@"trips"] childByAppendingPath:self.tripId];
            [activityRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                NSDictionary *tripData = [NSDictionary dictionaryWithDictionary:snapshot.value];
                
                self.flightInfo = [[NSDictionary alloc] init];
                self.flightsOnDay = [[NSMutableArray alloc] init];
                self.allFlights = [[NSMutableDictionary alloc] init];
                
                NSInteger day = [self numberOfDaysBetween:[tripData objectForKey:@"startDate"] endDate:self.depatureDate];
                NSString *key = [NSString stringWithFormat:@"day%ld",(long)day];
                
                self.flightInfo = @{@"type":@"flight", @"date":self.depatureDate, @"destination":self.destination, @"flightNum":self.flightNumber, @"airline":self.airline};
                
                if ([[tripData objectForKey:@"activities"]  objectForKey:key] == nil) {
                    [self.flightsOnDay addObject:self.flightInfo];
                } else {
                    // Add the event to the list for this day
                    
                    self.flightsOnDay = [[tripData objectForKey:@"activities" ] objectForKey:key];
                    [self.flightsOnDay addObject:self.flightInfo];
                }
                
                if ([tripData objectForKey:@"activities"] != nil) {
                    self.allFlights = [[tripData objectForKey:@"activities" ] mutableCopy];
                    
                }
                
                [self.allFlights setObject:self.flightsOnDay forKey:key];
                //self.tripSelected = eventList;
                // Save
                //[tripRef updateChildValues:eventList];
                [[activityRef childByAppendingPath:@"activities" ] updateChildValues:self.allFlights];
                
            }];
        } else if (self.otherViewController.hidden == NO){
            Firebase *activityRef = [[self.ref childByAppendingPath:@"trips"] childByAppendingPath:self.tripId];
            [activityRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                NSDictionary *tripData = [NSDictionary dictionaryWithDictionary:snapshot.value];
                
                self.otherActivityInfo = [[NSDictionary alloc] init];
                self.allOtherActivityOnDay = [[NSMutableArray alloc] init];
                self.allOtherActivity = [[NSMutableDictionary alloc] init];
                
                NSInteger day = [self numberOfDaysBetween:[tripData objectForKey:@"startDate"] endDate:self.otherDate];
                NSString *key = [NSString stringWithFormat:@"day%ld",(long)day];
                
                self.otherActivityInfo = @{@"type":@"other",@"date":self.otherDate, @"location":self.otherLocation, @"notes":self.otherNotes, @"name":self.otherName};
                
                if ([[tripData objectForKey:@"activities"]  objectForKey:key] == nil) {
                    [self.allOtherActivityOnDay addObject:self.otherActivityInfo];
                } else {
                    // Add the event to the list for this day
                    
                    self.allOtherActivityOnDay = [[tripData objectForKey:@"activities" ] objectForKey:key];
                    [self.allOtherActivityOnDay addObject:self.otherActivityInfo];
                }
                
                if ([tripData objectForKey:@"activities"] != nil) {
                    self.allOtherActivity = [[tripData objectForKey:@"activities" ] mutableCopy];
                    
                }
                
                [self.allOtherActivity setObject:self.allOtherActivityOnDay forKey:key];
                //self.tripSelected = eventList;
                // Save
                //[tripRef updateChildValues:eventList];
                [[activityRef childByAppendingPath:@"activities"] updateChildValues:self.allOtherActivity];
                
            }];

        }
    }];
}


-(NSInteger)numberOfDaysBetween:(NSString *)startDate endDate:(NSString *)endDate {
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"dd/MM/yyyy"];
    NSDate *sDate = [f dateFromString:startDate];
    NSDate *eDate = [f dateFromString:endDate];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:sDate
                                                          toDate:eDate
                                                         options:NSCalendarWrapComponents];
    return [components day];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ref = [[Firebase alloc] initWithUrl:@"tour-budi.firebaseio.com"];
    
    self.flightViewController.hidden = NO;
    self.otherViewController.hidden = YES;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)segmentSwitch:(UISegmentedControl *)sender {
    [self viewControllerForSegmentIndex:sender.selectedSegmentIndex];
}

-(UIViewController *)viewControllerForSegmentIndex:(NSInteger)index {
    UIViewController *vc;
    switch (index) {
        case 0:
            self.otherViewController.hidden = YES;
            self.flightViewController.hidden = NO;
            break;
        case 1:
            self.otherViewController.hidden = NO;
            self.flightViewController.hidden = YES;
            break;
        default:
            break;
    }
    return vc;
}

-(void)AddFlightTableViewControllerDelegate:(AddFlightTableViewController *)controller flightNumber:(NSString *)flightNumber airline:(NSString *)airline destination:(NSString *)destination dateOfTravel:(NSString *)date
{
    self.depatureDate = date;
    self.destination = destination;
    self.flightNumber = flightNumber;
    self.airline = airline;
}

-(void)addOtherDetailsTableViewController:(AddOtherDetailsTableViewController *)controller otherName:(NSString *)otherName otherLocation:(NSString *)otherLocation otherDate:(NSString *)otherDate otherNotes:(NSString *)otherNotes{
    self.otherName = otherName;
    self.otherLocation = otherLocation;
    self.otherDate = otherDate;
    self.otherNotes = otherNotes;
    
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddFlightSegue"]) {
        AddFlightTableViewController *addFlightController = segue.destinationViewController;
        addFlightController.delegate = self;
    } else if([[segue identifier] isEqualToString:@"AddOtherSegue"]){
        AddOtherDetailsTableViewController *destination = segue.destinationViewController;
        destination.delegate = self;
        destination.tripCountry = self.tripCountry;
    }
}


@end
