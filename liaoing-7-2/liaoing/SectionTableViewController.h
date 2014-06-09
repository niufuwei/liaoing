//
//  SectionTableViewController.h
//  SectionTable
//
//  Created by tony on 11-4-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate> {
	NSMutableDictionary *allteams;
	NSMutableDictionary *teams;
	NSArray *teamsname;
	UITableView *tableView;
	
}

@property (nonatomic,retain) NSMutableDictionary *teams;
@property (nonatomic,retain) NSMutableDictionary *allteams;
@property (nonatomic,retain) NSArray *teamsname;

//@property (nonatomic,retain)  UISearchBar *search;

-(void)resetSearch;

@end

