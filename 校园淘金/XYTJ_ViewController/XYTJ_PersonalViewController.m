//
//  XYTJ_PersonalViewController.m
//  校园淘金--登陆
//
//  Created by scjy on 15/5/13.
//  Copyright (c) 2015年 刘孝勇. All rights reserved.
//

#import "XYTJ_PersonalViewController.h"
#import "XYTJ_PersonData_ViewController.h"
#import "MyPostViewController.h"
#import "MyWantViewController.h"
#import "MyCollectViewController.h"
#import "SuggestViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobQuery.h>
#import <BmobSDK/BmobObject.h>
#import <BmobSDK/BmobProFile.h>
#define ScreenWidth self.view.bounds.size.width
#define ScreenHeight self.view.bounds.size.height
@interface XYTJ_PersonalViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray *personalList;
    BOOL is;
    NSMutableDictionary *userDictionary;
    NSString *personalID;
    NSArray *buttonImageName;
    UIButton *personImage;
    NSMutableDictionary *personalData;
    UILabel *nickLabel;
    UIView *topView;
    UIActionSheet *myActionSheet;
    int a;
    NSString *imageUrl;
}
@end

@implementation XYTJ_PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    if (self.isSuccess == YES) {
        is = self.isSuccess;
    }
    if (self.nID.length >0) {
        personalID = self.nID;
    }
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"退出登录" style:UIBarButtonItemStylePlain target:self action:@selector(exitLogin)];
    self.navigationItem.rightBarButtonItem = rightItem;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"个人资料" style:UIBarButtonItemStylePlain target:self action:@selector(nextstep)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.view.backgroundColor = [UIColor colorWithRed:0.681 green:0.826 blue:1.000 alpha:1.000];
    personalData = [NSMutableDictionary dictionary];
    personalList=@[@"我的发布",@"我的求购",@"我的收藏"];
    buttonImageName = @[@"photo.jpg",@"手机.jpg",@"1111.jpg"];
    [self creatButton];
    [self creatView];
}
-(void)viewWillAppear:(BOOL)animated
{
    if (self.nickName) {
        nickLabel.text = self.nickName;
        [personalData setObject:self.nickName forKey:@"nickname"];
    }

}


-(void)provide
{
    NSArray *documents=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[[documents lastObject]stringByAppendingPathComponent:@"MyID.id"];
    NSLog(@"%@",path);
    NSArray *dataArr=@[personalID];
     BOOL iss= [dataArr writeToFile:path atomically:YES];
    if (iss == YES) {
        NSLog(@"%@",path);
    }
}

-(void)exitLogin
{
    if (is == YES) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"已退出" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [personImage setImage:[UIImage imageNamed:@"PhotoImage"] forState:UIControlStateNormal];
        is = NO;
        personalID = nil;
        nickLabel.text = @"";
    }
    NSArray *documents=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[[documents lastObject]stringByAppendingPathComponent:@"MyID.id"];
    NSFileManager *manager=[NSFileManager defaultManager];
    [manager removeItemAtPath:path error:nil];
    
}
-(void)getBOOL:(BOOL)isSuccess objectID:(NSString *)ID UserData:(NSMutableDictionary *)UserDic
{
    is = isSuccess;
    NSLog(@"is:%d",is);
    personalID = ID;
    [self provide];
    UIView *view = [self.view viewWithTag:33];
    [view removeFromSuperview];
    if (UserDic[@"nickname"]) {
       [personalData setObject:UserDic[@"nickname"] forKey:@"nickname"];
    }
    [self creatView];
    NSLog(@"  user%@",UserDic);
}
-(void)creatView
{
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, ScreenWidth, ScreenHeight/3+60)];
    topView.tag = 33;
    [self.view addSubview:topView];
    UIImageView *imageView= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight/3+60)];
    [topView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"82.jpg"];
    personImage=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2-ScreenHeight/16,  ScreenHeight/3-80,  ScreenHeight/8,  ScreenHeight/8)];
    [personImage setImage:[UIImage imageNamed:@"PhotoImage"] forState:UIControlStateNormal];
    personImage.layer.cornerRadius = ScreenHeight/16;
    [personImage.layer setMasksToBounds:YES];
    [topView addSubview:personImage];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"UserInfo"];
    [bquery getObjectInBackgroundWithId:personalID block:^(BmobObject *object,NSError *error){
        if (error){
            //进行错误处理
        }else{
            if (object) {
                
                NSString *headImageUrl = [object objectForKey:@"headImageUrl"];
                NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:headImageUrl]];
                [personImage setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                if(!headImageUrl){
                     [personImage setImage:[UIImage imageNamed:@"PhotoImage"] forState:UIControlStateNormal];
                }
            }
        }
    }];
    
    [personImage addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    nickLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-90, CGRectGetMaxY(personImage.frame)+10, 180, 20)];
    nickLabel.backgroundColor = [UIColor clearColor];
    nickLabel.textAlignment = NSTextAlignmentCenter;
    nickLabel.text = personalData[@"nickname"];
     NSLog(@"%@",personalData);
    [topView addSubview:nickLabel];

}
#pragma mark---打开图片功能
-(void)addImage
{
    if (is == YES) {
        [topView reloadInputViews];
        personImage.enabled = YES;
        myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
    myActionSheet.tag=17;
    [myActionSheet showInView:self.view];
    }else{
        XYTJ_LoginView *loginView = [[XYTJ_LoginView alloc]initWithFrame:self.view.frame];
        loginView.delegate = self;
        [self.view addSubview:loginView];
    }
    
}

