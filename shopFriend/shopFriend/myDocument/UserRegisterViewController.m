//
//  UserRegisterViewController.m
//  shopFriend
//
//  Created by Beautilut on 14-2-10.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "UserRegisterViewController.h"
#import "TextFieldCell.h"
#import "ShopNaviBar.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface UserRegisterViewController ()
{
    UIButton*imageButton;
    UITableView*tableView;
    NSMutableArray*cellArray;
    NSMutableDictionary*postDic;
    CGFloat moveHeight;
    UIImageView*checkImage;
    
    UIButton*rightButton;
    UIButton*leftButton;
}
@end

@implementation UserRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect screenRect=[[UIScreen mainScreen] bounds];
    
    ShopNaviBar*navi=[[ShopNaviBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [navi openNaviShadow:YES];
    [self.view addSubview:navi];
    
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [label setCenter:CGPointMake(navi.frame.size.width/2, navi.frame.size.height-23)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"店友"];
    [label setTextColor:[UIColor colorWithRed:25.0/255.0 green:173.0/255.0 blue:220.0/255.0 alpha:1.0f]];
    [label setFont:[UIFont systemFontOfSize:19.0f]];
    [navi addSubview:label];
    
    rightButton=[[UIButton alloc] initWithFrame:CGRectMake(navi.frame.size.width-45,24,40,40)];
    [rightButton addTarget:self action:@selector(registerUser:) forControlEvents:UIControlEventTouchDown];
    [rightButton.titleLabel setTextAlignment:NSTextAlignmentRight];
    [rightButton setTitle:@"注册" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:25.0/255.0 green:173.0/255.0 blue:220.0/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [navi addSubview:rightButton];
    
    leftButton=[[UIButton alloc] initWithFrame:CGRectMake(5, 24, 40, 40)];
    [leftButton addTarget:self action:@selector(backNavi:) forControlEvents:UIControlEventTouchDown];
    [leftButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor colorWithRed:25.0/255.0 green:173.0/255.0 blue:220.0/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [navi addSubview:leftButton];
    
    
    
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0, screenRect.size.width,150) style:UITableViewStyleGrouped];
    [tableView setCenter:CGPointMake(screenRect.size.width/2, screenRect.size.height/2)];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setScrollEnabled:NO];
    [self.view addSubview:tableView];
    [self.view setBackgroundColor:tableView.backgroundColor];
    cellArray=[[NSMutableArray alloc] init];
    
    imageButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 117, 117)];
    [imageButton setCenter:CGPointMake(screenRect.size.width/2, 130)];
    imageButton.layer.borderWidth=2;
    imageButton.layer.borderColor=[UIColor whiteColor].CGColor;
    imageButton.layer.cornerRadius=CGRectGetHeight(imageButton.bounds)/2;
    imageButton.clipsToBounds=YES;
    [imageButton addTarget:self action:@selector(imagePick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:imageButton];
    
    //check view
    UIView *checkView=[[UIView alloc] initWithFrame:CGRectMake(50, tableView.frame.origin.y+tableView.frame.size.height+5,20, 20)];
    [checkView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:checkView];
    checkImage=[[UIImageView alloc] initWithFrame:CGRectMake(2, 2, checkView.frame.size.width-4, checkView.frame.size.height-4)];
    [checkImage setImage:[UIImage imageNamed:@"check"]];
    [checkView addSubview:checkImage];
    UIButton*checkButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, checkView.frame.size.width, checkView.frame.size.height)];
    [checkButton setBackgroundColor:[UIColor clearColor]];
    [checkButton addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchDown];
    [checkView addSubview:checkButton];
    
    UILabel*label1=[[UILabel alloc] initWithFrame:CGRectMake(80,tableView.frame.origin.y+tableView.frame.size.height, 100, 30)];
    [label1 setText:@"我已阅读并同意"];
    [label1 setFont:[UIFont systemFontOfSize:13.0f]];
    [self.view addSubview:label1];
    
    UIButton*labelButton=[[UIButton alloc] initWithFrame:CGRectMake(170, tableView.frame.origin.y+tableView.frame.size.height, 100, 30)];
    [labelButton setTitle:@"店友用户协议" forState:UIControlStateNormal];
    [labelButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [labelButton setTitleColor:[UIColor colorWithRed:25.0/255.0 green:173.0/255.0 blue:220.0/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [labelButton addTarget:self action:@selector(checkLabel:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:labelButton];
    
    [self.view bringSubviewToFront:navi];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)checkLabel:(id)sender
{
    [self performSegueWithIdentifier:@"userAgreement" sender:nil];
}
-(void)check:(id)sender
{
    [checkImage setHidden:!checkImage.hidden];
}
-(void)getPhoneInfo:(NSMutableDictionary*)info
{
    postDic=info;
}
#pragma mark - navi methods
-(void)backNavi:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)registerUser:(id)sender
{
    
    if (checkImage.hidden==YES) {
        UIAlertView*alter=[[UIAlertView alloc] initWithTitle:nil message:@"您必须同意店友用户协议才能进行下一步操作" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        return;
    }
    TextFieldCell*cell=[cellArray objectAtIndex:0];
    [postDic setObject:cell.textField.text forKey:@"userName"];
    cell=[cellArray objectAtIndex:1];
    if (cell.textField.text.length<6) {
        UIAlertView*alter=[[UIAlertView alloc] initWithTitle:nil message:@"密码输入小于6位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        return;
    }
    [postDic setObject:cell.textField.text forKey:@"userPassword"];
    [self post:nil];
}
-(void)post:(id)sender
{
    [ProgressHUD show:@"正在创建用户"];
    [rightButton setEnabled:NO];
    NSURL*url=[NSURL URLWithString:userRegister];
    ASIFormDataRequest*request=[ASIFormDataRequest requestWithURL:url];
    for (NSString*key in [postDic allKeys]) {
        if (![key isEqualToString:@"userImage"]) {
            [request setPostValue:[postDic objectForKey:key] forKey:key];
        }else
        {
            UIImage*image=[postDic objectForKey:key];
            NSData*imagedata=UIImageJPEGRepresentation(image, 0.1);
            [request setData:imagedata withFileName:@"userHead.jpg" andContentType:@"image/jpeg" forKey:key];
        }
    }
    [request setCompletionBlock:^{
        SBJsonParser*parser=[[SBJsonParser alloc] init];
        NSDictionary*dic=[parser objectWithString:request.responseString];
        if ([[dic objectForKey:@"back"] integerValue]==1) {
            NSDictionary*hostDic=[NSDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"userID"],sfhostID,[postDic objectForKey:@"userName"],sfhostName,[dic objectForKey:@"userPhone"],sfhostPhone,nil];
            HostModel*newHost=[HostModel hostFromDictionary:hostDic];
            [HostModel saveNewHost:newHost];
            [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"userID"] forKey:kXMPPmyJID];
            [[NSUserDefaults standardUserDefaults] setObject:[postDic objectForKey:@"userPassword"] forKey:kXMPPmyPassword];
            [[InfoManager sharedInfo] getUserInfo];
            [[SFXMPPManager sharedInstance] connect];
            //imageCache
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadWithURL:[NSURL URLWithString:GET_USER_HEADIMAGE([dic objectForKey:@"userID"])] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
             {
                 [[InfoManager sharedInfo] saveUserImage:image];
                 //[[SDImageCache sharedImageCache] storeImage:image forKey:userImageKey toDisk:YES];
             }];
            [ProgressHUD dismiss];
            [rightButton setEnabled:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [request setFailedBlock:^{
        [ProgressHUD showError:@"创建失败."];
        [rightButton setEnabled:YES];
    }];
    [request startAsynchronous];
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"ShopCell"];
    // Configure the cell...
    TextFieldCell*cell=[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
    if (cell==nil) {
        NSArray*nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                cell=(TextFieldCell*)oneObject;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
        }
        if ([indexPath row]==0) {
            [cell.titleLabel setText:@"用户名"];
            [cell.textField setPlaceholder:@"店小友"];
            [cell.textField setDelegate:self];
            [cell.textField setReturnKeyType:UIReturnKeyDone];
            [cellArray addObject:cell];
        }
        if ([indexPath row]==1) {
            [cell.titleLabel setText:@"设置密码"];
            [cell.textField setSecureTextEntry:YES];
            [cell.textField setPlaceholder:@"******"];
            [cell.textField setDelegate:self];
            [cell.textField setReturnKeyType:UIReturnKeyDone];
            [cellArray addObject:cell];
        }
    }
    return cell;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
#pragma mark - textfieldmethod
- (void)moveView:(UITextField *)textField leaveView:(BOOL)leave
{
    CGRect screenRect=[[UIScreen mainScreen] bounds];
    for (int i=0; i<[cellArray count]; i++) {
        TextFieldCell*cell=[cellArray objectAtIndex:i];
        if (cell.textField==textField) {
            if (i==0) {
                moveHeight=250-(screenRect.size.height/2-40);
            }
            if (i==1) {
                 moveHeight=280-(screenRect.size.height/2-40);
            }
        }
    }
    if (leave==YES) {
        const float movementDuration = 0.2f;
        [UIView beginAnimations: @"textFieldAnim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, moveHeight);
        [UIView commitAnimations];
    }else
    {
        if (moveHeight>0) {
            const float movementDuration = 0.2f;
            [UIView beginAnimations: @"textFieldAnim" context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: movementDuration];
            self.view.frame = CGRectOffset(self.view.frame, 0,-moveHeight);
            [UIView commitAnimations];
        }
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
        [self moveView:textField leaveView:NO];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self moveView:textField leaveView:YES];
}
#pragma mark - image methods
-(void)imagePick:(id)sender
{
    UIActionSheet*imageSheet=[[UIActionSheet alloc] initWithTitle:@"图像选取" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄",@"从相册中选取",nil];
    [imageSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    portraitImg = [self imageByScalingToMaxSize:portraitImg];
    // 裁剪
    VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
    imgEditorVC.delegate = self;
    [picker pushViewController:imgEditorVC animated:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}
#pragma mark -
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}
#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
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
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
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
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [imageButton setImage:editedImage forState:UIControlStateNormal];//
    [postDic setObject:editedImage forKey:@"userImage"];//
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
@end
