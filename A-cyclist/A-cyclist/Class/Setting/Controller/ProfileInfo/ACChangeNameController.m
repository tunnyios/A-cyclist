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
    
    //从缓存中获取用户昵称
    ACUserModel *user = [ACCacheDataTool getUserInfo];
    self.textView.text = user.username;

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
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  点击保存按钮
 */
- (IBAction)changeSave:(id)sender
{
    //1. 更新到本地缓存
    ACUserModel *user = [ACCacheDataTool getUserInfo];
    user.username = self.textView.text;
    [ACCacheDataTool updateUserInfo:user withObjectId:user.objectId];
    
    //2. 保存到数据库
    NSDictionary *dict = @{@"username" : self.textView.text};
    NSArray *array = @[@"username"];
    [ACDataBaseTool updateUserInfoWithDict:dict andKeys:array withResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            DLog(@"保存成功");
        } else {
            DLog(@"保存失败");
        }
    }];
    
    //3. 使ProfileInfo控制器修改name
    if ([self.delegate respondsToSelector:@selector(changeNameWith:)]) {
        [self.delegate changeNameWith:self.textView.text];
    }
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
