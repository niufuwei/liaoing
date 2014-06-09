//
//  SectionTableViewController.m
//  SectionTable
//
//  Created by tony on 11-4-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SectionTableViewController.h"

@implementation SectionTableViewController

@synthesize teams;
@synthesize allteams;
@synthesize teamsname;
//@synthesize search;


-(void)resetSearch {

	self.teams = self.allteams ;
	
	NSMutableArray *keysArray = [[NSMutableArray alloc] init];
	[keysArray addObjectsFromArray:[[teams allKeys] sortedArrayUsingSelector:@selector(compare:)]];
	self.teamsname = keysArray;
	
	
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    self.navigationItem.leftBarButtonItem = [self barButtonItemWithNormalImageName:@"navBackBtn.png"
                                                              highlightedImageName:nil
                                                                            target:self
                                                                            action:@selector(backBtn:)];
    self.navigationItem.rightBarButtonItem = [self barButtonItemWithNormalImageName:nil
                                                               highlightedImageName:nil
                                                                              title:@"zhegnzhou"
                                                                             target:self
                                                                             action:nil];
                                              
    self.title=@"切换城市";
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    //    tableView.backgroundColor = [UIColor colorWithRed:252.0f/255.0f green:252.0f/255.0f blue:252.0f/255.0f alpha:1.0f];
    tableView.backgroundColor = [UIColor clearColor];
    //  tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    
    
	NSBundle *bundle = [NSBundle mainBundle];
	NSString *filePath = [bundle pathForResource:@"city" ofType:@"plist"];
	
	NSMutableDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
	self.allteams = dict;
	[self resetSearch];

}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	[super viewDidUnload];
	self.teams = nil;
	self.teamsname = nil;
	
}

- (void)dealloc {
	

}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [self.tabBarController.tabBar setHidden:YES];
}

#pragma mark -- 实现TableView数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	
	NSString *name = [teamsname objectAtIndex:section];
	NSArray *team = [teams objectForKey:name];
	return [team count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [teamsname count];	
}

- (NSString *)tableView:(UITableView *)tableView 
			titleForHeaderInSection:(NSInteger)section {
	NSString *name = [teamsname objectAtIndex:section];
	return name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
	NSString *name = [teamsname objectAtIndex:section];
	NSArray *team = [teams objectForKey:name];
	
	static NSString *SimpleCellIdentifier = @"SimpleCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleCellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									   reuseIdentifier:SimpleCellIdentifier] ;
	}
	
	cell.textLabel.text = [team objectAtIndex:row];

	return cell;
	
}

/*
 增加索引
 */
-(NSArray *) sectionIndexTitlesForTableView: (UITableView *) tableView {

	return teamsname;
}


#pragma mark --实现TableView委托方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
	NSString *name = [teamsname objectAtIndex:section];
	NSArray *team = [teams objectForKey:name];	
	NSString *selectedteam = [team objectAtIndex:row];
	
	NSString *message = [[NSString alloc] initWithFormat:@"你选择了%@队。", 
						 selectedteam];
	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"行选择" 
											message:message 
											delegate:self 
											cancelButtonTitle:@"Ok" 
											otherButtonTitles:nil];
	
	
	[alert show];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    

}

#pragma mark --实现UISearchBar委托方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"1");
    
	if ([searchText length] == 0) {
		[self resetSearch];
		return;
	}
	
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	
	
	for (NSString *key in self.allteams) {
		NSMutableArray *arry = [allteams valueForKey:key];
		NSMutableArray *newTeams = [[NSMutableArray alloc] init];
		
		for (NSString *teamName in arry) {
			if ([teamName rangeOfString: searchText
								options:NSCaseInsensitiveSearch].location != NSNotFound) {
				[newTeams addObject:teamName];
			}
		}
		
		if ([newTeams count] > 0) {
			[dict setObject:newTeams forKey:key];
		}
		
	}

	self.teamsname = [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
	self.teams = dict;
	
	
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[self resetSearch];
}


@end
