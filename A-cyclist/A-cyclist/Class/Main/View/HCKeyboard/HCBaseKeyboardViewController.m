//
//  ViewController.m
//  keyboard处理
//
//  Created by tunny on 15/7/19.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCBaseKeyboardViewController.h"
#import "HCKeyboardTool.h"

#define  HCScreenSize   [UIScreen mainScreen].bounds.size

@interface HCBaseKeyboardViewController () <HCKeyboardToolDelegate>
@property (nonatomic, strong) HCKeyboardTool *toolbarView;

@end

@implementation HCBaseKeyboardViewController

- (void)setTextFieldArray:(NSMutableArray *)textFieldArray
{
    _textFieldArray = textFieldArray;
    
    [_textFieldArray enumerateObjectsUsingBlock:^(UITextField *tempView, NSUInteger idx, BOOL *stop) {
        tempView.inputAccessoryView = self.toolbarView;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textFieldArray = [NSMutableArray array];
    //2. 将toolbarView加载到各个textField上
    self.toolbarView = [HCKeyboardTool keyboardTool];
    self.toolbarView.delgate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //3. 使用通知来监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboradChangedFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self clearTextFieldNotify];
}

/** 键盘事件处理 */
- (void)keyboradChangedFrame:(NSNotification *)nofi
{
    //当键盘即将改变frame的时候，调整view的frame
    NSInteger textIndex = [self getCurrentTextIndex];
    if (textIndex < 0) {
        return;
    }
    
    CGRect textFrame = [self.textFieldArray[textIndex] convertRect:[self.textFieldArray[textIndex] bounds] toView:self.contentView];
    CGFloat textY = CGRectGetMaxY(textFrame);
    CGRect keyboradFrame = [nofi.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboradSizeY = HCScreenSize.height - keyboradFrame.origin.y;
    CGFloat changeFrame = HCScreenSize.height - (textY + keyboradSizeY) - self.textFieldOffset;
    if (changeFrame < 0) {
        //调整view位置
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.transform = CGAffineTransformMakeTranslation(0, changeFrame);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 实现键盘toolbarView的代理方法
- (void)keyboardTool:(HCKeyboardTool *)keyboardTool didClickItemType:(KeyboardItemType)itemType
{
    //1. 获取当前响应的textfield的在textFieldArray中的索引
    NSInteger textIndex = [self getCurrentTextIndex];
    if (textIndex < 0) {
        return;
    }
    
    if (KeyboardItemTypePrevious == itemType) {
        //上一步
        [self previousClickWithIndex:textIndex];
    } else if (KeyboardItemTypeNext == itemType) {
        //下一步
        [self nextClickWithIndex:textIndex];
    } else {
        //完成
        [self doneClickWithIndex:textIndex];
    }
}

/** 获取当前textField在数组中的索引 */
- (NSInteger)getCurrentTextIndex
{
    int i = -1;
    for (UITextField *textView in self.textFieldArray) {
        i++;
        if ([textView isFirstResponder]) {
            return i;
        }
    }
    
    return -1;
}

/** 上一步 */
- (void)previousClickWithIndex:(NSInteger)textIndex
{
    if (textIndex > 0) {
        //更改第一响应者
        [self.textFieldArray[textIndex] resignFirstResponder];
        self.contentView.transform = CGAffineTransformIdentity;
        [self.textFieldArray[textIndex - 1] becomeFirstResponder];
    }
}

/** 下一步 */
- (void)nextClickWithIndex:(NSInteger)textIndex
{
    if (textIndex < (self.textFieldArray.count - 1)) {
        [self.textFieldArray[textIndex] resignFirstResponder];
        self.contentView.transform = CGAffineTransformIdentity;
        [self.textFieldArray[textIndex + 1] becomeFirstResponder];
    }
}

/** 完成 */
- (void)doneClickWithIndex:(NSInteger)textIndex
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}

/** 移除键盘通知 */
- (void)clearTextFieldNotify
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    }];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
