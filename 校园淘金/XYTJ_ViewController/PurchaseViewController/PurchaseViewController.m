//
//  PurchaseViewController.m
//  校园淘金
//
//  Created by zhangfei on 15/4/22.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import "PurchaseViewController.h"
#import "ViewController.h"
#import "CommentTableViewCell.h"
#import "PersonMessagesTableViewCell.h"
#import <BmobSDK/Bmob.h>
#import <ShareSDK/ShareSDK.h>
#import <SDWebImage/UIImageView+WebCache.h>

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface PurchaseViewController ()
{
    float width;
    
    UIButton *collectBUtton;
    UILabel *collectLable;
    UIView *senderView;
    NSTimer *timer;
    NSString *message;
    NSString *text;
    UILabel *messageLable;
    UIButton *liuyan;
    UIButton *send;
    UITextField *textInputField;
    UITableView *myTableView;
    
    NSString *_userPhone;
    NSString *_userQQ;
    NSString *_name;
    NSString *_goodID;
    NSMutableArray *messageArray;
    NSMutableArray *collectArray;
    UITextField *inputTextField;
    UIView *textSendView;
    UIButton *contect;
    int keybordHeight;
    NSString *myID;
    NSString *imageUrl;
    NSDictionary *myDic;
    NSString *userInfoID;
    
    NSString *headImageUrl;
    NSString *nickName;
    UIView *viewShow;
    UIView *personView;
    int collectState;
}
@end

@implementation PurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getMyID];
    [self initkeyBoard];
    [self initSellerData];
    [self initData];
    [self initView];
}
#pragma mark-获取登录状态
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
    
    NSArray *documents2=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path2=[[documents2 lastObject]stringByAppendingPathComponent:@"MyData.id"];
    myDic = [NSDictionary dictionaryWithContentsOfFile:path2];
    
}

-(void)initkeyBoard{
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
}

-(void)initData{
    
    messageArray=[NSMutableArray array];
    collectArray=[NSMutableArray array];
#pragma mark-数据查询
    BmobQuery *bquery=[BmobQuery queryWithClassName:@"purchaseData"];
    [bquery getObjectInBackgroundWithId:_goodID block:^(BmobObject *object, NSError *error) {
        
        if (!error) {
            if (object) {
                messageArray=[object objectForKey:@"messages"];
                
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
                [myTableView reloadData];
            
        });
        
        
    }];

    
    BmobQuery *bquery1=[BmobQuery queryWithClassName:@"UserInfo"];
    [bquery1 getObjectInBackgroundWithId:myID block:^(BmobObject *object, NSError *error) {
       
        imageUrl=[object objectForKey:@"headImageUrl"];
        
    }];
    
    
}

-(void)initSellerData{
    
    width=self.view.bounds.size.width;
    _userPhone=self.userPhone;
    _userQQ=self.userQQ;
    _name=self.name;
    _goodID=self.goodID;
    
    BmobQuery *bquery=[BmobQuery queryWithClassName:@"purchaseData"];
    [bquery includeKey:@"userId"];
    [bquery getObjectInBackgroundWithId:_goodID block:^(BmobObject *object, NSError *error) {
       
        
        BmobObject *sellerInfo=[object objectForKey:@"userId"];
        headImageUrl=[sellerInfo objectForKey:@"headImageUrl"];
        nickName=[sellerInfo objectForKey:@"nickname"];
        
        [self performSelectorOnMainThread:@selector(initSellerView) withObject:nil waitUntilDone:YES];
        
    }];
    
}

