//
//  mainViewController.h
//  datapassing
//
//  Created by sunil  on 13/12/16.
//  Copyright © 2016 sunil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mainViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtLogin;
- (IBAction)btnSubmit:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)btnlOGIN:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnHide;

@end
