//
//  ACSettingProfileInfoViewController.m
//  A-cyclist
//
//  Created by tunny on 15/7/20.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACSettingProfileInfoViewController.h"
#import "ACCacheDataTool.h"
#import "ACDataBaseTool.h"
#import "ACUserModel.h"
#import "ACGlobal.h"
#import "ACBlankSettingCellModel.h"
#import "ACArrowWithSubtitleSettingCellModel.h"
#import "ACSettingGroupModel.h"
#import "ACSettingViewCell.h"
#import "ACPhotoSettingCellModel.h"
#import "ACChangeNameController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "VPImageCropperViewController.h"
#import "ActionSheetMultipleStringPicker.h"
#import "ACNavUtility.h"
#import "ACTabBarController.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#define ORIGINAL_MAX_WIDTH 640.0f

@interface ACSettingProfileInfoViewController () <ACChangeNameDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, VPImageCropperDelegate>
/** 用户数据模型 */
@property (nonatomic, strong) ACUserModel *user;
/** 百度定位服务 */
@property (nonatomic, strong) BMKLocationService *bmkLocationService;
/** 头像view */
//@property (nonatomic, strong) UIImageView *portraitImageView;
/** 体重 */
@property (nonatomic, strong) NSNumber *weight;


@end

@implementation ACSettingProfileInfoViewController

- (BMKLocationService *)bmkLocationService
{
    if (_bmkLocationService == nil) {
        //初始化BMKLocationService
        _bmkLocationService = [[BMKLocationService alloc]init];
        _bmkLocationService.delegate = self;
    }
    
    return _bmkLocationService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [ACNavUtility setNav:self.navigationController setNavItem:self.navigationItem setTitle:@"个人信息"];
    if (PushFromTypeLogin != self.pushFromType) {
        self.navigationItem.leftBarButtonItem = [ACNavUtility setNavButtonWithImage:@"back_icon.png" target:self action:@selector(goBack) frame:CGRectMake(0, 0, 20, 20)];
    }
    self.navigationItem.rightBarButtonItem = [ACNavUtility setNavButtonWithTitle:@"保存" target:self action:@selector(saveClicked) frame:CGRectMake(0, 0, 45, 30)];
    //指定最小距离更新(米)
    self.bmkLocationService.distanceFilter = 1000.f;
    
    //1. 读取本地数据库，展示数据
    self.user = [ACCacheDataTool getUserInfo];
    DLog(@"user %@", self.user);
    
    [self addGroup0With:self.user];
    
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    //视图销毁时，停止定位
    //    [self.bmkLocationService stopUserLocationService];
    DLog(@"SettingProfileInfo dealloc");
}

- (BOOL)willDealloc
{
    return NO;
}

/**
 *  添加一组数据
 *
 *  @param user 用户数据
 */
- (void)addGroup0With:(ACUserModel *)user
{
    __weak typeof (self)weakSelf = self;
    //数据部分
    //头像
    ACPhotoSettingCellModel *cell0 = [ACPhotoSettingCellModel photoSettingCellWithTitle:@"头像" photoURL:user.profile_image_url orPhotoImage:nil];
    cell0.option = ^(NSIndexPath *indexPath){
        //设置头像
        [weakSelf changeAvatarWith:indexPath];
    };
    
    //昵称
    ACArrowWithSubtitleSettingCellModel *cell1 = [ACArrowWithSubtitleSettingCellModel arrowWithSubtitleCellWithTitle:@"昵称" subTitle:user.username icon:nil destClass:nil];
    cell1.option = ^(NSIndexPath *indexPath){
        //修改昵称
        [weakSelf changeNicknameWith:indexPath];
    };
    
    //个性签名
    ACArrowWithSubtitleSettingCellModel *cellSub = [ACArrowWithSubtitleSettingCellModel arrowWithSubtitleCellWithTitle:@"签名" subTitle:user.signature icon:nil destClass:nil];
    cellSub.option = ^(NSIndexPath *indexPath){
        //修改个性签名
        [weakSelf changeSignatureWith:indexPath];
    };
    
    //性别
    NSString *gender = @"";
    if ([user.gender isEqualToString:@"m"]) {
        gender = @"男";
    } else {
        gender = @"女";
    }
    ACBlankSettingCellModel *cell2 = [ACBlankSettingCellModel blankSettingCellWithTitle:@"性别" subTitle:gender icon:nil];
    cell2.option = ^(NSIndexPath *indexPath){
        //设置性别
        [weakSelf changeGenderWith:indexPath];
    };
    
    //地区
    ACBlankSettingCellModel *cell3 = [ACBlankSettingCellModel blankSettingCellWithTitle:@"地区" subTitle:(user.location ? user.location : @"未填写") icon:nil];
    cell3.option = ^(NSIndexPath *indexPath){
        //定位
        [weakSelf changeLocationWith:indexPath];
    };
    
    //体重
    NSString *weightStr = [NSString stringWithFormat:@"%@ kg", user.weight];
    if (!user.weight) {
        weightStr = @"未填写";
    }
    
    ACBlankSettingCellModel *cell4 = [ACBlankSettingCellModel blankSettingCellWithTitle:@"体重" subTitle:weightStr icon:nil];
    cell4.option = ^(NSIndexPath *indexPath){
        NSMutableArray *weight = [NSMutableArray array];
        for (int i = 40; i < 151; i++) {
            [weight addObject:[NSNumber numberWithInt:i]];
        }
        NSArray *colors = @[weight, @[@"kg"]];
        NSArray *initialSelection = @[@10, @1];
        [ActionSheetMultipleStringPicker showPickerWithTitle:@"体重" rows:colors initialSelection:initialSelection doneBlock:^(ActionSheetMultipleStringPicker *picker, NSArray *selectedIndexes, id selectedValues) {
            DLog(@"%@, values is %@ class is %@", selectedIndexes, selectedValues[0], [selectedValues[0] class]);
            //设置体重
            [weakSelf changeWeight:(NSNumber *)selectedValues[0] indexPath:indexPath];
            
        } cancelBlock:^(ActionSheetMultipleStringPicker *picker) {
            
        } origin:weakSelf.tableView];
    };
    
    //邮箱
//    ACBlankSettingCellModel *cell5 = [ACBlankSettingCellModel blankSettingCellWithTitle:@"邮箱" subTitle:(user.email ? user.email : @"未填写") icon:nil];
    
    ACSettingGroupModel *group = [[ACSettingGroupModel alloc] init];
    [group.cellList addObject:cell0];
    [group.cellList addObject:cell1];
    [group.cellList addObject:cellSub];
    [group.cellList addObject:cell2];
    [group.cellList addObject:cell3];
    [group.cellList addObject:cell4];
//    [group.cellList addObject:cell5];

    [self.dataList addObject:group];
}


