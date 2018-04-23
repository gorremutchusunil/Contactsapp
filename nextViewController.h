//
//  nextViewController.h
//  datapassing
//
//  Created by sunil  on 23/10/16.
//  Copyright © 2016 sunil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface nextViewController : UIViewController<UINavigationControllerDelegate,MFMailComposeViewControllerDelegate>
{
     UITapGestureRecognizer *gesture1, *gesture2,*gesture3,*gesture4, *gesture5, *gesture6;
     AVAudioPlayer *audioPlayer;
}
- (IBAction)barBack:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
