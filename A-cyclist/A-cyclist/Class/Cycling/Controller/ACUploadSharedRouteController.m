//
//  ACUploadSharedRouteController.m
//  A-cyclist
//
//  Created by tunny on 15/8/11.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACUploadSharedRouteController.h"
#import "HCStarViewBigSize.h"
#import "ACGlobal.h"
#import "ACRouteModel.h"
#import "ACSharedRouteModel.h"
#import "ACSharedRoutePhotoModel.h"
#import "ACUserModel.h"
#import "ACCacheDataTool.h"
#import "ACDataBaseTool.h"
#import <MobileCoreServices/MobileCoreServices.h>
//#import "VPImageCropperViewController.h"


typedef enum : NSUInteger {
    ACImageClickedNULL,
    ACImageClickedFirst,
    ACImageClickedSecond,
    ACImageClickedThird,
} ACImageClicked;

#define ORIGINAL_MAX_WIDTH  ACScreenBounds.size.width * 3.0f

@interface ACUploadSharedRouteController () <UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate>
/** 路线类别 */
@property (nonatomic, copy) NSString *routeClass;
@property (weak, nonatomic) IBOutlet UIPickerView *routeClasspickerView;
/** 路线类别列表 */
@property (nonatomic, strong) NSArray *routeClassList;

/** 路线名称 */
@property (weak, nonatomic) IBOutlet UITextField *nameCNLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameENLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

/** 难度等级View */
@property (weak, nonatomic) IBOutlet UIView *difficultyContentView;
@property (nonatomic, strong) HCStarViewBigSize *difficultyView;
/** 风景等级View */
@property (weak, nonatomic) IBOutlet UIView *sceneryContentView;
@property (nonatomic, strong) HCStarViewBigSize *sceneryView;

/** 上传图片 */
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *middleBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *middleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
/** imageTemp */
//@property (nonatomic, strong) UIImage *imageTemp;
/** imageFlag */
@property (nonatomic, assign) ACImageClicked imageClicked;

/** 共享路线模型 */
@property (nonatomic, strong) ACSharedRouteModel *sharedRoute;
/** 用户模型 */
@property (nonatomic, strong) ACUserModel *user;

@end

@implementation ACUploadSharedRouteController

- (NSArray *)routeClassList
{
    if (_routeClassList == nil) {
        //加载plist
        _routeClassList = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cities.plist" ofType:nil]];
        DLog(@"routesClassList is %@", _routeClassList);
    }
    
    return _routeClassList;
}

- (ACUserModel *)user
{
    if (_user == nil) {
        _user = [ACCacheDataTool getUserInfo];
    }
    
    return _user;
}

- (ACSharedRouteModel *)sharedRoute
{
    if (_sharedRoute == nil) {
        _sharedRoute = [[ACSharedRouteModel alloc] init];
    }
    
    return _sharedRoute;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    DLog(@"self.image is %@,\n self.route is %@\n", self.routeMapImage, self.route);
    
    self.nameCNLabel.text = nil;
    self.nameENLabel.text = nil;
    self.descriptionTextView.text = nil;
    self.nameCNLabel.delegate = self;
    self.nameENLabel.delegate = self;
    self.descriptionTextView.delegate = self;
    [self.nameCNLabel setReturnKeyType:UIReturnKeyDone];
    [self.nameENLabel setReturnKeyType:UIReturnKeyDone];
    [self.descriptionTextView setReturnKeyType:UIReturnKeyDone];
    //等级
    self.difficultyView = [HCStarViewBigSize starViewBigSize];
    self.difficultyView.frame = self.difficultyContentView.bounds;
    [self.difficultyContentView addSubview:self.difficultyView];
    
    self.sceneryView = [HCStarViewBigSize starViewBigSize];
    self.sceneryView.frame = self.sceneryContentView.bounds;
    [self.sceneryContentView addSubview:self.sceneryView];
}

- (BOOL)willDealloc {
    return NO;
}