#pragma mark - tableView代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACSettingViewCell *cell = [ACSettingViewCell settingViewCellWithTableView:tableView];
    
    //取分组模型
    ACSettingGroupModel *group = self.dataList[indexPath.section];
    //取cell模型
    ACSettingCellModel *cellModel = group.cellList[indexPath.row];
    
    cell.cellModel = cellModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 90;
    } else {
        return 44;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 各个cell的点击事件的实现
/**
 *  设置头像
 */
- (void)changeAvatarWith:(NSIndexPath *)indexPath
{
    //1. 弹出UIAlertController选择图片或者相机
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak typeof (self)weakSelf = self;
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([weakSelf isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = weakSelf;
            [weakSelf presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 DLog(@"Picker View Controller is presented");
                             }];
        }
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([weakSelf isCameraAvailable] && [weakSelf doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([weakSelf isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = weakSelf;
            [weakSelf presentViewController:controller
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

/**
 *  设置昵称
 */
- (void)changeNicknameWith:(NSIndexPath *)indexPath
{
    //弹出控制器
    ACChangeNameController *changeNameVC = [[ACChangeNameController alloc] initWithNibName:@"ACChangeNameController" bundle:nil];
    changeNameVC.delegate = self;
    changeNameVC.pushFrom = ChangeTextPushFromName;
    changeNameVC.defaultText = self.user.username;
    [self presentViewController:changeNameVC animated:YES completion:nil];
}

/**
 *  设置签名
 */
- (void)changeSignatureWith:(NSIndexPath *)indexpath
{
    //弹出控制器
    ACChangeNameController *changeSignatureVC = [[ACChangeNameController alloc] initWithNibName:@"ACChangeNameController" bundle:nil];
    changeSignatureVC.delegate = self;
    changeSignatureVC.pushFrom = ChangeTextPushFromDesc;
    changeSignatureVC.defaultText = self.user.signature;
    [self presentViewController:changeSignatureVC animated:YES completion:nil];
}


/**
 *  设置性别
 */
- (void)changeGenderWith:(NSIndexPath *)indexPath
{
    NSString *subTitle = @"";
    if ([self.user.gender isEqualToString:@"m"]) {
        self.user.gender = @"f";
        subTitle = @"女";
    } else {
        self.user.gender = @"m";
        subTitle = @"男";
    }
    
    //修改对应行的模型数据
    ACBlankSettingCellModel *model = [self.dataList[indexPath.section] cellList][indexPath.row];
    model.subTitle = subTitle;
    
    [self.tableView reloadData];
}

/**
 *  设置位置
 */
- (void)changeLocationWith:(NSIndexPath *)indexPath
{
    //启动LocationService
    [self.bmkLocationService startUserLocationService];
}

/**
 *  设置体重(单位kg)
 */
- (void)changeWeight:(NSNumber *)weight indexPath:(NSIndexPath *)indexPath
{
    self.user.weight = weight;
    NSString *subTitle = [NSString stringWithFormat:@"%@ kg", weight];
    //修改对应的模型数据
    ACBlankSettingCellModel *model = [self.dataList[indexPath.section] cellList][indexPath.row];
    model.subTitle = subTitle;
    [self.tableView reloadData];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    __weak typeof (self)weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [weakSelf imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, weakSelf.view.frame.size.width, weakSelf.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = weakSelf;
        [weakSelf presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
            DLog(@"....TO..DO");
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark VPImageCropperDelegate

/**
 *  裁剪完图片后调用的操作
 *  @param editedImage       裁减后的图片
 */
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    //设置tableView数据
    __block ACPhotoSettingCellModel *model = [self.dataList[0] cellList][0];
    model.photoImage = editedImage;

    __weak typeof (self)weakSelf = self;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        //上传图片到数据库，并获得url
        NSData *data = UIImageJPEGRepresentation(model.photoImage, 1.0f);
//        __strong typeof (weakSelf)strongSelf = weakSelf;
        [ACDataBaseTool uploadFileWithFilename:@"image.jpg" fileData:data block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url) {
            //获取大图的完整url, 并设置到用户数据模型中,点击保存按钮后
            weakSelf.user.avatar_large = [ACDataBaseTool signUrlWithFilename:filename url:url];
            
            //对服务器上的图片进行缩略图设置
            [ACDataBaseTool thumbnailImageBySpecifiesTheWidth:180 height:180 quality:100 sourceImageUrl:weakSelf.user.avatar_large resultBlock:^(NSString *filename, NSString *url, NSError *error) {
                if (error == nil) {
                    weakSelf.user.profile_image_url = url;
                    //将url直接保存到数据库和缓存中(因为是异步的，防止出现未上传完成，就点击了保存按钮)
                    [ACCacheDataTool updateUserInfo:weakSelf.user withObjectId:weakSelf.user.objectId];
                    
                    NSDictionary *dict = @{@"profile_image_url" : weakSelf.user.profile_image_url,
                                           @"avatar_large" : weakSelf.user.avatar_large
                                           };
                    NSArray *array = @[@"profile_image_url", @"avatar_large"];
                    [ACDataBaseTool updateUserInfoWithDict:dict andKeys:array withResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            DLog(@"更新头像的大图小图URL到用户表成功");
                        }
                    }];
                    
                }
            }];
        } progress:^(CGFloat progress) {
            
        }];
        // TO DO
        [weakSelf.tableView reloadData];
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}


#pragma mark - BMKLocationServieDelegate

/**
 *  处理位置坐标更新
 *
 *  @param userLocation
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //根据坐标返地理编码
    BMKGeoCodeSearch *geocodesearch = [[BMKGeoCodeSearch alloc] init];
    geocodesearch.delegate = self;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        DLog(@"反geo检索发送成功");
    }
    else
    {
        DLog(@"反geo检索发送失败");
    }

}

#pragma mark - geoCoderSearchDelegate

/**
 *  获取反向地理编码结果
 *
 *  @param searcher
 *  @param result
 *  @param error
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        self.user.location = [NSString stringWithFormat:@"%@ %@", result.addressDetail.city, result.addressDetail.district];
        
        //设置tableView的数据
        ACArrowWithSubtitleSettingCellModel *model = [self.dataList[0] cellList][4];
        model.subTitle = self.user.location;
        [self.tableView reloadData];
    }
}

#pragma mark - changeNameDelegate

/**
 *  修改了昵称时调用
 *
 *  @param name
 */
- (void)changeNameWith:(NSString *)name withType:(ChangeTextPushFrom)pushForm
{
    if (ChangeTextPushFromName == pushForm) {
        ACArrowWithSubtitleSettingCellModel *model = [self.dataList[0] cellList][1];
        model.subTitle = name;
    } else {
        ACArrowWithSubtitleSettingCellModel *model = [self.dataList[0] cellList][2];
        model.subTitle = name;
    }
    
    [self.tableView reloadData];
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
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

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
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

#pragma mark - 保存按钮的事件点击
- (void)saveClicked
{
    if (!self.user.weight) {
        [self showAlertMsg:@"请填写真实的体重" cancelBtn:@"确定"];
        return;
    }
    if (!self.user.accruedTime) {
        self.user.accruedTime = @0;
    }
    if (!self.user.accruedDistance) {
        self.user.accruedDistance = @0;
    }
    
    //1. 保存到本地缓存
    [ACCacheDataTool updateUserInfo:self.user withObjectId:self.user.objectId];
    
    //2. 保存到数据库
    __weak typeof (self)weakSelf = self;
    [ACDataBaseTool updateUserInfoWith:self.user withResultBlock:^(BOOL isSuccessful, NSError *error) {
        DLog(@"保存用户信息成功到数据库");
        [weakSelf.HUD hideSuccessMessage:@"保存成功"];
        if (PushFromTypeLogin == weakSelf.pushFromType) {
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            keyWindow.rootViewController = [[ACTabBarController alloc] init];
        }
        [weakSelf.bmkLocationService stopUserLocationService];
    }];
}

@end