-(void)creatButton
{
    for (int i = 0; i<3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(ScreenWidth/16+(ScreenWidth/4+ScreenWidth/16)*i, ScreenHeight/2+40, ScreenWidth/4, ScreenWidth/4);
        button.tag = 66+i;
        [button setImage:[UIImage imageNamed:buttonImageName[i]] forState:UIControlStateNormal];
        button.layer.cornerRadius = ScreenHeight/8;
        [button.layer setMasksToBounds:YES];
        [self.view addSubview:button];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth *3/16-40+(ScreenWidth/4+ScreenWidth/16)*i, CGRectGetMaxY(button.frame)+10, 80, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = personalList[i];
        [self.view addSubview:label];
        [button addTarget:self action:@selector(withNext:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)withNext:(UIButton *)button
{
    if (is == YES) {
        if (button.tag == 66) {
            MyPostViewController *MPVC=[[MyPostViewController alloc]init];
            [self.navigationController pushViewController:MPVC animated:YES];
        }else if(button.tag == 67){
            MyWantViewController *MWVC=[[MyWantViewController alloc]init];
            [self.navigationController pushViewController:MWVC animated:YES];
        }else{
            MyCollectViewController *MCVC=[[MyCollectViewController alloc]init];
            [self.navigationController pushViewController:MCVC animated:YES];
        }
    }else{
        XYTJ_LoginView *loginView = [[XYTJ_LoginView alloc]initWithFrame:self.view.frame];
        loginView.delegate = self;
        [self.view addSubview:loginView];
    }
}


-(void)nextstep
{
    userDictionary = [NSMutableDictionary dictionary];
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"UserInfo"];
    [bquery getObjectInBackgroundWithId:personalID block:^(BmobObject *object,NSError *error){
        if (error){
            XYTJ_LoginView *loginView = [[XYTJ_LoginView alloc]initWithFrame:self.view.frame];
            loginView.delegate = self;
            [self.view addSubview:loginView];
            NSLog(@"%@",error);
        }else{
            if (object) {
                NSString *nickname = [object objectForKey:@"nickname"];
                NSString *phone = [object objectForKey:@"phone"];
                NSString *QQ = [object objectForKey:@"qq"];
                NSString *schoolName = [object objectForKey:@"school"];
                NSString *address = [object objectForKey:@"address"];
                [userDictionary setValue:nickname forKey:@"nickname"];
                [userDictionary setValue:phone forKey:@"phone"];
                [userDictionary setValue:QQ forKey:@"qq"];
                [userDictionary setValue:schoolName forKey:@"school"];
                [userDictionary setValue:address forKey:@"address"];
                XYTJ_PersonData_ViewController *PDVC = [[XYTJ_PersonData_ViewController alloc]init];
                PDVC.ID = personalID;
                PDVC.UserDictionary = userDictionary;
                [self.navigationController pushViewController:PDVC animated:YES];
            }
        }
    }];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (actionSheet.tag==17) {
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
    
}

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
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}
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
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *imageData;
        if (UIImagePNGRepresentation(image) == nil)
        {
            imageData = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            imageData = UIImagePNGRepresentation(image);
        }
        [personImage setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
        [picker dismissViewControllerAnimated:YES completion:nil];
        a++;
        NSString *imageName =[NSString stringWithFormat:@"headerImage%d.jpg",a];
//        [BmobProFile uploadFileWithFilename:imageName fileData:imageData block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url) {
//            if (isSuccessful) {
//                imageUrl = url;
//                NSLog(@"%@",imageUrl);
//                BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"UserInfo"  objectId:personalID];
//                [bmobObject setObject:imageUrl forKey:@"headImageUrl"];
//                [bmobObject updateInBackground];
//            }
//        } progress:^(CGFloat progress) {
//            //上传进度，此处可编写进度条逻辑
//            NSLog(@"progress %f",progress);
//        }];
        
       
        BmobFile *bmobFile=[[BmobFile alloc]initWithClassName:@"GameScore" withFileName:imageName withFileData:imageData];
        BmobObject *goodObject=[[BmobObject alloc]init];
        
        if ([bmobFile save]) {
            [goodObject setObject:bmobFile forKey:@"filetype"];
        }
        
        [goodObject saveInBackgroundWithResultBlock:^(BOOL isSuccessful,NSError *error){
            if (isSuccessful) {
                
               
                imageUrl=bmobFile.url;
                
                
            }else{
                NSLog(@"上传失败");
                imageUrl=bmobFile.url;
            }
            BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"UserInfo"  objectId:personalID];
            imageUrl=bmobFile.url;
            [bmobObject setObject:imageUrl forKey:@"headImageUrl"];
            [bmobObject updateInBackground];
            
        }];

        
        
        

    }
    
}


-(void)hehe
{
    
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
