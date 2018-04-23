//
//  ViewController.h
//  datapassing
//
//  Created by sunil  on 23/10/16.
//  Copyright © 2016 sunil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ViewController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UITextField *txtFname,*txtLname,*txtEmail,*txtCompany,*txtCity,*txtNumber;
    UISwitch *swch;
    NSNumber *timercount;
    NSTimer *timer;
    int secondscount,secondscount1;
}
- (IBAction)btnSubmit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property(strong,nonatomic)NSMutableArray *array;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
- (IBAction)btnCancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *lblMsg;

@property (weak, nonatomic) IBOutlet UILabel *lblImage;
@property (weak, nonatomic) IBOutlet UILabel *lblTimerCount;

- (IBAction)btnNext:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnTitle;


@end