- (void)dealloc
{
    DLog(@"uploadVC dimss");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 路线类别 pickerView的数据源方法和代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.routeClassList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.routeClassList[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
//        pickerLabel.minimumFontSize = 8.;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.routeClass = self.routeClassList[row];
    DLog(@"self.routeClass is %@", self.routeClass);
}


#pragma mark - 参数View


#pragma mark - LevelView


#pragma mark - 上传图片View

/**
 *  点击按钮选择图片
 */
- (IBAction)leftBtnClick:(id)sender
{
    self.leftBtn.selected = YES;
    self.imageClicked = ACImageClickedFirst;
    [self selectImageFromPhone];
}

- (IBAction)middleBtnClick:(id)sender
{
    self.middleBtn.selected = YES;
    self.imageClicked = ACImageClickedSecond;
    [self selectImageFromPhone];
}

- (IBAction)rightBtnClick:(id)sender
{
    self.rightBtn.selected = YES;
    self.imageClicked = ACImageClickedThird;
    [self selectImageFromPhone];
}

- (void)selectImageFromPhone
{
    //弹出alertViewController
    //1. 弹出UIAlertController选择图片或者相机
    //此处防止block的循环引用问题
    __weak typeof(self) appsVc = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([appsVc isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = appsVc;
            [appsVc presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 DLog(@"Picker View Controller is presented");
                             }];
        }
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([appsVc isCameraAvailable] && [appsVc doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([appsVc isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = appsVc;
            [appsVc presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 DLog(@"Picker View Controller is presented");
                             }];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:photoAction];
    [alertController addAction:cameraAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    /** 此处防止block的循环引用问题 */
    __weak typeof(self) appsVc = self;
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        //设置image到对应的imageView
        if (ACImageClickedFirst == appsVc.imageClicked) {
            appsVc.leftImageView.image = portraitImg;
        } else if (ACImageClickedSecond == appsVc.imageClicked) {
            appsVc.middleImageView.image = portraitImg;
        } else if (ACImageClickedThird == appsVc.imageClicked) {
            appsVc.rightImageView.image = portraitImg;
        } else {
            DLog(@"未知错误");
        }
        DLog(@"picker dismissed");
//        portraitImg = [self imageByScalingToMaxSize:portraitImg];
//        // 裁剪
//        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width * 0.75) limitScaleRatio:3.0];
//        imgEditorVC.delegate = appsVc;
//        [self presentViewController:imgEditorVC animated:YES completion:^{
//            // TO DO
//            DLog(@"....TO..DO");
//        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^(){
        DLog(@"picker dismissed");
    }];
}

#pragma mark VPImageCropperDelegate

/**
 *  裁剪完图片后调用的操作
 *  @param editedImage       裁减后的图片
 */
//- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
//{
//    //设置image到对应的imageView
//    if (ACImageClickedFirst == self.imageClicked) {
//        self.leftImageView.image = editedImage;
//    } else if (ACImageClickedSecond == self.imageClicked) {
//        self.middleImageView.image = editedImage;
//    } else if (ACImageClickedThird == self.imageClicked) {
//        self.rightImageView.image = editedImage;
//    } else {
//        DLog(@"未知错误");
//    }
//    
//    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController
//{
//    [cropperViewController dismissViewControllerAnimated:YES completion:^{
//    }];
//}


#pragma mark camera utility
- (BOOL) isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isFrontCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos
{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType
{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage
{
    DLog(@"sourceImage.size is %@", NSStringFromCGSize(sourceImage.size));
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH * 0.75 / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) DLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark - 保存到sharedRoute
- (IBAction)uploadData:(id)sender
{
    if (![self checkUploadAvaliable]) {
        return;
    }

    [self showHUD_Msg:@"正在上传，请稍候"];
    //1. 上传图片到数据库，并获取URL
    //构造上传文件data字典数组
    NSData *data1 = UIImageJPEGRepresentation(self.leftImageView.image, 0.2f);
    NSData *data2 = UIImageJPEGRepresentation(self.middleImageView.image, 0.2f);
    NSData *data3 = UIImageJPEGRepresentation(self.rightImageView.image, 0.2f);
    NSData *data4 = UIImageJPEGRepresentation(self.routeMapImage, 0.5f);

    NSDictionary *dict1 = nil;
    NSDictionary *dict2 = nil;
    NSDictionary *dict3 = nil;
    NSDictionary *dict4 = nil;
    NSMutableArray *dataArray = [NSMutableArray array];
    if (data1) {
        dict1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"image1.jpg",@"filename",data1,@"data",nil];
        [dataArray addObject:dict1];
    }
    if (data2) {
        dict2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"image2.jpg",@"filename",data2,@"data",nil];
        [dataArray addObject:dict2];
    }
    if (data3) {
        dict3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"image3.jpg",@"filename",data3,@"data",nil];
        [dataArray addObject:dict3];
    }
    if (data4) {
        dict4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"image4.jpg",@"filename",data4,@"data",nil];
        [dataArray addObject:dict4];
    }

    __weak typeof (self)weakSelf = self;
    //上传多个文件
    [ACDataBaseTool uploadFilesWithDatas:dataArray block:^(NSError *error, NSArray *fileNameArray, NSArray *urlArray) {
        if (!error) {
            //根据fileName和url获取完整的url
            NSMutableArray *imageArray = [NSMutableArray array];
            for (int i = 0; i < urlArray.count; i++) {
                NSString *comURL = [ACDataBaseTool signUrlWithFilename:fileNameArray[i] url:urlArray[i]];
                DLog(@"comURL is %@", comURL);
                ACSharedRoutePhotoModel *photoModel = [ACSharedRoutePhotoModel routePhotoModelWithphoto:comURL];
                [imageArray addObject:photoModel];
            }
            //保存数据到服务器
            [weakSelf saveDataWith:imageArray];
        } else {
            [weakSelf.HUD hide:YES];
            [weakSelf.HUD hideSuccessMessage:@"上传失败, 请稍候再试"];
        }
    } progress:^(NSUInteger index, CGFloat progress) {
        DLog(@"正在上传中...");
    }];
}