-(void)initView{
    
    self.view.backgroundColor=[UIColor colorWithRed:230.0/255 green:237.0/255 blue:238.0/255 alpha:1.0f];
    UIView *viewTop=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 20)];
    viewTop.backgroundColor=[UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:viewTop];
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, width, 35)];
    headView.backgroundColor=[UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.5];
    
    [self.view addSubview:headView];
    
    UIButton *returnBUtton=[UIButton buttonWithType:UIButtonTypeCustom];
    [returnBUtton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    returnBUtton.frame=CGRectMake(10, 0, 30, 30);
    [returnBUtton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [returnBUtton addTarget:self action:@selector(returnMain) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:returnBUtton];
    
    collectBUtton=[UIButton buttonWithType:UIButtonTypeCustom];
    //[collectBUtton setBackgroundImage:[UIImage imageNamed:@"heart290"] forState:UIControlStateNormal];
    collectBUtton.frame=CGRectMake(width-50, 0, 30, 30);
    [collectBUtton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [collectBUtton addTarget:self action:@selector(Collect:) forControlEvents:UIControlEventTouchUpInside];
    collectBUtton.selected=YES;
    [headView addSubview:collectBUtton];
    
    
    [self.view addSubview:collectLable];

#pragma mark-加载用户头像
    [self changCollectImage];
    
    UIButton *shareButton=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(collectBUtton.frame)-40, 0, 27, 27 )];
    [shareButton setImage:[UIImage imageNamed:@"share_1"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareMy) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:shareButton];
    
#pragma mark-图片滚动视图
    UIScrollView *purchaseScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame), width, ScreenHeight/3)];
    
    purchaseScroll.delegate=self;
    purchaseScroll.showsHorizontalScrollIndicator=NO;
    purchaseScroll.contentSize=CGSizeMake(width, 260);
    purchaseScroll.pagingEnabled=YES;
    [self.view addSubview:purchaseScroll];
    

    senderView=[[UIView alloc]initWithFrame:CGRectMake(0, 100, width, width)];
    [self.view addSubview:senderView];
    UIImageView *imagev=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, CGRectGetHeight(purchaseScroll.frame))];
    imagev.image=self.image;
    [purchaseScroll addSubview:imagev];
    
    viewShow=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(purchaseScroll.frame), width, 60)];
    viewShow.backgroundColor=[UIColor orangeColor];
    [self.view addSubview:viewShow];

    
    UILabel *descLable=[[UILabel alloc]initWithFrame:CGRectMake(20, 4, 235, 50)];
    descLable.text=self.desc;
    descLable.numberOfLines=0;
    descLable.font=[UIFont systemFontOfSize:12];
    descLable.textColor=[UIColor blackColor];
    [viewShow addSubview:descLable];
    
    UILabel *skimLable=[[UILabel alloc]initWithFrame:CGRectMake(width-75, 44, 75, 15)];
    skimLable.text=@"浏览次数 33";
    
    skimLable.font=[UIFont systemFontOfSize:12];
    skimLable.textColor=[UIColor blackColor];
    [viewShow addSubview:skimLable];
    
    UILabel *priceLable=[[UILabel alloc]initWithFrame:CGRectMake(width-60-10, -30, 60, 60)];
    priceLable.text=self.price;
    priceLable.textAlignment=1;
    priceLable.backgroundColor=[UIColor redColor];
    priceLable.layer.cornerRadius=30;
    [priceLable.layer setMasksToBounds:YES];
    priceLable.textColor=[UIColor whiteColor];
    [viewShow addSubview:priceLable];
#pragma mark-用户信息视图
    personView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(viewShow.frame)+10, width, 50)];
    personView.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:personView];
    
    
    liuyan=[UIButton buttonWithType:UIButtonTypeCustom];
    [liuyan setTitle:@"评论" forState:UIControlStateNormal];
    liuyan.frame=CGRectMake(width-70, CGRectGetMaxY(personView.frame)+10, 50, 20);
    liuyan.layer.cornerRadius=4;
    
    [liuyan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [liuyan addTarget:self action:@selector(sendLiuyan) forControlEvents:UIControlEventTouchUpInside];
    liuyan.backgroundColor=[UIColor brownColor];
    [self.view addSubview:liuyan];

    
    
    contect=[UIButton buttonWithType:UIButtonTypeCustom];
    [contect setTitle:@"联系卖家" forState:UIControlStateNormal];
    [contect addTarget:self action:@selector(Contect) forControlEvents:UIControlEventTouchUpInside];
    contect.showsTouchWhenHighlighted=YES;
    contect.frame=CGRectMake((width-100)/2, self.view.frame.size.height-60, 100, 40);
    contect.backgroundColor=[UIColor redColor];
    contect.alpha=0.3;
    contect.layer.cornerRadius=7;
    
    [self.view addSubview:contect];
    
    
    
    
    textSendView=[[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-40, ScreenWidth, 40)];
    textSendView.layer.borderWidth=1;
    textSendView.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    textSendView.backgroundColor=[UIColor whiteColor];
    
    //[self.view bringSubviewToFront:textSendView];
    
    send=[[UIButton  alloc]initWithFrame:CGRectMake(ScreenWidth-50, 0, 50, 40)];
    send.backgroundColor=[UIColor whiteColor];
    [send setTitle:@"发送" forState:UIControlStateNormal];
    [send setBackgroundColor:[UIColor grayColor]];
    send.layer.cornerRadius=5;
    [send addTarget:self action:@selector(upp) forControlEvents:UIControlEventTouchUpInside];
    [textSendView addSubview:send];
    
    textInputField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-50, 40)];
    textInputField.delegate=self;
    textInputField.placeholder=@"点击这里评论";
    [textSendView addSubview:textInputField];
