//
//  UserViewController.m
//  Feedback
//
//  Created by Bmob on 14-5-7.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "ACSettingFeedbackViewController.h"
#import <BmobSDK/Bmob.h>
#import "ACShowAlertTool.h"
#import "ACGlobal.h"

@interface ACSettingFeedbackViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@end

@implementation ACSettingFeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

/**
 *  发送反馈
 */
- (IBAction)sendMessage:(id)sender
{
    if (0 == [self.contactTextField.text length] || 0 == [self.messageTextView.text length]) {
        [ACShowAlertTool showError:@"联系方式和留言不能为空"];
        return;
    }
    
    BmobObject *feedbackObj = [[BmobObject alloc] initWithClassName:@"feedback"];
    [feedbackObj setObject:self.contactTextField.text forKey:@"contact"];
    [feedbackObj setObject:self.messageTextView.text forKey:@"content"];
    [feedbackObj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //发送推送
            BmobPush *push = [BmobPush push];
            BmobQuery *query = [BmobInstallation query];
            //条件为isDeveloper是true
            [query whereKey:@"isDeveloper" equalTo:[NSNumber numberWithBool:YES] ];
            [push setQuery:query];
            //推送内容为反馈的内容
            [push setMessage:self.messageTextView.text];
            [push sendPushInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                DLog(@"push error =====>%@",[error description]);
            }];
            [self.navigationController popViewControllerAnimated:YES];
            [ACShowAlertTool showSuccess:@"发送成功"];
        }
    }];


}

#pragma mark - scrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //滚动，推出键盘
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
