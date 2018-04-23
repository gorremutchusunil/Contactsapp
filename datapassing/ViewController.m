//
//  ViewController.m
//  datapassing
//
//  Created by sunil  on 23/10/16.
//  Copyright © 2016 sunil. All rights reserved.
//

#import "ViewController.h"
#import "nextViewController.h"
#import "UIColor+Color.h"


@interface ViewController ()
{
    BOOL ispaused;
    UIActivityIndicatorView *indicatorview;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Login Page";
    [self getdbpath];
    [self copydatabase];
    [self textfield];
    [self gesture];
    [self timercountdown];
      //  self.view.backgroundColor=[UIColor colorWithDisplayP3Red:163.0/255.0  green:121.0/255.0 blue:97.0/255.0 alpha:1];
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"ME.jpg"]];
      _lblMsg.text=@"@All Copy Rights Reserved:Sunilkalyan";
    _pickerView.hidden=YES;
    _pickerView.delegate=self;
    _pickerView.dataSource=self;
    _array=[[NSMutableArray alloc]initWithObjects:@"Hyderabad",@"New Delhi",@"Chennai",@"MumbaiCity",@"Vishakapatnam",@"Bangalore",@"Kolkata",@"Coimbatore",@"Ghandi Nagar",@"Bhopal", nil];
   }

#pragma Timer Countdown

-(void)timercountdown{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(countDown)
                                           userInfo:nil
                                            repeats:YES];
    secondscount = 180;
}

