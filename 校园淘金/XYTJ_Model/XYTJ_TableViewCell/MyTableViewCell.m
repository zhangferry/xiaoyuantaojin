//
//  MyTableViewCell.m
//  校园淘金
//
//  Created by zhangfei on 15/4/22.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import "MyTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation MyTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addContentView];
        
    }
    return self;
    
}

-(void)addContentView{
    
    self.backgroundColor=[UIColor clearColor];
    
    self.image=[[UIImageView alloc]init];
    [self addSubview:self.image];
    self.image.translatesAutoresizingMaskIntoConstraints=NO;
    self.title=[[UILabel alloc]init];
    self.title.font=[UIFont systemFontOfSize:15];
    self.title.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:self.title];
    
    self.address=[[UILabel alloc]init];
    self.address.font=[UIFont systemFontOfSize:9];
    self.address.textColor=[UIColor grayColor];
    self.address.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:self.address];
    
    self.desc=[[UILabel alloc]init];
    self.desc.font=[UIFont systemFontOfSize:10];
    self.desc.numberOfLines=3;
    self.desc.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:self.desc];
    
    self.date=[[UILabel alloc]init];
    self.date.textAlignment=2;
    self.date.translatesAutoresizingMaskIntoConstraints=NO;
    self.date.font=[UIFont systemFontOfSize:8];
    [self addSubview:self.date];
    
    self.price=[[UILabel alloc]init];
    self.price.translatesAutoresizingMaskIntoConstraints=NO;
    self.price.textColor=[UIColor redColor];
    self.price.font=[UIFont systemFontOfSize:15];
    [self addSubview:self.price];
    
    self.dingwei=[[UIImageView alloc]init];
    self.dingwei.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:self.dingwei];

    
}
-(void)setContentView:(purchaseModel *)purchModel{
    
    NSDictionary *dicView=NSDictionaryOfVariableBindings(_image,_price,_title,_address,_date,_desc,_dingwei);
    NSArray *arrayH=@[@"H:|-10-[_image(>=80)]-240-|",@"H:[_image]-10-[_title(>=80)]",@"H:[_image]-10-[_desc(>=150)]-10-|",@"H:[_image]-5-[_dingwei(>=5)]-210-|",@"H:[_date(>=45)]-10-|",@"H:[_price(>=20)]-10-|",@"H:[_dingwei]-0-[_address(>=12)]"];
    
    NSArray *arrayV=@[@"V:|-10-[_image(>=80)]-10-|",@"V:|-15-[_title(>=20)]",@"V:[_title]-5-[_desc(>=20)]",@"V:[_desc]-30-[_dingwei(>=10)]-10-|",@"V:[_desc]-20-[_date(>=10)]",@"V:[_date]-10-[_price(>=10)]-10-|",@"V:[_desc]-32-[_address(>=10)]-10-|"];
    
    for (int i=0; i<7; i++) {
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:arrayH[i] options:0 metrics:nil views:dicView]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:arrayV[i] options:0 metrics:nil views:dicView]];
        
    }
    
//    __block UIImage *imageShow;
//    imageShow = [UIImage imageNamed:@"1"];
//    dispatch_queue_t loadImageQueue=dispatch_get_main_queue();
//    dispatch_async(loadImageQueue, ^{
//        
//        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:purchModel.imageUrl]];
//        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                imageShow=[UIImage imageWithData:data];
//                self.image.image=imageShow;
//                
//                
//                
//            });
//            
//        }];
//        
//    });
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:purchModel.imageUrl] placeholderImage:[UIImage imageNamed:@"noNetwork"]];//sdwebImage第三方缓存图片
    
    self.title.text=purchModel.goodTitle;
    self.desc.text=purchModel.goodDesc;
    self.price.text=purchModel.goodPrice;
    self.address.text=purchModel.sendAddress;
    
    NSDate *dateNow=[NSDate date];
    NSTimeInterval timeLastFromNow=[dateNow timeIntervalSinceDate:purchModel.publishDate];
    int day=timeLastFromNow/(3600*24);
    
    if (day==0) {
        int hour=timeLastFromNow/3600;
        
        if (hour==0) {
            int minutes=timeLastFromNow/60;
            self.date.text=[NSString stringWithFormat:@"%d分钟前",minutes];
        }else{
            self.date.text=[NSString stringWithFormat:@"%d小时前",hour];
        }
    }else{
        self.date.text=[NSString stringWithFormat:@"%d天前",day];
    }
    self.dingwei.image=[UIImage imageNamed:@"map"];
    
}

@end
