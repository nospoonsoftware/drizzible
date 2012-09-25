//
//  ShotViewController.h
//  Drizzible
//
//  Created by Jerry Nummi on 9/25/12.
//  Copyright (c) 2012 No Spoon Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShotViewController : UIViewController
@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) UIImage *itemImage;
-(IBAction)done:(id)sender;
@end