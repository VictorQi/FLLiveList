//
//  FLLiveListFlowLayout.m
//  FLLiveList
//
//  Created by v.q on 16/5/29.
//  Copyright © 2016年 victor. All rights reserved.
//

#import "FLLiveListFlowLayout.h"

@implementation FLLiveListFlowLayout

- (instancetype)init {
    if (!(self = [super init])) {
        return nil;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 2.0 - 20.0;
    self.itemSize = CGSizeMake(width, width);
    self.minimumLineSpacing = 10;
    self.minimumInteritemSpacing = 10;
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    return self;
}

@end
