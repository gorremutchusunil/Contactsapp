//
//  mainViewController.m
//  datapassing
//
//  Created by sunil  on 13/12/16.
//  Copyright © 2016 sunil. All rights reserved.
//

#import "mainViewController.h"
#import "UIColor+Color.h"

@interface mainViewController ()
{
    CGAffineTransform transform;
}

@end
// This is defined in Math.h
#define M_PI   3.14159265358979323846264338327950288   /* pi */

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) (angle / 360.0 * M_PI)

@implementation mainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor=[UIColor Mycolor];
    _txtLogin.hidden=YES;
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(datetime)
                                   userInfo:nil
                                    repeats:YES];
   // _imageView.layer.cornerRadius = _imageView.frame.size.width / 2;
   // _imageView.clipsToBounds = YES;
    [self startApp];
    // Do any additional setup after loading the view.
}
- (void)startApp
{
    self.imageView.image=[UIImage imageNamed:@"road.jpg"];
    [self rotateImage:self.imageView duration:3.0
                curve:UIViewAnimationOptionRepeat degrees:360];
}
- (void)rotateImage:(UIImageView *)image duration:(NSTimeInterval)duration
              curve:(int)curve degrees:(CGFloat)degrees
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationRepeatCount:15.0];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform =CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
    image.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
}

-(void)viewWillAppear:(BOOL)animated{
    [self datetime];
      self.imageView.image=[UIImage imageNamed:@"road.jpg"];
   
//        NSArray *imgsArray = [NSArray arrayWithObjects:
//                              [UIImage imageNamed:@"ME.jpg"],
//                              [UIImage imageNamed:@"road.jpg"],
//                              [UIImage imageNamed:@"n.jpg"],
//                              [UIImage imageNamed:@"apple2.jpeg"],[UIImage imageNamed:@"apple3.jpeg"],[UIImage imageNamed:@"s1.jpeg"],[UIImage imageNamed:@"s5.jpeg"],nil];
//        [_imageView setAnimationImages:imgsArray];
//        [_imageView setAnimationDuration:15];
//        [_imageView setAnimationRepeatCount:30];
//        [_imageView startAnimating];
   
}

-(void)datetime{
    NSDate *currentdate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"dd-MM-yyyy eee"];
    _lblDate.text=[dateformatter stringFromDate:currentdate];
    NSDate *currenttime=[NSDate date];
    NSDateFormatter *timeformatter=[[NSDateFormatter alloc]init];
    [timeformatter setDateFormat:@"hh:mm:ss"];
    _lblTime.text=[timeformatter stringFromDate:currenttime];
}

- (IBAction)btnSubmit:(id)sender {
    if ([_txtLogin.text isEqual:@"sunil"]) {
        [self performSegueWithIdentifier:@"login" sender:nil];
        _txtLogin.text=@"";
    }else if (_txtLogin.text.length==0){
        [self alertshow:@"Please Enter Key"];
    }else{
        [self alertshow:@"Please Enter Valid Key"];
          _txtLogin.text=@"";
    }
}

-(void)alertshow:(NSString *)message{
  UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"App Alert" message:message delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
}
- (IBAction)btnlOGIN:(id)sender {
    _txtLogin.hidden=NO;
    _btnHide.hidden=YES;
    
}

@end
