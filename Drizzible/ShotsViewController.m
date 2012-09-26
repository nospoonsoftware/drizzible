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
@property (nonatomic, strong) NSCache *cachedImages;

- (void)requestShots:(void(^)(NSData *data))complete;
- (NSArray *)serializeJSONData:(NSData *)responseData;
@end

@implementation ShotsViewController

#pragma mark -
#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [[self.dribbbleView indexPathsForSelectedItems] lastObject];
        NSDictionary *object   = [[self shots] objectAtIndex:indexPath.row];
        ShotViewController *vc = (ShotViewController *)[segue destinationViewController];
        vc.itemImage = [self.cachedImages objectForKey:[object valueForKey:@"image_url"]];
        vc.itemName  = [object valueForKey:@"title"];
        vc.itemURL   = [object valueForKey:@"url"];
    }
}

#pragma mark -
#pragma mark Shots stuff

- (void)requestShots:(void(^)(NSData *data))complete {
    if(self.shots.count > 0) { return; }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.dribbble.com/shots/popular?per_page=50"]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error) {
         if(error)
             NSLog(@"%@", error);

         if(complete)
             complete(data);
     }];
}

- (NSArray *)serializeJSONData:(NSData *)responseData {
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:NSJSONReadingMutableContainers
                          error:&error];
    NSMutableArray *tempShotsArr = [NSMutableArray arrayWithCapacity:0];
    for(NSDictionary *shot in [json objectForKey:@"shots"]) {
        [tempShotsArr addObject: shot];
    }
    
    return [NSArray arrayWithArray:tempShotsArr];
}

#pragma mark -
#pragma mark View Events and Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cachedImages = [NSCache new];
    self.shots        = [NSMutableArray new];
}

- (void)viewDidUnload {
    self.dribbbleView = nil;
    self.shots = nil;
    [super viewDidUnload];
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self requestShots:^(NSData *data){
        if(data){
            self.shots = [self serializeJSONData: data];
            [self.dribbbleView reloadData];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Data load failed."
                                       message:@"could not process at this time."
                                      delegate:self cancelButtonTitle:@"ok"
                             otherButtonTitles: nil] show];
        }
    }];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark -
#pragma mark CollectionView Delegate Method

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
             if(error) { NSLog(@"%@", error); }

             if(expectedRow == indexPath.row) {
                 UIImage *image  = [UIImage imageWithData:data];
                 imageView.image = image;
                 [self.cachedImages setObject:image forKey:url];
                 [imageView setNeedsDisplay];
             }
         }];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
}

@end