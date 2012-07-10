//
//  FirstViewController.m
//  Drizzible
//
//  Created by Jerry Nummi on 7/10/12.
//  Copyright (c) 2012 No Spoon Software. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()
@end

@implementation FirstViewController

@synthesize tableView, shots;



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [shots count];
}

- (UITableViewCell *)tableView:(UITableView *)theTable cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell      = [theTable dequeueReusableCellWithIdentifier:@"ShotCell"];
    UIImageView     *imageView = (UIImageView*)[cell viewWithTag:1];

    [imageView setImage: [UIImage imageNamed:@"icon"]];
    

    NSString *url = [[shots objectAtIndex: indexPath.row] objectForKey:@"image_url"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
                             
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error) {
         if(error) {
             NSLog(@"%@", error);
         }
         imageView.image = [UIImage imageWithData:data];
         [imageView setNeedsDisplay];
     }];
    
    return cell;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shots = [[NSMutableArray alloc] init];
    self.tableView.rowHeight = 150;
    
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