#pragma mark -tableview加载
    myTableView=[[UITableView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(liuyan.frame)+5, ScreenWidth-20, CGRectGetMinY(contect.frame)-CGRectGetMaxY(liuyan.frame)-10) style:UITableViewStylePlain];
    myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    myTableView.delegate=self;
    myTableView.dataSource=self;
    myTableView.showsVerticalScrollIndicator=NO;
    myTableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:myTableView];
    
}

-(void)initSellerView{
    
    
#pragma mark-卖家头像
    UIImageView *personImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 50, 50)];
    [personImage sd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:[UIImage imageNamed:@"userDefault"]];
    
    personImage.layer.cornerRadius=25;
    [personImage.layer setMasksToBounds:YES];
    [personView addSubview:personImage];
    
    UILabel *nameLable=[[UILabel alloc]initWithFrame:CGRectMake(100, 10, 80, 20)];
    nameLable.text=nickName;
    nameLable.font=[UIFont systemFontOfSize:13];
    [personView addSubview:nameLable];
    UILabel *addressLable=[[UILabel alloc]initWithFrame:CGRectMake(100, 30, 70, 20)];
    addressLable.text=self.address;
    addressLable.font=[UIFont systemFontOfSize:13];
    [personView addSubview:addressLable];
    
    
}

-(void)shareMy{
    
    if (!myID) {
        
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请到个人中心登录您的帐号" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alter show];
        
    }else{
    
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"jpg"];
    
    //1、构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"小伙伴们，我看到了一个很有价值的东西,%@,快来凑热闹啊",_name]
                                       defaultContent:@"默认内容"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.mob.com"
                                          description:@"这是一条演示信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    //1+创建弹出菜单容器（iPad必要）
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    
    //2、弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                //可以根据回调提示用户。
                                if (state == SSResponseStateSuccess)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                    message:nil
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                    message:[NSString stringWithFormat:@"失败描述：%@",[error errorDescription]]
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                            }];

    }
    
    
}
-(void)returnMain{

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark-收藏

-(void)changCollectImage{
    
    BmobQuery *bquery=[BmobQuery queryWithClassName:@"UserInfo"];
    [bquery getObjectInBackgroundWithId:myID block:^(BmobObject *object, NSError *error) {
        
        if (!error) {
            
            if (object) {
                collectArray=[object objectForKey:@"collect"];
                //判断出数组 里面含有此元素
                if ([collectArray indexOfObject:_goodID]!=NSNotFound) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [collectBUtton setBackgroundImage:[UIImage imageNamed:@"heart 2"] forState:UIControlStateNormal];
                        collectState=1;
                    });
                    
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [collectBUtton setBackgroundImage:[UIImage imageNamed:@"heart290"] forState:UIControlStateNormal];
                        collectState=0;
                        });
                    }
                
            }else{
                
            }
        }else{
         
        }
    }];

}

