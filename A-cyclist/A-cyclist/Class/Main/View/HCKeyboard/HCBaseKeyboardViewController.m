//
//  ViewController.m
//  keyboard处理
//
//  Created by tunny on 15/7/19.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCBaseKeyboardViewController.h"
#import "HCKeyboardTool.h"
#import "ACGlobal.h"

@interface HCBaseKeyboardViewController () <HCKeyboardToolDelegate>
/** 用来存储所有的textField */
@property (nonatomic, copy) NSArray *textFieldArray;

@end

@implementation HCBaseKeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //2. 将toolbarView加载到各个textField上
    NSMutableArray *arrayM = [NSMutableArray array];
    HCKeyboardTool *toolbarView = [HCKeyboardTool keyboardTool];
//    toolbarView.bounds = CGRectMake(0, 0, self.view.bounds.size.width, 44);
    //设置代理
    toolbarView.delgate = self;
    //1. 从self.view的子控件中比较出所有的textField
    [self.contentView.subviews enumerateObjectsUsingBlock:^(UIView *tempView, NSUInteger idx, BOOL *stop) {
        //如果是textField
        if ([tempView isKindOfClass:[UITextField class]]) {
            UITextField *tf = (UITextField *)tempView;
            //设置toolbarView
            tf.inputAccessoryView = toolbarView;
            
            [arrayM addObject:tf];
        }
    }];
    self.textFieldArray = arrayM;
    
    //3. 使用通知来监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboradChangedFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

/** 键盘事件处理 */
- (void)keyboradChangedFrame:(NSNotification *)nofi
{
    //当键盘即将改变frame的时候，调整view的frame
    //1. 获取当前的键盘的第一响应者index
    NSInteger textIndex = [self getCurrentTextIndex];
    //2. 取当前第一响应者的最大Y值
    //转换坐标系到self.view
    CGRect textFrame = [self.textFieldArray[textIndex] convertRect:[self.textFieldArray[textIndex] bounds] toView:self.view];
    CGFloat textY = CGRectGetMaxY(textFrame);
    //3. 获取当前键盘所占的view的高度
    CGRect keyboradFrame = [nofi.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboradSizeY = self.view.bounds.size.height - keyboradFrame.origin.y;
    //4. 两个高度相加与控制器的高度进行比较
    CGFloat changeFrame = self.view.bounds.size.height - (textY + keyboradSizeY) - 80;
    if (changeFrame < 0) {
        //调整view位置
        [UIView animateWithDuration:0.3 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, changeFrame);
        }];
    }
    DLog(@"%@", nofi);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 实现键盘toolbarView的代理方法
- (void)keyboardTool:(HCKeyboardTool *)keyboardTool didClickItemType:(KeyboardItemType)itemType
{
    //1. 获取当前响应的textfield的在textFieldArray中的索引
    NSInteger textIndex = [self getCurrentTextIndex];
    
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
    //因为只要进入到了该方法，当前的第一响应者一定是textfield
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
        /** 先取消第一响应者，可以让键盘的位置改变一次，这样就可以触发一次键盘 frame改变事件 */
        [self.textFieldArray[textIndex] resignFirstResponder];
        [self.textFieldArray[textIndex - 1] becomeFirstResponder];
    }
}

/** 下一步 */
- (void)nextClickWithIndex:(NSInteger)textIndex
{
    if (textIndex < (self.textFieldArray.count - 1)) {
        //更改第一响应者
        /** 先取消第一响应者，可以让键盘的位置改变一次，这样就可以触发一次键盘 frame改变事件 */
        [self.textFieldArray[textIndex] resignFirstResponder];
        [self.textFieldArray[textIndex + 1] becomeFirstResponder];
    }
}

/** 完成 */
- (void)doneClickWithIndex:(NSInteger)textIndex
{
    //退出键盘
    [self.view endEditing:YES];
    //view的frame回到初值****
    [UIView animateWithDuration:0.3 animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

@end
