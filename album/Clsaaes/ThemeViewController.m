//
//  ThemeViewController.m
//  album
//
//  Created by seven on 15/7/15.
//  Copyright (c) 2015年 seven. All rights reserved.
//

#import "ThemeViewController.h"
#import "constants.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIButton+Badge.h"
#import "CustomAlertView.h"
#import "AddThemeViewController.h"
#import "ThemeDetailViewController.h"
#define GET_IMAGE(__NAME__,__TYPE__)    [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:__NAME__ ofType:__TYPE__]]

@class CustomAlertView;

@interface ThemeViewController ()<MHImagePickerMutilSelectorDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>{
    
    UITableView*listTV;
    CustomAlertView *alertView;
    NSMutableArray *imageArray;
    
    int currentindex;

}

@property (nonatomic, retain) UIImagePickerController *imagePickerController;

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType;


@end

@implementation ThemeViewController
-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden=NO;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(255, 255, 255, 1);
    imageArray=[[NSMutableArray alloc]init];
    UIImageView *navigationbarimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth,kNavHeight)];
    navigationbarimg.backgroundColor=RGB(54, 150, 207,1);
    [self.view addSubview:navigationbarimg];
    
    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(0, 20, kWidth, 50)];
    titleText.backgroundColor = [UIColor clearColor];
    titleText.textColor=[UIColor whiteColor];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.font            = [UIFont systemFontOfSize:kNavTitleFont];
    [titleText setText:@"主题拍"];
    [self.view addSubview:titleText];
    
    UIButton *photobutton=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-40, 30, 29, 29)];
    [photobutton setImage:[UIImage imageNamed:@"icon-camera"]  forState:UIControlStateNormal];
    [photobutton addTarget:self action:@selector(photoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photobutton];
    
    UIButton *addbutton=[[UIButton alloc]initWithFrame:CGRectMake(20, 30, 29, 29)];
    [addbutton setImage:[UIImage imageNamed:@"icon-add"]  forState:UIControlStateNormal];
    [addbutton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addbutton];
    
//    listTV=[[UITableView alloc]initWithFrame:CGRectMake(0, 70, kWidth,kHeight-120) style:UITableViewStylePlain];
//    listTV.delegate  =self;
//    listTV.dataSource=self;
//    listTV.backgroundColor = RGB(255, 255, 255, 1);
//    listTV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    listTV.showsVerticalScrollIndicator=NO;
//    [self.view addSubview:listTV];

}
-(IBAction)themedetailAction{
    ThemeDetailViewController *nextcview=[[ThemeDetailViewController alloc]init];
    [self.navigationController pushViewController:nextcview animated:YES];

}
-(void)addAction:(UIButton*)sender{
    AddThemeViewController *nextview=[[AddThemeViewController alloc]init];
    [self.navigationController pushViewController:nextview animated:YES];
    
}

