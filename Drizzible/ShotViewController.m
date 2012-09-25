//
//  ShotViewController.m
//  Drizzible
//
//  Created by Jerry Nummi on 7/10/12.
//  Copyright (c) 2012 No Spoon Software. All rights reserved.
//

#import "ShotViewController.h"
#import "ShotsViewController.h"

@interface ShotViewController ()
@property (weak, nonatomic)   IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic)   IBOutlet UINavigationBar *toolbar;
@end

@implementation ShotViewController

- (void)setItemImage:(UIImage *)itemImage{
    self.detailImageView.image = itemImage;
    [self.detailImageView setNeedsDisplay];
    _itemImage = itemImage;
}

- (void)setItemName:(NSString *)itemName{
    if([self.itemName isEqualToString:itemName]) return;
    self.toolbar.topItem.title = itemName;
    self.title = itemName;
    _itemName = itemName;
    [self.view setNeedsLayout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if(self.itemImage){
        self.detailImageView.image = self.itemImage;
    }
    
    if(self.itemName){
        self.toolbar.topItem.title = self.itemName;
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

-(IBAction)done:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end