//
//  UserEditViewController.m
//  shopFriend
//
//  Created by Beautilut on 14-2-27.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "UserEditViewController.h"
#import "ChangeInfoViewController.h"
#import "SexViewController.h"
#import "BirthdayViewController.h"
#import "HeadImageCell.h"
#import "InfoCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ShopNaviBar.h"
@interface UserEditViewController ()
{
    UITableView*userTable;
    UIImage*headImage;

    HostModel*host;
    HeadImageCell*imageCell;
    NSDictionary*postDic;
}
@end

@implementation UserEditViewController

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
     CGRect screenBounds=[[UIScreen mainScreen] bounds];
    ShopNaviBar*navi=[[ShopNaviBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [navi openNaviShadow:YES];
    [self.view addSubview:navi];
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [label setCenter:CGPointMake(navi.frame.size.width/2, navi.frame.size.height-23)];
    [label setText:@"我的信息"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor colorWithRed:25.0/255.0 green:173.0/255.0 blue:220.0/255.0 alpha:1.0f]];
    [label setFont:[UIFont systemFontOfSize:19.0f]];
    [navi addSubview:label];
    UIImageView*backImage=[[UIImageView alloc] initWithFrame:CGRectMake(5,32, 20, 20)];
    [backImage setImage:[UIImage imageNamed:@"back"]];
    [navi addSubview:backImage];
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0,24,40, 40)];
    [button addTarget:self action:@selector(backNavi:) forControlEvents:UIControlEventTouchDown];
    [navi addSubview:button];
    
    headImage=[[UIImage alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableRefresh:) name:@"tableRefresh" object:nil];
    userTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0,screenBounds.size.width, screenBounds.size.height) style:UITableViewStyleGrouped];
    float topInset = self.navigationController.navigationBar.frame.size.height+20;
    userTable.contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0);
    [userTable setDelegate:self];
    [userTable setDataSource:self];
    [self.view addSubview:userTable];
    [self tableRefresh:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableRefresh:) name:@"tableRefresh" object:nil];
    [self.view bringSubviewToFront:navi];
	// Do any additional setup after loading the view.
}
-(void)backNavi:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tableRefresh:(id)sender
{
    postDic=[[NSMutableDictionary alloc] init];
    headImage=[[InfoManager sharedInfo] getUserImage];//[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:userImageKey];
    host=[HostModel fetchHostInfo];
    [userTable reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 3;
    }
    if (section==1) {
        return 2;
    }
    if (section==2) {
        return 2;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section]==0) {
        if (indexPath.row==1) {
            return 80.0f;
        }
    }
    return 43.0f;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([indexPath section]==0) {
        if (indexPath.row==0) {
            InfoCell*cell=[tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
            if (cell==nil) {
                NSArray*nib=[[NSBundle mainBundle] loadNibNamed:@"InfoCell" owner:self options:nil];
                for (id oneObject in nib) {
                    if ([oneObject isKindOfClass:[InfoCell class]]) {
                        cell=(InfoCell*)oneObject;
                        cell.selectionStyle=UITableViewCellSelectionStyleNone;
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                        [cell.titleCell setText:@"店友号"];
                        if (host.hostID!=[NSNull null]) {
                            [cell.detailCell setText:host.hostID];
                        }else
                        {
                            [cell.detailCell setText:@""];
                        }
                        
                        return cell;
                    }
                }
            }
        }
        if (indexPath.row==1) {
            HeadImageCell*cell=[tableView dequeueReusableCellWithIdentifier:@"HeadImageCell"];
            if (cell==nil) {
                NSArray*nib=[[NSBundle mainBundle] loadNibNamed:@"HeadImageCell" owner:self options:nil];
                for (id oneObject in nib) {
                    if ([oneObject isKindOfClass:[HeadImageCell class]]) {
                        cell=(HeadImageCell*)oneObject;
                        cell.selectionStyle=UITableViewCellSelectionStyleNone;
                        [cell.headImage setImage:headImage];
                        //[cell.headImage setImageWithURL:[NSURL URLWithString:GET_USER_HEADIMAGE([[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID])] placeholderImage:nil];
                        imageCell=cell;
                        return cell;
                    }
                }
                
            }
        }
        if (indexPath.row==2) {
            InfoCell*cell=[tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
            if (cell==nil) {
                NSArray*nib=[[NSBundle mainBundle] loadNibNamed:@"InfoCell" owner:self options:nil];
                for (id oneObject in nib) {
                    if ([oneObject isKindOfClass:[InfoCell class]]) {
                        cell=(InfoCell*)oneObject;
                        cell.selectionStyle=UITableViewCellSelectionStyleNone;
                        [cell.titleCell setText:@"名字"];
                        if (host.hostName!=[NSNull null]) {
                            [cell.detailCell setText:host.hostName];
                        }else
                        {
                            [cell.detailCell setText:@""];
                        }
                        
                        return cell;
                    }
                }
            }
        }
    }
    if ([indexPath section]==1) {
        if (indexPath.row==0) {
            InfoCell*cell=[tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
            if (cell==nil) {
                NSArray*nib=[[NSBundle mainBundle] loadNibNamed:@"InfoCell" owner:self options:nil];
                for (id oneObject in nib) {
                    if ([oneObject isKindOfClass:[InfoCell class]]) {
                        cell=(InfoCell*)oneObject;
                        cell.selectionStyle=UITableViewCellSelectionStyleNone;
                        [cell.titleCell setText:@"电话"];
                        if (host.hostPhone!=[NSNull null]) {
                            [cell.detailCell setText:host.hostPhone];
                        }else
                        {
                            [cell.detailCell setText:@""];
                        }
                        return cell;
                    }
                }
            }
        }
        if (indexPath.row==1) {
            InfoCell*cell=[tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
            if (cell==nil) {
                NSArray*nib=[[NSBundle mainBundle] loadNibNamed:@"InfoCell" owner:self options:nil];
                for (id oneObject in nib) {
                    if ([oneObject isKindOfClass:[InfoCell class]]) {
                        cell=(InfoCell*)oneObject;
                        cell.selectionStyle=UITableViewCellSelectionStyleNone;
                        [cell.titleCell setText:@"邮箱"];
                        if (host.hostMail!=[NSNull null]) {
                            [cell.detailCell setText:host.hostMail];
                        }else
                        {
                            [cell.detailCell setText:@""];
                        }
                        return cell;
                    }
                }
            }
        }
    }
    if ([indexPath section]==2) {
        if (indexPath.row==0) {
            InfoCell*cell=[tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
            if (cell==nil) {
                NSArray*nib=[[NSBundle mainBundle] loadNibNamed:@"InfoCell" owner:self options:nil];
                for (id oneObject in nib) {
                    if ([oneObject isKindOfClass:[InfoCell class]]) {
                        cell=(InfoCell*)oneObject;
                        cell.selectionStyle=UITableViewCellSelectionStyleNone;
                        [cell.titleCell setText:@"性别"];
                        if (host.hostSex!=[NSNull null]) {
                            NSString*sex;
                            if ([host.hostSex intValue]==0) {
                                sex=@"男";
                            }else
                            {
                                sex=@"女";
                            }
                            [cell.detailCell setText:sex];
                        }else
                        {
                            [cell.detailCell setText:@""];
                        }
                        return cell;
                    }
                }
            }
        }
        if (indexPath.row==1) {
            InfoCell*cell=[tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
            if (cell==nil) {
                NSArray*nib=[[NSBundle mainBundle] loadNibNamed:@"InfoCell" owner:self options:nil];
                for (id oneObject in nib) {
                    if ([oneObject isKindOfClass:[InfoCell class]]) {
                        cell=(InfoCell*)oneObject;
                        cell.selectionStyle=UITableViewCellSelectionStyleNone;
                        [cell.titleCell setText:@"生日"];
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                        
                        if (host.hostBirthday!=[NSNull null]) {
                            [cell.detailCell setText:[NSString stringWithFormat:@"%@",host.hostBirthday]];
                        }else
                        {
                            [cell.detailCell setText:@""];
                        }
                        //NSString *destDateString = [dateFormatter stringFromDate:me.userBirthday];
                        //[cell.detailCell setText:[dateFormatter stringFromDate:host.hostBirthday]];
                        return cell;
                    }
                }
            }
        }
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section]==0&&indexPath.row==1) {
        UIActionSheet*imageSheet=[[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄",@"从照片中选取", nil];
        [imageSheet showInView:self.view];
        return;
    }
    if ([indexPath section]==0&&indexPath.row==2) {
        postDic=[self infoChangeInfoDictionary:0];
        [self performSegueWithIdentifier:@"changeInfo" sender:nil];
        return;
    }
    if ([indexPath section]==1&&indexPath.row==0) {
        postDic=[self infoChangeInfoDictionary:1];
        [self performSegueWithIdentifier:@"changeInfo" sender:nil];
        return;
    }
    if ([indexPath section]==1&&indexPath.row==1) {
        postDic=[self infoChangeInfoDictionary:2];
        [self performSegueWithIdentifier:@"changeInfo" sender:nil];
        return;
    }
    if ([indexPath section]==2&&indexPath.row==0) {
        [self performSegueWithIdentifier:@"changeSex" sender:nil];
    }
    if ([indexPath section]==2&&indexPath.row==1) {
        [self performSegueWithIdentifier:@"changeBirthday" sender:nil];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"changeInfo"]) {
        [[segue destinationViewController] getInfo:postDic];
    }
    if ([[segue identifier] isEqualToString:@"changeSex"]) {
        [[segue destinationViewController] setHostSex:host.hostSex];
    }
    if ([[segue identifier] isEqualToString:@"changeBirthday"]) {
        
    }
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
    [imageCell.headImage setImage:editedImage];
    NSURL*url=[NSURL URLWithString:userImageChange];
    ASIFormDataRequest*request=[ASIFormDataRequest requestWithURL:url];
    NSData*imagedata=UIImageJPEGRepresentation(editedImage, 0.1);
    [request setData:imagedata withFileName:@"userHead.jpg" andContentType:@"image/jpeg" forKey:@"userImage"];
    
    [request setPostValue:host.hostID   forKey:@"userID"];
    [request setCompletionBlock:^{
        SBJsonParser*parser=[[SBJsonParser alloc] init];
        NSDictionary*dic=[parser objectWithString:request.responseString];
        if ([[dic objectForKey:@"back"] intValue]==1) {
            //[[SDImageCache sharedImageCache] storeImage:editedImage forKey:userImageKey toDisk:YES];
            [[InfoManager sharedInfo] saveUserImage:editedImage];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userImageChange" object:nil];
        }
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark -
-(NSMutableDictionary*)infoChangeInfoDictionary:(int)x
{
    NSMutableDictionary*infoDic=[[NSMutableDictionary alloc] init];
    if (x==0) {
        [infoDic setObject:@"hostName" forKey:@"local"];
        [infoDic setObject:@"user_name" forKey:@"web"];
        [infoDic setObject:host.hostName forKey:@"old"];
    }
    if (x==1) {
        [infoDic setObject:@"hostPhone" forKey:@"local"];
        [infoDic setObject:@"user_phone" forKey:@"web"];
        [infoDic setObject:host.hostPhone forKey:@"old"];
    }
    if (x==2) {
        [infoDic setObject:@"hostMail" forKey:@"local"];
        [infoDic setObject:@"user_email" forKey:@"web"];
        [infoDic setObject:host.hostMail forKey:@"old"];
    }
    if (x==3) {
        [infoDic setObject:@"hostSex" forKey:@"local"];
        [infoDic setObject:@"user_sex" forKey:@"web"];
        [infoDic setObject:host.hostSex forKey:@"old"];
    }
    if (x==4) {
        [infoDic setObject:@"hostBirthday" forKey:@"local"];
        [infoDic setObject:@"user_birthday" forKey:@"web"];
        [infoDic setObject:host.hostBirthday forKey:@"old"];
    }
    [infoDic setObject:host.hostID forKey:@"userID"];
    return infoDic;
}
@end
