//
//  ShotViewController.h
//  Drizzible
//
//  Created by Jerry Nummi on 9/25/12.
//  Copyright (c) 2012 No Spoon Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface ShotViewController : UIViewController <MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSString *itemURL;
@property (strong, nonatomic) UIImage *itemImage;
-(IBAction)done:(id)sender;
-(IBAction)openMail:(id)sender;
@end