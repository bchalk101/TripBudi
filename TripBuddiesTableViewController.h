//
//  TripBuddiesTableViewController.h
//  hikeIt
//
//  Created by Boruch Chalk on 25/08/2015.
//  Copyright © 2015 bchalk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripBuddiesListTableViewController.h"

@class TripBuddiesTableViewController;
@protocol TripBuddiesTableViewControllerDelegate <NSObject>

-(void)tripBuddiesTableViewController:(TripBuddiesTableViewController *)controller tripBuddiesId:(NSString *)tripBuddiesId tripBuddyName:(NSString *)tripBuddyName;
/** Used for sending a group message
 */
-(void)tripBuddiesTableViewController:(TripBuddiesTableViewController *)controller tripBuddiesId:(NSArray *)tripBuddiesArray titleName:(NSString *)titleName;

/**Used for layer conversation view
 */
-(void)tripBuddiesTableViewController:(TripBuddiesTableViewController *)controller conversation:(LYRConversation *)conversation;


/**
 *Used for addButton segue
 */
-(void)tripBuddiesTableViewController:(TripBuddiesTableViewController *)controller;

@end


@interface TripBuddiesTableViewController : UITableViewController <TripBuddiesListTableViewControllerDelegate>

@property (strong, nonatomic) NSString *tripId;
@property (strong, nonatomic) id<TripBuddiesTableViewControllerDelegate> delegate;


- (IBAction)addButtonPressed:(id)sender;
- (IBAction)groupMessageButtonPressed:(id)sender;

@property (nonatomic) LYRConversation *conversation;

@end