-(void)Collect:(UIButton *)sender{
    
    if (!myID) {
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请到个人中心登录您的帐号" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alter show];
    }else{
    
        if (collectState==1) {
           
            BmobQuery *bquery=[BmobQuery queryWithClassName:@"UserInfo"];
            [bquery getObjectInBackgroundWithId:myID block:^(BmobObject *object, NSError *error) {
                
                if (!error) {
                    if (object) {
                        
                        UILabel *collectL=[[UILabel alloc]initWithFrame:CGRectMake((width-75)/2, ScreenHeight/3*2, 75, 30)];
                        
                        collectL.textAlignment=1;
                        collectL.tag=66;
                        collectL.backgroundColor=[UIColor whiteColor];
                        collectL.text=@"取消收藏";
                        [self.view addSubview:collectL];
                        
                        timer=[NSTimer timerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                        [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];

                        collectArray=[object objectForKey:@"collect"];
                        [collectArray removeObject:_goodID];
                        BmobObject *obj=[BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];

                        [obj setObject:[NSArray arrayWithArray:collectArray] forKey:@"collect"];
                        [obj updateInBackground];
                        
                        
                        
                        collectState=0;
                        [collectBUtton setBackgroundImage:[UIImage imageNamed:@"heart290"] forState:UIControlStateNormal];
                    }
                }
            }];

            
        }else{
            
            BmobQuery *bquery=[BmobQuery queryWithClassName:@"UserInfo"];
            [bquery getObjectInBackgroundWithId:myID block:^(BmobObject *object, NSError *error) {
                
                if (!error) {
                    if (object) {
                        UILabel *collectL=[[UILabel alloc]initWithFrame:CGRectMake((width-75)/2, ScreenHeight/3*2, 75, 30)];
                        
                        
                        collectL.textAlignment=1;
                        collectL.tag=66;
                        collectL.backgroundColor=[UIColor whiteColor];
                        collectL.text=@"已收藏";
                        [self.view addSubview:collectL];
                        
                        timer=[NSTimer timerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                        [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
                        
                        
                        collectArray=[object objectForKey:@"collect"];
                        [collectArray addObject:_goodID];
                        BmobObject *obj=[BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
                        
                        [obj setObject:[NSArray arrayWithArray:collectArray] forKey:@"collect"];
                        [obj updateInBackground];
                        
                        
                        
                        collectState=1;
                        [collectBUtton setBackgroundImage:[UIImage imageNamed:@"heart 2"] forState:UIControlStateNormal];
                    }
                }
            }];

        }
        
    }
    
}



-(void)Contect{
    
    UIActionSheet  *sheet=[[UIActionSheet  alloc]initWithTitle:@"联系方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拨打手机" otherButtonTitles:@"获取QQ" , nil];
    [sheet  showInView:self.view];
  
}
//action代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (buttonIndex==0) {
        
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_userPhone]]];
        
    }else if(buttonIndex==2){
        
        }else{
        
        UIAlertView *alertContect=[[UIAlertView alloc]initWithTitle:@"卖家信息" message:[NSString stringWithFormat:@"QQ号是：%@",_userQQ] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"复制", nil];
        [alertContect show];
        
        
    }

}
-(void)removeLable{
    
    UILabel *lable=(UILabel *)[self.view viewWithTag:66];
    [lable removeFromSuperview];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return messageArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellID=@"cellID";
    PersonMessagesTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[PersonMessagesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.myMessageView.backgroundColor=[UIColor whiteColor];
    cell.myImageView.image=[UIImage imageNamed:@"userDefault"];
    cell.myTitleLable.text=@"匿名";
    cell.myMessageLable.text=messageArray[indexPath.row];
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
#pragma mark-发送评论
-(void)upp{
    
    if ([message isEqualToString:@""]) {
      
        
        [textSendView removeFromSuperview];
        
    }else{
        messageArray=[NSMutableArray array];
        BmobQuery *bquery=[BmobQuery queryWithClassName:@"purchaseData"];
        [bquery getObjectInBackgroundWithId:_goodID block:^(BmobObject *object, NSError *error) {
            
            if (!error) {
                if (object) {
                    //message=textField.text;
                    messageArray=[object objectForKey:@"messages"];
                    [messageArray addObject:message];
                    BmobObject *obj=[BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
                    
                    [obj setObject:[NSArray arrayWithArray:messageArray] forKey:@"messages"];
                    [obj updateInBackground];
                    
                    [self initData];
                    //[myTableView reloadData];
                    [textInputField resignFirstResponder];
                    [textSendView removeFromSuperview];
                    textInputField.text=@"";
                    message=@"";
                    
                }else{
                    
                }
            }
            
        }];
        
    }
}
-(void)sendLiuyan{
    
    if (!myID) {
        
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请到个人中心登录您的帐号" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alter show];
        
    }else{
        
        [self.view addSubview:textSendView];
        [inputTextField becomeFirstResponder];
        
    }
}
#pragma mark-输入框代理
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //self.view.frame=CGRectMake(0, 0, width, 667);
    message=textField.text;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    message=textField.text;
    
    self.view.frame=CGRectMake(0, 0, width, 667);
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    textSendView.frame=CGRectMake(0, ScreenHeight-40, ScreenWidth, 40);
    return YES;
    
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keybordHeight = keyboardRect.size.height;
    
    [self.view addSubview:textSendView];
    [UIView animateWithDuration:0.2 animations:^{
        textSendView.frame=CGRectMake(0, ScreenHeight-40-keybordHeight, ScreenWidth, 40);
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
   
}


@end
