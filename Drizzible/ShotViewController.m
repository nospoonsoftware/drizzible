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
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UINavigationBar *toolbar;
@end

@implementation ShotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.itemImage){
        self.detailImageView.image = self.itemImage;
    }
    
    if(self.itemName){
        self.toolbar.topItem.title = self.itemName;
    }
}

- (IBAction)openMail:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        [mailer setMailComposeDelegate:self];
        [mailer setModalPresentationStyle: UIModalPresentationFormSheet];
        [mailer setMessageBody:self.itemURL isHTML:NO];
        [mailer setSubject:@"Shot from Dribbble"];
        [mailer addAttachmentData:UIImagePNGRepresentation(self.detailImageView.image)
                         mimeType:@"image/png"
                         fileName:@"shot"];
        [self presentModalViewController:mailer animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
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

-(IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end