-(void)countDown {
    if (ispaused==NO) {
        secondscount=secondscount-1;
        int minutes=secondscount/60;
        int seconds=secondscount-(minutes*60);
        _lblTimerCount.text=[NSString stringWithFormat:@"%2d:%2d",minutes, seconds];
        if (secondscount==0) {
            [timer invalidate];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [self showalert:@"Time Up"];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    ispaused=YES;
}
-(void)viewWillAppear:(BOOL)animated{
    }
-(void)viewDidAppear:(BOOL)animated{
    ispaused=NO;
}

#pragma imagepicker

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setAllowsEditing:YES];
    [imagePicker setDelegate:self];
    
    //place image picker on the screen
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    if (chosenImage==nil) {
        chosenImage=[info objectForKey:UIImagePickerControllerEditedImage];
    }
    self.imageV.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    _lblImage.text=@"";
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma getting database

-(void)copydatabase
{
    NSString *path=[self getdbpath];
    if (![[NSFileManager defaultManager]fileExistsAtPath:path]) {
       NSString *bundlepath= [[NSBundle mainBundle]pathForResource:@"sunil" ofType:@"sqlite"];
        [[NSFileManager defaultManager]copyItemAtPath:bundlepath toPath:path error:nil];
    }
}
-(NSString *)getdbpath{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filepath=[path stringByAppendingPathComponent:@"sunil.sqlite"];
    NSLog(@"%@",filepath);
    return filepath;
}

#pragma inserting data into database

-(void)executequery{
    
    sqlite3 *dbobj=nil;
    sqlite3_stmt *statement=nil;
    NSString *dbpath=[self getdbpath];
    if (sqlite3_open([dbpath UTF8String],&dbobj)==SQLITE_OK){
    NSString  *insertquery= [NSString stringWithFormat:@"INSERT INTO student(fname,lname,email,company,city,number,image)values(?,?,?,?,?,?,?)"] ;
        if (sqlite3_prepare_v2(dbobj,[insertquery UTF8String],-1,&statement,NULL)==SQLITE_OK){
        sqlite3_bind_text(statement, 1, [txtFname.text UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [txtLname.text UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [txtEmail.text UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [txtCompany.text UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 5, [txtCity.text UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 6, [txtNumber.text UTF8String], -1, SQLITE_TRANSIENT);
            NSData *imagedata=UIImagePNGRepresentation(self.imageV.image);
            sqlite3_bind_blob(statement, 7, [imagedata bytes],(unsigned) [imagedata length], SQLITE_TRANSIENT);
        if (sqlite3_step(statement)== SQLITE_DONE) {
        NSLog(@"Query is Executed Successfully");
        }else{
                NSLog(@"Query excution Error %s",sqlite3_errmsg(dbobj));
            }
        }else{
            NSLog(@"Query Preparation Error %s",sqlite3_errmsg(dbobj));
        }
    }else{
        NSLog(@"DB Connection Error %s",sqlite3_errmsg(dbobj));
    }
}

#pragma textfields initialise

-(void)textfield{
    txtFname=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+10,self.view.frame.origin.y+ 170, self.view.frame.size.width-20, 30)];
    txtFname.borderStyle=UITextBorderStyleNone;
    txtFname.placeholder=@"First Name";
    txtFname.delegate=self;
    txtFname.clearButtonMode=YES;
    [self SetTextFieldBorder:txtFname];
    [self.view addSubview:txtFname];
    txtLname=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+10,self.view.frame.origin.y+220, self.view.frame.size.width-20, 30)];
    txtLname.borderStyle=UITextBorderStyleNone;
    txtLname.placeholder=@"Last Name";
    txtLname.delegate=self;
    txtLname.autocapitalizationType=UITextAutocapitalizationTypeWords;
    txtLname.clearButtonMode=YES;
    [self SetTextFieldBorder:txtLname];
    [self.view addSubview:txtLname];
    txtEmail=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+10,self.view.frame.origin.y+270, self.view.frame.size.width-20, 30)];
    txtEmail.borderStyle=UITextBorderStyleNone;
    txtEmail.placeholder=@"Email";
    txtEmail.delegate=self;
    txtEmail.autocapitalizationType=UITextAutocapitalizationTypeNone;
    txtEmail.clearButtonMode=YES;
    [self SetTextFieldBorder:txtEmail];
    [self.view addSubview:txtEmail];
    txtCompany=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+10,self.view.frame.origin.y+320, self.view.frame.size.width-20, 30)];
    txtCompany.borderStyle=UITextBorderStyleNone;
    txtCompany.placeholder=@"Company";
    txtCompany.delegate=self;
    txtCompany.clearButtonMode=YES;
    [self SetTextFieldBorder:txtCompany];
    [self.view addSubview:txtCompany];
    txtCity=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+10,self.view.frame.origin.y+370, self.view.frame.size.width-20, 30)];
    txtCity.borderStyle=UITextBorderStyleNone;
    txtCity.placeholder=@"Select City";
    txtCity.delegate=self;
   // txtCity.userInteractionEnabled=NO;
    [self SetTextFieldBorder:txtCity];
    [self.view addSubview:txtCity];
    txtNumber=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+10,self.view.frame.origin.y+420, self.view.frame.size.width-20, 30)];
    txtNumber.borderStyle=UITextBorderStyleNone;
    txtNumber.placeholder=@"Mobile Number";
    txtNumber.delegate=self;
    txtNumber.clearButtonMode=YES;
    [self SetTextFieldBorder:txtNumber];
    [self.view addSubview:txtNumber];
   
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField==txtCity) {
        _pickerView.hidden=NO;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField==txtCity) {
        _pickerView.hidden=YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma pickerview delegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _array.count;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   txtCity.text = [_array objectAtIndex:row];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_array objectAtIndex:row];
}
#pragma textfield validations

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == txtFname)
    {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    else if (textField == (txtCity)){
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    else if (textField==txtNumber){
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }

    else if (textField == txtCompany){
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@" "];
        return [string isEqualToString:filtered];
    }
    if (textField==txtLname) {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
       else
        return YES;
}
- (BOOL)validateEmailWithString:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
  //  nextViewController *details=[segue destinationViewController];
//    details.str1=[NSString stringWithFormat:@"%@ %@",txtFname.text,txtLname.text];
//    details.str2=txtEmail.text;
//    details.str3=txtCompany.text;
//    details.str4=txtCity.text;
   // details.str5=txtNumber.text;
   // details.str6=txtLname.text;
//}

#pragma save button action

- (IBAction)btnSubmit:(id)sender {
    
//    for (int i=0; i<_sunilarray.count; i++) {
//        sunil *dbobj=[_sunilarray objectAtIndex:i];
//        if ([dbobj.Location isEqualToString:self.placeTxt.text]) {
//            [self showalert:@"Record Already Exists"];
//            return;
//        }
//    }
    
    if (txtFname.text.length==0 && txtLname.text.length==0 && txtCity.text.length==0 && txtNumber.text.length==0 && txtEmail.text.length==0 && txtCompany.text.length==0) {
       // [self showalert:@"Please Fill all fields"];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please fill all Fields" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];

    }
    else if (txtFname.text.length==0) {
        [self showalert:@"Please enter first name"];
    }else if (txtLname.text.length==0){
        [self showalert:@"Please enter last name"];
    }
    else if (![self validateEmailWithString:txtEmail.text]) {
        [self showalert:@"Please Enter Valid Email"];
    }else if (txtCity.text.length==0) {
        [self showalert:@"Please select city"];
    }else if (txtCompany.text.length==0) {
        [self showalert:@"Please enter company"];
    }else if (txtNumber.text.length==0){
        [self showalert:@"Please enter mobile number"];
    }
    else if (txtNumber.text.length<=9 || txtNumber.text.length>10){
        [self showalert:@"Required 10 digits mobile number"];
    }
    else if (_imageV.image ==NULL){
    
        [self showalert:@"Please Upload image"];
    }
    else{
        [self executequery];
        [self performSegueWithIdentifier:@"next" sender:nil];
        [self clearmethod];
    }
}
- (IBAction)btnCancel:(id)sender {
    
    [self clearmethod];
    _pickerView.hidden=YES;
    
}
#pragma alertview

-(void)showalert:(NSString *)message{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"alert" message:message delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
}
#pragma switch statements

-(void)gesture{
    _imageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapRecognizer.numberOfTapsRequired = 1;
    self.imageV.layer.cornerRadius = self.imageV.frame.size.width / 2;
    self.imageV.clipsToBounds = YES;
    [_imageV addGestureRecognizer:tapRecognizer];
}

#pragma clear method

-(void)clearmethod{
   txtNumber.text=@"";
    txtEmail.text=@"";
    txtLname.text=@"";
    txtCity.text=@"";
    txtCompany.text=@"";
    txtFname.text=@"";
    _imageV.image=NULL;
    _lblImage.text=@"Upload Image";
   }

- (IBAction)btnDb:(id)sender {
    [self performSegueWithIdentifier:@"next" sender:nil];
}
- (IBAction)btnNext:(id)sender {
    
    [self performSegueWithIdentifier:@"next" sender:nil];
}

-(void)SetTextFieldBorder :(UITextField *)textField{
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 2;
    border.borderColor = [UIColor lightGrayColor].CGColor;
    border.frame = CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height);
    border.borderWidth = borderWidth;
    [textField.layer addSublayer:border];
    textField.layer.masksToBounds = YES;
    
}

@end