- (BOOL)checkUploadAvaliable
{
    //参数
    if (0 == self.nameCNLabel.text.length || 0 == self.nameENLabel.text.length || 0 == self.descriptionTextView.text.length) {
        [self showMsgCenter:@"路线名称和描述不能为空"];
        return false;
    }
    
    return true;
}

/**
 *  保存数据到sharedRoute数据库
 *
 *  @param imageArray 传入路线图片列表
 */
- (void)saveDataWith:(NSArray *)imageArray
{
    //类型
    if (0 == self.routeClass.length) {
        self.sharedRoute.classification = @"北京";
    } else {
        self.sharedRoute.classification = self.routeClass;
    }
    
    self.sharedRoute.nameCN = self.nameCNLabel.text;
    self.sharedRoute.nameEN = self.nameENLabel.text;
    self.sharedRoute.routeDesc = self.descriptionTextView.text;
    //星级
    self.sharedRoute.difficultyLevel = [NSNumber numberWithInteger:[self.difficultyView getNumOfStarLight]];
    self.sharedRoute.sceneryLevel = [NSNumber numberWithInteger:[self.sceneryView getNumOfStarLight]];
    //图片url列表
    self.sharedRoute.imageList = imageArray;
    //路线来源
    self.sharedRoute.userName = self.user.username;
    self.sharedRoute.userObjectId = self.user.objectId;
    //路线里程/最高海拔
    self.sharedRoute.distance = self.route.distance;
    self.sharedRoute.maxAlitude = [NSNumber numberWithDouble:self.route.maxAltitude.doubleValue];
    
    //保存
    __weak typeof (self)weakSelf = self;
    [ACDataBaseTool addPersonSharedRouteWith:self.sharedRoute userObjectId:self.user.objectId resultBlock:^(BOOL isSuccessful, NSString *objectId, NSError *error) {
        if (isSuccessful) {
            DLog(@"上传共享路线到服务器成功");
            
            //更新该路线的isShared为1，到personRoute数据库
            NSArray *keys = @[@"isShared", @"personSharedRouteId"];
            NSDictionary *dict = @{@"isShared" : @1,
                                   @"personSharedRouteId" : objectId
                                   };
//            __strong typeof (weakSelf)strongSelf = weakSelf;
            [ACDataBaseTool updateRouteWithUserObjectId:weakSelf.user.objectId routeStartDate:weakSelf.route.cyclingStartTime dict:dict andKeys:keys withResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    DLog(@"更新路线的isShared成功");
                    //更新该路线到本地缓存
                    weakSelf.route.isShared = @1;
                    weakSelf.route.personSharedRouteId = objectId;
                    [ACCacheDataTool updateRouteWith:weakSelf.route routeOne:weakSelf.route.routeOne];
                    
                    [weakSelf.HUD hide:YES];
                    [weakSelf.HUD hideSuccessMessage:@"上传成功"];
                    if (weakSelf.option) {
                        weakSelf.option(YES);
                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    
                } else {
                    [weakSelf.HUD hide:YES];
                    [weakSelf.HUD hideSuccessMessage:@"上传失败"];
                    DLog(@"更新路线的isShared失败, error is %@", error);
                }
            }];
            
        } else {
            [weakSelf.HUD hide:YES];
            [weakSelf.HUD hideErrorMessage:@"上传失败,请检查网络"];
            DLog(@"上传共享路线到服务器失败, error is %@", error);
        }
    }];
    
}


#pragma mark - scrollView的代理事件 键盘处理
/**
 *  滚动scrollView时，退出键盘
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [self.view endEditing:YES];
        return NO;
    }
    
    return YES;
}

@end
