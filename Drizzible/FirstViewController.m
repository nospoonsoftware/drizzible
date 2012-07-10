//
//  FirstViewController.m
//  Drizzible
//
//  Created by Jerry Nummi on 7/10/12.
//  Copyright (c) 2012 No Spoon Software. All rights reserved.
//

#import "FirstViewController.h"
#define customRowHeight 150

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize tableView;
@synthesize shots;



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = [shots count];
    return count == 0 ? 1 : count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShotCell"];
    cell.textLabel.text= [[shots objectAtIndex:indexPath.row] objectForKey:@"title"];
    return cell;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shots = [[NSMutableArray alloc] init];
    self.tableView.rowHeight = customRowHeight;
    
    NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: @"http://api.dribbble.com/shots/everyone?per_page=30"]];
    [self performSelectorOnMainThread:@selector(parseDatShit:) withObject:data waitUntilDone:YES];
}

- (void)parseDatShit:(NSData *)responseData {
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData
                          options:NSJSONReadingMutableContainers 
                          error:&error];
    
    for(NSDictionary *shot in [json objectForKey:@"shots"]) {
        [self.shots addObject: shot];
    }
}

- (void)viewDidUnload {
    self.tableView = nil;
    self.shots = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end