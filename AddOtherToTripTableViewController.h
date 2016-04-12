//
//  AddOtherToTripTableViewController.h
//  hikeIt
//
//  Created by Boruch Chalk on 20/09/2015.
//  Copyright © 2015 bchalk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddFlightTableViewController.h"
#import "AddOtherDetailsTableViewController.h"
#import <Parse/Parse.h>
#import <Firebase/Firebase.h>

@interface AddOtherToTripTableViewController : UITableViewController <AddFlightTableViewControllerDelegate, AddOtherDetailsDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIView *flightViewController;
@property (strong, nonatomic) IBOutlet UIView *otherViewController;

@property (strong, nonatomic) NSString *tripId;
@property (strong, nonatomic) NSString *tripCountry;

@property (strong, nonatomic) Firebase *ref;

@end
