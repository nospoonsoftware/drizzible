//
//  ShotsViewController.m
//  Drizzible
//
//  Created by Jerry Nummi on 7/10/12.
//  Copyright (c) 2012 No Spoon Software. All rights reserved.
//

#import "ShotsViewController.h"
#import "ShotViewController.h"

@interface ShotsViewController ()
@end

@implementation ShotsViewController

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.shots count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shotCell" forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:1];
    
    [imageView setImage: [UIImage imageNamed:@"icon"]];
    
    int expectedRow = indexPath.row;
    
    NSString *url = [[self.shots objectAtIndex: indexPath.row] objectForKey:@"image_url"];
    UIImage *cachedImage = [self.cachedImages objectForKey:url];
    if(cachedImage){
        imageView.image = cachedImage;
    } else {
    
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:
         ^(NSURLResponse *response, NSData *data, NSError *error) {
             if(error) {
                 NSLog(@"%@", error);
             }
             
             if(expectedRow == indexPath.row) {
                 UIImage *image = [UIImage imageWithData:data];
                 imageView.image = image;
                 [self.cachedImages setObject:image forKey:url];
                 [imageView setNeedsDisplay];
             }
         }];
    }

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [[self.dribbbleView indexPathsForSelectedItems] lastObject];
        NSDictionary *object = [[self shots] objectAtIndex:indexPath.row];
        ShotViewController *vc = (ShotViewController *)[segue destinationViewController];
        vc.itemImage = [self.cachedImages objectForKey:[object valueForKey:@"image_url"]];
        vc.itemName = [object valueForKey:@"title"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cachedImages = [NSCache new];
    self.shots = [NSMutableArray new];
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if(self.shots.count > 0) { return; }

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.dribbble.com/shots/popular?per_page=50"]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error) {
         if(error) {
             NSLog(@"%@", error);
         }
         [self parseDatShit: data];
     }];
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
    
    [self.dribbbleView reloadData];
}

- (void)viewDidUnload {
    self.dribbbleView = nil;
    self.shots = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end