//
//  ViewController.h
//  LiveDemo
//
//  Created by Apple on 2018/2/1.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSDictionary* roomInfo;
@end

