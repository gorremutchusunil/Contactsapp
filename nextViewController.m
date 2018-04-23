//
//  nextViewController.m
//  datapassing
//
//  Created by sunil  on 23/10/16.
//  Copyright © 2016 sunil. All rights reserved.
//

#import "nextViewController.h"
#import "ViewController.h"
#import "UIColor+Color.h"

@interface nextViewController ()
{
    NSMutableArray *dataarray;
    UILabel *label1,*label2;
}

@end

@implementation nextViewController

- (void)viewDidLoad {
    [self getdbpath];
    [self copydatabase];
    [self fetchdata];
    [super viewDidLoad];
    self.navigationItem.hidesBackButton=YES;
}
-(void)viewWillAppear:(BOOL)animated{
   
}

#pragma getting database

-(NSString *)getdbpath{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filepath=[path stringByAppendingPathComponent:@"sunil.sqlite"];
    return filepath;
}
-(void)copydatabase{
    NSString *filepath=[self getdbpath];
    if (![[NSFileManager defaultManager]fileExistsAtPath:filepath]) {
        NSString *bundlepath=[[NSBundle mainBundle]pathForResource:@"sunil" ofType:@"sqlite"];
        [[NSFileManager defaultManager]copyItemAtPath:bundlepath toPath:filepath error:nil];
    }
}

#pragma getting data from database

-(NSMutableArray *)fetchdata{
    dataarray=[[NSMutableArray alloc]initWithCapacity:0];
    sqlite3 *dbobj=nil;
    sqlite3_stmt *statement=nil;
    NSString *dbpath=[self getdbpath];
    if (sqlite3_open([dbpath UTF8String],&dbobj)==SQLITE_OK){
        NSString  *selectquery=@"SELECT * FROM student";
        if (sqlite3_prepare_v2(dbobj,[selectquery UTF8String],-1,&statement,NULL)==SQLITE_OK){
            while (sqlite3_step(statement)== SQLITE_ROW){
                NSString *fname = [NSString stringWithFormat:@"%s",sqlite3_column_text(statement,0)];
                NSString *lname = [NSString stringWithFormat:@"%s",sqlite3_column_text(statement,1)];
                NSString *email = [NSString stringWithFormat:@"%s",sqlite3_column_text(statement,2)];
                NSString *company = [NSString stringWithFormat:@"%s",sqlite3_column_text(statement,3)];
                NSString *city = [NSString stringWithFormat:@"%s",sqlite3_column_text(statement,4)];
                NSString *number = [NSString stringWithFormat:@"%s",sqlite3_column_text(statement,5)];
                int len = sqlite3_column_bytes(statement, 6);
                NSData  * imagedata=[[NSData alloc]initWithBytes:sqlite3_column_blob(statement, 6) length:len];
                UIImage *image = [UIImage imageWithData:imagedata];
                NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
                [dictionary setObject:fname forKey:@"fname"];
                [dictionary setObject:lname forKey:@"lname"];
                [dictionary setObject:email forKey:@"email"];
                [dictionary setObject:company forKey:@"company"];
                [dictionary setObject:city forKey:@"city"];
                [dictionary setObject:number forKey:@"number"];
                [dictionary setObject:image forKey:@"image"];
                [dataarray addObject:dictionary];
                [self.tableView reloadData];
                NSLog(@"retrieved succesfully%@",dataarray);
            }
        }else{
            NSLog(@"Query Preparation Error %s",sqlite3_errmsg(dbobj));
        }
    }else{
        NSLog(@"DB Connection Error %s",sqlite3_errmsg(dbobj));
    }
    return dataarray;
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma applying tableview datasource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataarray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellidentifier"forIndexPath:indexPath];
    label1=[[UILabel alloc]init];
    label1.text=[[dataarray objectAtIndex:indexPath.row]valueForKey:@"fname"];
    label1.textColor=[UIColor darkGrayColor];
    label2=[[UILabel alloc]init];
    label2.text=[[dataarray objectAtIndex:indexPath.row]valueForKey:@"lname"];
    label2.textColor=[UIColor darkGrayColor];
    UILabel *label7=(UILabel *)[cell viewWithTag:1];
    label7.text=[NSString stringWithFormat:@"%@ %@",label1.text,label2.text];
    label7.textColor=[UIColor darkGrayColor];
    UILabel *label3=(UILabel *)[cell viewWithTag:2];
    label3.text=[[dataarray objectAtIndex:indexPath.row]valueForKey:@"email"];
    label3.textColor=[UIColor darkGrayColor];
    UILabel *label4=(UILabel *)[cell viewWithTag:3];
    label4.text=[[dataarray objectAtIndex:indexPath.row]valueForKey:@"company"];
    UILabel *label5=(UILabel *)[cell viewWithTag:4];
    label5.text=[[dataarray objectAtIndex:indexPath.row]valueForKey:@"city"];
    UILabel *label6=(UILabel *)[cell viewWithTag:5];
    label6.text=[[dataarray objectAtIndex:indexPath.row]valueForKey:@"number"];
    label6.textColor=[UIColor darkGrayColor];
   // cell.contentView.backgroundColor = [UIColor SunilColor];
    UIImageView *galleryimage=(UIImageView *)[cell viewWithTag:6];
    galleryimage.layer.cornerRadius=galleryimage.frame.size.width/2;
    galleryimage.clipsToBounds=YES;
    galleryimage.image =[[dataarray objectAtIndex:indexPath.row] valueForKey:@"image"];
    UIImageView *image1=(UIImageView *)[cell viewWithTag:9];
    gesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Phone)];
    image1.userInteractionEnabled=YES;
    [image1 addGestureRecognizer:gesture1];
    UIImageView *image2=(UIImageView *)[cell viewWithTag:10];
    gesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Email)];
    image2.userInteractionEnabled=YES;
    [image2 addGestureRecognizer:gesture2];
    UIImageView *image3=(UIImageView *)[cell viewWithTag:20];
    gesture3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Facebook)];
    image3.userInteractionEnabled=YES;
    [image3 addGestureRecognizer:gesture3];
    image3.layer.cornerRadius=image3.frame.size.width/2;
    image3.clipsToBounds=YES;
    UIImageView *image4=(UIImageView *)[cell viewWithTag:21];
    gesture4=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Twitter)];
    image4.userInteractionEnabled=YES;
    image4.layer.cornerRadius=image4.frame.size.width/2;
    image4.clipsToBounds=YES;
    [image4 addGestureRecognizer:gesture4];
    UIImageView *image5=(UIImageView *)[cell viewWithTag:19];
    gesture5=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Musicplayer)];
    image5.userInteractionEnabled=YES;
    [image5 addGestureRecognizer:gesture5];
    UIImageView *image6=(UIImageView *)[cell viewWithTag:55];
    gesture6=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(video)];
    image6.userInteractionEnabled=YES;
    [image6 addGestureRecognizer:gesture6];
    return cell;
}

