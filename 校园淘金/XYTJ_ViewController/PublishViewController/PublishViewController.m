//
//  ViewController.m
//  校园淘金
//
//  Created by scjy on 15/4/21.
//  Copyright (c) 2015年 scjy. All rights reserved.


#import "PublishViewController.h"
#import "SendViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobProFile.h>
#import "UIUtils.h"

#define ScreenWidth self.view.bounds.size.width
#define ScreenHeight (self.view.bounds.size.height-133)
@interface PublishViewController ()
{
    
    UIView *bgView;//背景视图
    UIImagePickerController *pickerImage;
    UIButton *goods;
    NSURL *imageURL;
    UIImage *original;
   
    //下拉选择弹框
    UIActionSheet *myActionSheet;
    //图片2进制路径
    NSString *filePath;
    int space;//间隔
    
    UIButton *btn;
    UITextView *content;//标题，价格，描述
    
    NSData *imageData;
    NSString *myID;//用户ID
    
    NSString *imageUrl;
    NSString *goodTitle;
    NSString *goodDesc;
    NSString *goodPrice;
    BmobFile *bmobFile;
    BmobObject *goodObject;
    
    
    UIActivityIndicatorView *indicatorView;
    
}

@end

@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor whiteColor];
    [self ain];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getMyID];
}
-(void)getMyID
{
    
    NSArray *documents=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[[documents lastObject]stringByAppendingPathComponent:@"MyID.id"];
    NSArray *idarr=[NSArray arrayWithContentsOfFile:path];
    myID=idarr[0];
    //NSLog(@"%@",myID);
    
}

#pragma mark--主函数
-(void)ain
{
    space=10;
    
    [self bgView];//替代self.view
    [self runbg];//运行按钮的整条背景框,运行按钮（下一步）
    [self addGoodsImage];//添加商品图片
    [self subtittle];//添加标题、价格、描述
}

#pragma mark--背景视图
-(void)bgView
{
    bgView=[[UIView alloc]init];
    bgView.frame =CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
}

#pragma mark--运行按钮的背景框,运行按钮（取消，下一步）
-(void)runbg
{
    //背景框
    UIView *viewTop=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    viewTop.backgroundColor=[UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.5];
    [bgView addSubview:viewTop];
    
    UIView *topBg=[[UIView alloc]init];
    topBg.frame=CGRectMake(0, 20, ScreenWidth, 35);
    topBg.backgroundColor=[UIColor colorWithRed:1.0f green:0 blue:0 alpha:0.5];
    [bgView addSubview:topBg];
    
    UIButton *cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame=CGRectMake(0, 20, 60, 35);
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(allRemove) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"清空" forState:UIControlStateNormal];
    
    [bgView addSubview:cancelButton];
    
    //下一步按钮
    UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame=CGRectMake([UIUtils getWindowWidth]-85, 22.5, 75, 30);
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.layer.borderWidth=1.0f;//设置边框大小
    nextButton.layer.borderColor=[[UIColor whiteColor]CGColor];//设置边框颜色
    nextButton.layer.cornerRadius=6.0f;
    nextButton.layer.masksToBounds=YES;
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(success) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:nextButton];
}

#pragma mark--商品图片
-(void)addGoodsImage
{
    goods=[[UIButton alloc]initWithFrame:CGRectMake(0.5*[UIUtils getWindowWidth]-ScreenHeight*1/8,64+space,ScreenHeight*1/4,ScreenHeight*1/4)];
    [goods setTitle:@"添加照片" forState:UIControlStateNormal];
    [goods setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    goods.titleEdgeInsets=UIEdgeInsetsMake(ScreenHeight*1/8, 0, 0, 0);
    goods.layer.cornerRadius=ScreenHeight*1/8;//设置圆形半径
    goods.layer.masksToBounds=YES;//设置边界为圆的
    goods.layer.borderWidth=1.0f;
    goods.layer.borderColor=[[UIColor purpleColor]CGColor];
    [goods addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:goods];
    
    UIImageView *im=[[UIImageView alloc]init];
    im.image=[UIImage imageNamed:@"goods"];
    im.layer.cornerRadius=ScreenHeight*1/8;
    im.layer.masksToBounds=YES;
    im.frame=CGRectMake(0.5*[UIUtils getWindowWidth]-ScreenHeight*1/8,60+space,ScreenHeight*1/4,ScreenHeight*1/4);
    im.alpha=0.3;
    [bgView addSubview:im];
    
}

#pragma mark--标题、价格、描述
-(void)subtittle
{
    NSArray *tittle=@[@"标题",@"价格",@"描述"];
    for (int i=0; i<3; i++) {
        UILabel *tittleLable=[[UILabel alloc]init];
        tittleLable.frame=CGRectMake(0.45*[UIUtils getWindowWidth],60+2*space+ScreenHeight*1/4+80*i, 60, ScreenHeight*1/16);
        tittleLable.text=tittle[i];//标题,价格,描述
        tittleLable.tag=100+10*i;
        [bgView addSubview:tittleLable];
        
        if(i==2)
        {
            content =[[UITextView alloc]init];
            content.text=@"请输入不少于20个字";
            
            content.textAlignment=0;
            content.tag=i+50;
            content.delegate = self;
            content.returnKeyType=UIReturnKeyNext;
            content.frame=CGRectMake(10, CGRectGetMaxY(tittleLable.frame)+space, ScreenWidth-20, ScreenHeight*1/4);
            content.backgroundColor=[UIColor colorWithRed:0.802 green:0.895 blue:0.776 alpha:1.000];
            content.font=[UIFont systemFontOfSize:18];
            [bgView addSubview:content];
        }
        if (i==1) {
            UITextField *contentField=[[UITextField alloc]init];
            contentField.textAlignment=1;
            contentField.tag=i+50;
        
            contentField.delegate = self;
            contentField.frame=CGRectMake(10,CGRectGetMaxY(tittleLable.frame)+space , ScreenWidth-20, ScreenHeight*1/16);
            contentField.backgroundColor=[UIColor colorWithRed:0.802 green:0.895 blue:0.776 alpha:1.000];
            contentField.font=[UIFont systemFontOfSize:20];
            [bgView addSubview:contentField];
        }
        if (i==0)
        {
            UITextField *contentField=[[UITextField alloc]init];
            contentField.textAlignment=1;
            contentField.tag=i+50;
            contentField.delegate = self;
            contentField.frame=CGRectMake(10, CGRectGetMaxY(tittleLable.frame)+space, ScreenWidth-20, ScreenHeight*1/16);
            contentField.backgroundColor=[UIColor colorWithRed:0.802 green:0.895 blue:0.776 alpha:1.000];
            contentField.font=[UIFont systemFontOfSize:20];
            [bgView addSubview:contentField];
        }
    }

}

#pragma mark--textView开始编辑的时候，屏幕上移
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    bgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [UIView animateWithDuration:0.1 animations:^{
        bgView.frame = CGRectMake(0, -205, ScreenWidth, ScreenHeight-205);
    }]; 
}
#pragma mark--textField开始编辑的时候，屏幕上移
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    content.text=@"";
    bgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [UITextField animateWithDuration:0.1 animations:^{
        bgView.frame = CGRectMake(0, -75, ScreenWidth, ScreenHeight-75);
    }];
}

