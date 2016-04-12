//
//  TripBuddiesTableViewController.m
//  hikeIt
//
//  Created by Boruch Chalk on 25/08/2015.
//  Copyright © 2015 bchalk. All rights reserved.
//

#import "TripBuddiesTableViewController.h"
#import "TripBuddiesListTableViewController.h"

@interface TripBuddiesTableViewController ()

@property (strong, nonatomic) NSString *tripBuddyId;
@property (strong, nonatomic) NSMutableArray *tripBuddiesArray;

@end

@implementation TripBuddiesTableViewController

@synthesize tripBuddyId = _tripBuddyId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"BuddiesListSegue"]) {
        TripBuddiesListTableViewController *buddieListView = segue.destinationViewController;
        buddieListView.delegate = self;
        buddieListView.tripId = self.tripId;
    }
}

-(void)tripBuddiesListTableViewController:(TripBuddiesListTableViewController *)view tripBuddyId:(NSString *)tripBuddyId tripBuddyName:(NSString *)name{
    _tripBuddyId = tripBuddyId;
    [self.delegate tripBuddiesTableViewController:self tripBuddiesId:_tripBuddyId tripBuddyName:name];
}

-(void)tripBuddiesListTableViewController:(TripBuddiesListTableViewController *)view conversation:(LYRConversation *)conversation{
    [self.delegate tripBuddiesTableViewController:self
                                     conversation:conversation];
}

-(void)addButtonPressed:(id)sender{
    [self.delegate tripBuddiesTableViewController:self];
}
- (void)groupMessageButtonPressed:(id)sender {
    [self.tripBuddiesArray removeAllObjects];

    PFQuery *queryT = [PFQuery queryWithClassName:@"trips"];
    [queryT getObjectInBackgroundWithId:self.tripId block:^(PFObject *trip, NSError *error){
        if (!error) {
            self.tripBuddiesArray = [NSMutableArray arrayWithArray:trip[@"tripBuddies"]];
            [self.delegate tripBuddiesTableViewController:self tripBuddiesId:self.tripBuddiesArray titleName:@"Group Message"];

        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];
    }
@end