-(void)photoAction:(UIButton*)sender{
    
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
 
}
#pragma mark
#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://照相机
        {
            currentindex=0;
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            self.imagePickerController = picker;
            [self setupImagePicker:sourceType];
            picker = nil;
            
            UIToolbar *cameraOverlayView = (UIToolbar *)self.imagePickerController.cameraOverlayView;
            UIBarButtonItem *doneItem = [[cameraOverlayView items] lastObject];
            [doneItem setTitle:@"取消"];
            
            [self presentViewController:self.imagePickerController animated:YES completion:nil];

            
//            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//            imagePicker.delegate = self;
//            imagePicker.allowsEditing = YES;
//            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//            //            [self presentModalViewController:imagePicker animated:YES];
//            [self.view.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        case 1://本地相簿
        {
            currentindex=1;
            
            MHImagePickerMutilSelector* imagePickerMutilSelector=[MHImagePickerMutilSelector standardSelector];//自动释放
            imagePickerMutilSelector.delegate=self;//设置代理
            
            UIImagePickerController* picker=[[UIImagePickerController alloc] init];
            picker.delegate=imagePickerMutilSelector;//将UIImagePicker的代理指向到imagePickerMutilSelector
            [picker setAllowsEditing:NO];
            picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            picker.modalTransitionStyle= UIModalTransitionStyleCoverVertical;
            picker.navigationController.delegate=imagePickerMutilSelector;//将UIImagePicker的导航代理指向到imagePickerMutilSelector
            
            imagePickerMutilSelector.imagePicker=picker;//使imagePickerMutilSelector得知其控制的UIImagePicker实例，为释放时需要。
            
            [self presentViewController:picker animated:YES completion:nil];

//            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//            imagePicker.delegate = self;
//            imagePicker.allowsEditing = YES;
//            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            //            [self presentModalViewController:imagePicker animated:YES];
//            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}
//这里是主要函数
- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    self.imagePickerController.sourceType = sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        // 不使用系统的控制界面
        self.imagePickerController.showsCameraControls = NO;
        
        UIToolbar *controlView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
        controlView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        //闪光灯
        UIButton *flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        flashBtn.frame = CGRectMake(0, 0, 35, 35);
        flashBtn.showsTouchWhenHighlighted = YES;
        flashBtn.tag = 100;
//        [flashBtn setImage:GET_IMAGE(@"camera_flash_auto.png", nil) forState:UIControlStateNormal];
        [flashBtn addTarget:self action:@selector(pushButton:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *flashItem = [[UIBarButtonItem alloc] initWithCustomView:flashBtn];
        
        //拍照
        UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cameraBtn.frame = CGRectMake(0, 0, 35, 35);
        cameraBtn.showsTouchWhenHighlighted = YES;
        [cameraBtn setImage:[UIImage imageNamed:@"camera_icon.png"] forState:UIControlStateNormal];
        [cameraBtn addTarget:self action:@selector(stillImage:) forControlEvents:UIControlEventTouchUpInside];
        [cameraBtn badgeNumber:-1];
        UIBarButtonItem *takePicItem = [[UIBarButtonItem alloc] initWithCustomView:cameraBtn];
        
        //摄像头切换
        UIButton *cameraDevice = [UIButton buttonWithType:UIButtonTypeCustom];
        cameraDevice.frame = CGRectMake(0, 0, 35, 35);
        cameraDevice.showsTouchWhenHighlighted = YES;
        [cameraDevice setImage:[UIImage imageNamed:@"camera_mode.png"] forState:UIControlStateNormal];

        [cameraDevice addTarget:self action:@selector(changeCameraDevice:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *cameraDeviceItem = [[UIBarButtonItem alloc] initWithCustomView:cameraDevice];
        if (![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            //判断是否支持前置摄像头
            cameraDeviceItem.enabled = NO;
        }
        
        //取消、完成
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered
                                                                    target:self action:@selector(doneAction)];
        
        //模式：单张、多张
        UIButton *modeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        modeBtn.frame = CGRectMake(0, 0, 35, 35);
        modeBtn.showsTouchWhenHighlighted = YES;
        modeBtn.tag = 101;
        [modeBtn setImage:GET_IMAGE(@"camera_set.png", nil) forState:UIControlStateNormal];
        [modeBtn addTarget:self action:@selector(pushButton:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *modeItem = [[UIBarButtonItem alloc] initWithCustomView:modeBtn];
        
        //空item
        UIBarButtonItem *spItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        NSArray *items = [NSArray arrayWithObjects:flashItem,modeItem,spItem,takePicItem,spItem,cameraDeviceItem,doneItem, nil];
        [controlView setItems:items];
        
        
        self.imagePickerController.cameraOverlayView = controlView;
        
        controlView = nil;
    }
}
#pragma mark -
#pragma UIImagePickerController Delegate
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
//        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        
//    }
//    
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}


//拍照
- (void)stillImage:(id)sender
{
    [self.imagePickerController takePicture];
}

//完成、取消
- (void)doneAction
{
    [self imagePickerControllerDidCancel:self.imagePickerController];
}
- (void)changeCameraDevice:(id)sender
{
    if (self.imagePickerController.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            self.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
    }
    else {
        self.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}

- (IBAction)cancel:(id)sender
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}


#pragma mark - UIImagePickerController回调
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if (currentindex==0) {
        
    //保存相片到数组，这种方法不可取,会占用过多内存
    //如果是一张就无所谓了，到时候自己改
    [imageArray addObject:[info objectForKey:UIImagePickerControllerOriginalImage]];
    //    if (singleMode) {
    //        [picker dismissModalViewControllerAnimated:YES];
    //        [self refreshImage];
    //    }
    //    else if (imageArray.count == 1) {
    //多张拍摄,不必每次都执行
    UIBarButtonItem *flashItem = [[(UIToolbar *)self.imagePickerController.cameraOverlayView items] lastObject];
    flashItem.title = @"完成";
    //    }
    
    UIToolbar *view = (UIToolbar *)self.imagePickerController.cameraOverlayView;
    UIBarButtonItem *cameraItem = [[view items] objectAtIndex:3];
    [(UIButton *)cameraItem.customView setBadge:(int)imageArray.count];
    }
    else if (currentindex==1){
        [picker dismissViewControllerAnimated:YES completion:nil];

    
    }

}

#pragma mark
#pragma mark- UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 4;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.backgroundColor=[UIColor clearColor];
    }
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 80)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [cell addSubview:bgView];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 40)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = RGB(60, 60, 60,1);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:titleLabel];
    
    UILabel *schoolLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 10, kWidth-140, 40)];
    schoolLabel.font = [UIFont systemFontOfSize:16];
    schoolLabel.textColor = RGB(60, 60, 60,1);
    schoolLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:schoolLabel];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
