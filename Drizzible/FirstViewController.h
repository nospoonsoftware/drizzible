//
//  FirstViewController.h
//  Drizzible
//
//  Created by Jerry Nummi on 7/10/12.
//  Copyright (c) 2012 No Spoon Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *dribbbleView;
@property (strong, nonatomic) NSMutableArray *shots;

@end
