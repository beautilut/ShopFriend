//
//  SFTalkViewController.m
//  shopFriend
//
//  Created by Beautilut on 14-2-25.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "SFTalkViewController.h"
#import "SFSliderViewController.h"
#import "TalkInputView.h"
#import "ShopNaviBar.h"
#define INPUT_HEIGHT 40.0f
@interface SFTalkViewController ()
{
    NSMutableArray*messageRecords;
    //ui
    //UITextField*messageField;
    UITableView*messageTable;
}
@end

@implementation SFTalkViewController

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
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:_chatShop.shopName];
    [label setTextColor:[UIColor colorWithRed:25.0/255.0 green:173.0/255.0 blue:220.0/255.0 alpha:1.0f]];
    [label setFont:[UIFont systemFontOfSize:19.0f]];
    [navi addSubview:label];
    
    UIImageView*backImage=[[UIImageView alloc] initWithFrame:CGRectMake(5,32, 20, 20)];
    [backImage setImage:[UIImage imageNamed:@"back"]];
    [navi addSubview:backImage];
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0,24,40, 40)];
    [button addTarget:self action:@selector(backNavi:) forControlEvents:UIControlEventTouchDown];
    [navi addSubview:button];
    

    //self.navigationItem.title=_chatShop.shopName;
    //ui
    messageTable=[[UITableView alloc] initWithFrame:CGRectMake(0, navi.frame.size.height, screenBounds.size.width, screenBounds.size.height-40-navi.frame.size.height)];
    [messageTable setDelegate:self];
    [messageTable setDataSource:self];
    //[messageTable setBackgroundColor:[UIColor orangeColor]];
    float topInset = self.navigationController.navigationBar.frame.size.height+20;
    messageTable.contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0);
    [self.view addSubview:messageTable];
    
    [self reFresh];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessageCome:) name:kXMPPNewMsgNotifaction object:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [messageTable reloadData];
        });
        
    });
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [messageTable addGestureRecognizer:tap];
    [messageTable setBackgroundView:nil];
    [messageTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWillShowKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWillHideKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
    
    //input view
    inputView=[[TalkInputView alloc] initWithFrame:CGRectMake(0, screenBounds.size.height-40, screenBounds.size.width,40) withDelegate:self];
    [inputView setDelegate:self];
    [self.view addSubview:inputView];
//    messageField=[[UITextField alloc] initWithFrame:CGRectMake(1, 2, screenBounds.size.width-50, 36)];
//    [messageField setDelegate:self];
//    [messageField setBackgroundColor:[UIColor whiteColor]];
//    [messageField setBorderStyle:UITextBorderStyleLine];
//    [messageField setReturnKeyType:UIReturnKeyDone];
//    [inputView addSubview:messageField];
    [self.view bringSubviewToFront:navi];
	// Do any additional setup after loading the view.
}
-(void)backNavi:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)reFresh
{
    [inputView.message setInputView:nil];
    [inputView.message resignFirstResponder];
    NSString*stringShop=[NSString stringWithFormat:@"%@shop",_chatShop.shopID];
    messageRecords=[MessageModel  fetchMessageListWithUser:stringShop byPage:1];
    if (messageRecords.count!=0) {
        [messageTable reloadData];
        [messageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageRecords.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
#pragma mark -touchView-触摸关闭键盘
-(void)handleTap:(UIGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
}
#pragma mark - msg
-(void)newMessageCome:(id)sender
{
    //tabbar
    [self reFresh];
}
-(void)imageButtonDown:(id)sender
{
    UIActionSheet*imageSheet=[[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄",@"从照片中选取", nil];
    [imageSheet showInView:self.view];
}
-(void)sendIt:(id)sender
{
    NSString*message=inputView.message.text;
    NSDictionary*messageDic=[NSDictionary dictionaryWithObjectsAndKeys:@"",@"file",[NSNumber numberWithInt:bSFMessageTypePlain],@"messageType",message,@"text", nil];
    NSString*msgJson=[messageDic JSONRepresentation];
    //发送JSON
    //XMPPMessage*mes=[XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithUser:[NSString stringWithFormat:@"%@",chatPerson.userId] domain:@"shopfriend" resource:@"IOS"]];
    XMPPMessage*mes=[XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithUser:[NSString stringWithFormat:@"%@shop",_chatShop.shopID] domain:@"shopfriend" resource:nil]];
    [mes addChild:[DDXMLNode elementWithName:@"body" stringValue:msgJson]];
    [[SFXMPPManager sharedInstance] sendMessage:mes];
    [inputView.message setText:nil];
}
-(void)sendImage:(UIImage*)aImage
{
    NSLog(@"准备发送图片");
    //先上传头像
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:TalkImage]];
    [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID] forKey:@"from"];
    [request setPostValue:_chatShop.shopID forKey:@"to"];
    NSData*imageData=UIImageJPEGRepresentation(aImage, 0.1);
    [request setData:imageData withFileName:@"chatFile.jpg" andContentType:@"image/jpeg" forKey:@"file"];
    [request setTimeOutSeconds:1000];
    
    //[MMProgressHUD showWithTitle:@"发送文件ing..." status:@"发送文件ing...，请耐心等待"];
    [request setCompletionBlock:^{
        //NSDictionary *fileDic=[NSDictionary dictionary];
        SBJsonParser *paser=[[SBJsonParser alloc]init];
        
        NSDictionary *rootDic=[paser objectWithString:request.responseString];
//        NSArray *files=[rootDic objectForKey:@"name"];
//        if ([files count]>0) {
//            fileDic=[files objectAtIndex:0];
//        }
        //[MMProgressHUD dismissWithSuccess:@"发送成功，干吧得" title:nil afterDelay:1.0f];
        NSString*nameString=[rootDic objectForKey:@"name"];
        if ([nameString isEqualToString:@"fail"]) {
            return ;
        }
        NSDictionary *messageDic=[NSDictionary dictionaryWithObjectsAndKeys:nameString,@"file",[NSNumber numberWithInt:bSFMessageTypeImage],@"messageType",@"",@"text", nil];
        NSString *msgJson=[messageDic JSONRepresentation];
        // NSLog(@"准备发送JSON:%@",msgJson);
        //生成消息对象
        XMPPMessage *mes=[XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithUser:[NSString stringWithFormat:@"%@shop",_chatShop.shopID] domain:@"shopfriend" resource:@"ios"]];
        [mes addChild:[DDXMLNode elementWithName:@"body" stringValue:msgJson]];
        
        //发送消息
        [[SFXMPPManager sharedInstance] sendMessage:mes];
        
        
    }];
    [request setFailedBlock:^{
        //[MMProgressHUD dismissWithError:@"发送失败" afterDelay:1.0f];
        //[self continueRegister:fileId];
    }];
    [request startAsynchronous];
}
#pragma mark - talbeView methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
// The numer of rows is based on the count in the transcripts arrays
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messageRecords.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*identifier=@"SFMessageCell";
    SFMessageCell*cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[SFMessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    [cell setDelegate:self];
    MessageModel*msg=[messageRecords objectAtIndex:indexPath.row];
    [cell setMessageObject:msg];
    enum bSFMessageCellStyle style=[msg.messageFrom isEqualToString:[[NSUserDefaults standardUserDefaults]stringForKey:kXMPPmyJID]]?bSFMessageCellStyleMe:bSFMessageCellStyleOther;
    switch (style) {
        case bSFMessageCellStyleMe:
        {
            UIImage*image=[[InfoManager sharedInfo] getUserImage];//[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:userImageKey];
            [cell.userhead setImage:image];
            //[cell setHeadImage:image tag:indexPath.row];
            break;
        }
        case bSFMessageCellStyleOther:
        {
            [cell setHeadImage:[NSURL URLWithString:SHOP_LOGO_URL(_chatShop.shopID)] tag:indexPath.row];
            break;
        }
        case bSFMessageCellStyleMeWithImage:
        {
            UIImage*image=[[InfoManager sharedInfo] getUserImage];//[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:userImageKey];
            [cell.userhead setImage:image];
            //[cell setHeadImage:image tag:indexPath.row];
            break;
        }
        case bSFMessageCellStyleOtherWithImage:
        {
            [cell setHeadImage:[NSURL URLWithString:SHOP_LOGO_URL(_chatShop.shopID)] tag:indexPath.row];
            break;
        }
        default:
            break;
    }
    if ([msg.messageType intValue]==bSFMessageTypeImage) {
        style=style==bSFMessageCellStyleMe?bSFMessageCellStyleMeWithImage:bSFMessageCellStyleOtherWithImage;
        NSURL*url=[NSURL URLWithString:GET_CHAT_IMAGE(msg.messageContent)];
    [cell setChatImage:url tag:indexPath.row*2];
    }
    [cell setMsgStyle:style];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel*model=[messageRecords objectAtIndex:[indexPath row]];
    NSNumber*number=model.messageType;
    if( [number intValue]==bSFMessageTypeImage)
        return 55+100;
    else{
        
        NSString *orgin=[messageRecords[indexPath.row]messageContent];
        CGSize textSize=[orgin sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake((320-HEAD_SIZE-3*INSETS-40), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
        return 55+textSize.height;
    }
}
#pragma mark -text method-
#pragma mark - textView method-
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self sendIt:nil];
        [self textViewDidChange:inputView.message];
        [inputView.message resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
	
    if(!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = textView.contentSize.height;
    
    [self scrollToBottomAnimated:YES];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}
- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat maxHeight = [TalkInputView maxHeight];
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, maxHeight)];
    CGFloat textViewContentHeight = size.height;
    
    // End of textView.contentSize replacement code
    
    BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    
    if(!isShrinking && self.previousTextViewContentHeight == maxHeight) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if(changeInHeight != 0.0f) {
        //        if(!isShrinking)
        //            [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
        
        [UIView animateWithDuration:0.25f
                         animations:^{
                             UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                    0.0f,
                                                                    messageTable.contentInset.bottom + changeInHeight,
                                                                    0.0f);
                             
                             messageTable.contentInset = insets;
                             messageTable.scrollIndicatorInsets = insets;
                             [self scrollToBottomAnimated:NO];
                             
                             if(isShrinking) {
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [inputView adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             CGRect inputViewFrame = inputView.frame;
                             inputView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);
                             if(!isShrinking) {
                                 [inputView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }
    
    //self.inputToolBarView.sendButton.enabled = ([textView.text trimWhitespace].length > 0);
}
- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [messageTable numberOfRowsInSection:0];
    
    if(rows > 0) {
        [messageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}
#pragma mark - keyboard notifications
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendIt:nil];
    [textField resignFirstResponder];
    return YES;
}
-(void)textViewReturn:(id)sender
{
    [self sendIt:nil];
    
}
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    //[self moveInputView:YES forKeyboardNotification:notification];
//}
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    //[self moveInputView:NO forKeyboardNotification:notication];
//}
-(void)handleWillShowKeyBoard:(NSNotification*)notification
{
        [self moveInputView:YES forKeyboardNotification:notification];
}
-(void)handleWillHideKeyBoard:(NSNotification*)notication
{
        [self moveInputView:NO forKeyboardNotification:notication];
}
-(void)moveInputView:(BOOL)up forKeyboardNotification:(NSNotification*)notifaction
{
    CGRect inputViewFrame=inputView.frame;
    CGRect messageTableFrame=messageTable.frame;
    NSDictionary*userInfo=[notifaction userInfo];
    //get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    CGRect screenBounds=[[UIScreen mainScreen] bounds];
    float move=screenBounds.size.height-(inputView.frame.origin.y+keyboardFrame.size.height+40);
    
    if (up) {
        [inputView setFrame:CGRectMake(inputViewFrame.origin.x,inputViewFrame.origin.y+move, inputViewFrame.size.width, inputViewFrame.size.height)];
        [messageTable setFrame:CGRectMake(messageTableFrame.origin.x,messageTableFrame.origin.y, messageTableFrame.size.width, messageTableFrame.size.height+move)];
    }else
    {
        [inputView setFrame:CGRectMake(inputViewFrame.origin.x,inputViewFrame.origin.y+(keyboardFrame.size.height * (up ? -1 : 1)), inputViewFrame.size.width, inputViewFrame.size.height)];
        [messageTable setFrame:CGRectMake(messageTableFrame.origin.x,messageTableFrame.origin.y, messageTableFrame.size.width, messageTableFrame.size.height+(keyboardFrame.size.height * (up ? -1 : 1)))];
    }
    [UIView commitAnimations];
    if (messageRecords.count>0) {
       [messageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageRecords.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
#pragma mark image
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==2) {
        return;
    }
    UIImagePickerController*picker=[[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    if (buttonIndex==0) {
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
    }
    if (buttonIndex==1) {
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    UIImage  * chosedImage=info[//[info objectForKey:@"UIImagePickerControllerEditedImage"];
//
    UIImage*image=info[UIImagePickerControllerEditedImage];
    if (!image) {
        image=info[UIImagePickerControllerOriginalImage];
    }
    NSURL*assetURL=info[UIImagePickerControllerReferenceURL];
    if (!image&&!assetURL) {
        NSLog(@"Cannot retrieve an image from the selected item . giving up.");
    }else if (!image)
    {
    }
    //[picker dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //
        
        [self sendImage:image];
        
        
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //
    }];
}
-(void)showShop:(UIImage*)image
{
    [[SFSliderViewController sharedSliderController] defaultSubViews:_chatShop withImage:image];
    [[SFSliderViewController sharedSliderController] setComeFrom:YES];
    [self.navigationController pushViewController:[SFSliderViewController sharedSliderController] animated:YES];
}
@end