#pragma mark--textView 点击return后，键盘隐藏
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text]&&textView.text.length>10) { //点击return键  键盘消失
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark--textField   点击return后，键盘隐藏
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark-- textView编辑结束的时候，屏幕自动还原
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 50:
            goodTitle=textField.text;
            break;
        case 51:
            goodPrice=textField.text;
            break;
        default:
            break;
    }
    
    bgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
}



-(void)textViewDidEndEditing:(UITextView *)textView
{
    bgView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight+109);
    //描述
    goodDesc=textView.text;
    
}

#pragma mark--发布交易类型等详细信息
-(void)success
{
    
    if (!myID) {
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请到个人中心登录您的帐号" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alter show];

    }else{
    
        indicatorView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicatorView.center=bgView.center;
        indicatorView.frame=bgView.frame;
        
        [bgView addSubview:indicatorView];
        [indicatorView startAnimating];
        
        int rand=arc4random()%1000;
        bmobFile=[[BmobFile alloc]initWithClassName:@"GameScore" withFileName:[NSString stringWithFormat:@"goodImage%d.png",rand] withFileData:imageData];
        
        goodObject=[[BmobObject alloc]init];
        
        if ([bmobFile save]) {
             [indicatorView startAnimating];
            [goodObject setObject:bmobFile forKey:@"filetype"];
            imageUrl=bmobFile.url;
            [indicatorView stopAnimating];
        }

       // [self performSelectorInBackground:@selector(uploadData) withObject:nil];
        
        SendViewController *send=[[SendViewController alloc]init];
        
        send.imageUrl=imageUrl;
        send.goodTitle=goodTitle;
        send.goodPrice=goodPrice;
        send.goodDesc=goodDesc;
        if (content.text.length) {
            
            [self presentViewController:send animated:NO completion:nil];
           
            
        }else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入二十个字以上的描述" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

-(void)uploadData{
    
    
    [goodObject saveInBackgroundWithResultBlock:^(BOOL isSuccessful,NSError *error){
        if (isSuccessful) {
            imageUrl=bmobFile.url;
            
        }else{
            
           
            imageUrl=bmobFile.url;
            
        }
        
    }];

    
}

#pragma mark--添加商品图片
-(void)addPhoto
{
    
    if (!myID) {//判断是否登录
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请到个人中心登录您的帐号" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alter show];
    }else{
    
    //在这里呼出下方菜单按钮项
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
    [myActionSheet showInView:self.view];
        
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == myActionSheet.cancelButtonIndex)
    {
        
    }
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self takePhoto];
            break;
            
        case 1:  //打开本地相册
            [self LocalPhoto];
            break;
    }
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        //NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    // [self.navigationController pushViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        if (UIImagePNGRepresentation(image) == nil)
        {
            imageData = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            imageData = UIImagePNGRepresentation(image);
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        
        UIImageView *smallimage = [[UIImageView alloc] init];
        smallimage.frame=goods.frame;
        smallimage.tag=123;
        smallimage.layer.cornerRadius=CGRectGetWidth(smallimage.frame)/2;
        smallimage.layer.masksToBounds=YES;
        smallimage.image = image;
        //加在视图中
        [bgView addSubview:smallimage];
        
    }
}
//取消按钮
-(void)allRemove{
    
    [self ain];
    UIImageView *image=(UIImageView *)[self.view viewWithTag:123];
    [image removeFromSuperview];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
   // NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