-(void)video{
    
    NSURL *urlstr1=[NSURL URLWithString:@"https://www.youtube.com/bahubali"];
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:urlstr1 options:@{} completionHandler:nil];
}

-(void)Musicplayer{
   
    NSURL *urlstr1=[NSURL URLWithString:@"http://www.wynk.in/music"];
    [[UIApplication sharedApplication]openURL:urlstr1];
}

-(void)Phone{
    
    NSString *phoneNo = @"https://in.bookmyshow.com/hyderabad";
    NSURL *url = [NSURL URLWithString:phoneNo];
    if ([[UIApplication sharedApplication]canOpenURL:url])
    {
        [[UIApplication sharedApplication]openURL:url];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Unable to Call" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
}
-(void)Facebook{
    NSURL *urlstr1=[NSURL URLWithString:@"https://www.facebook.com"];
    [[UIApplication sharedApplication]openURL:urlstr1];
}
-(void)Twitter{
    NSURL *urlstr1=[NSURL URLWithString:@"https://twitter.com/login"];
    [[UIApplication sharedApplication]openURL:urlstr1];
}

-(void)Email{
    NSURL *urlstr1=[NSURL URLWithString:@"https://www.google.com/gmail"];
    [[UIApplication sharedApplication]openURL:urlstr1];
}
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result) {
        NSLog(@"Result : %ld",(long)result);
    }
    if (error) {
        NSLog(@"Error : %@",error);
    }
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *dbpath=[self getdbpath];
    sqlite3 *dbobj=nil;
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if(sqlite3_open([dbpath UTF8String], &dbobj) == SQLITE_OK)
        {
            NSString *str=[NSString stringWithFormat:@"delete from student where fname = '%@'",[[dataarray objectAtIndex:indexPath.row]valueForKey:@"fname"]];
            sqlite3_stmt *statement;
            if(sqlite3_prepare_v2(dbobj,[str UTF8String],-1, &statement, NULL) == SQLITE_OK)
            {
                if(sqlite3_step(statement) == SQLITE_DONE){
                    // executed
                    [dataarray removeObjectAtIndex:indexPath.row];
                    
                    NSLog(@"record deleted successfully");
                    
                }else{
                    //NSLog(@"%s",sqlite3_errmsg(db))
                }
                sqlite3_finalize(statement);
            }
            [tableView reloadData];
        }
        sqlite3_close(dbobj);
    }
        }

- (IBAction)barBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnInfo:(id)sender {
      
}
@end
