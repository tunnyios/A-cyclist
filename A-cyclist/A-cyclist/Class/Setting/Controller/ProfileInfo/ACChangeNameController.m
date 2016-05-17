//
//  ACChangeNameController.m
//  A-cyclist
//
//  Created by tunny on 15/7/21.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACChangeNameController.h"
#import "ACDataBaseTool.h"
#import "ACCacheDataTool.h"
#import "ACUserModel.h"
#import "ACGlobal.h"

@interface ACChangeNameController ()
@property (weak, nonatomic) IBOutlet UITextField *textView;

@end

@implementation ACChangeNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.text = self.defaultText;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  点击取消按钮
 */
- (IBAction)changeCancle:(id)sender
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  点击保存按钮
 */
- (IBAction)changeSave:(id)sender
{
    NSDictionary *dict;
    NSArray *array;
    __block ACUserModel *user = [ACCacheDataTool getUserInfo];
    if (ChangeTextPushFromName == self.pushFrom) {
        //昵称
        user.username = self.textView.text;
        dict = @{@"username" : self.textView.text};
        array = @[@"username"];
    } else {
        //个性签名
        user.signature = self.textView.text;
        dict = @{@"signature" : self.textView.text};
        array = @[@"signature"];
    }
    
    //1. 保存到数据库
    __weak typeof (self)weakSelf = self;
    [ACDataBaseTool updateUserInfoWithDict:dict andKeys:array withResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            DLog(@"保存成功");
            //2. 更新到本地缓存
            [ACCacheDataTool updateUserInfo:user withObjectId:user.objectId];
            //3. 使ProfileInfo控制器修改name
            if ([weakSelf.delegate respondsToSelector:@selector(changeNameWith: withType:)]) {
                [weakSelf.delegate changeNameWith:weakSelf.textView.text withType:weakSelf.pushFrom];
            }
            //4.dismiss
            [weakSelf.view endEditing:YES];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        } else {
            DLog(@"保存失败");
            [weakSelf showMsgCenter:@"保存失败"];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
