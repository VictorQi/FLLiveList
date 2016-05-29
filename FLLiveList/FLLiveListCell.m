//
//  FLLiveListCell.m
//  FLLiveList
//
//  Created by v.q on 16/5/29.
//  Copyright © 2016年 victor. All rights reserved.
//

#import "FLLiveListCell.h"
#import "FLLiveListModel.h"

@interface FLLiveListCell ()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, strong) RACDisposable *subscription;
@end

@implementation FLLiveListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [UIColor darkGrayColor];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:self.bounds];
    imageview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:imageview];
    self.imageView = imageview;
    
    return self;
}

- (void)setPhotoModel:(FLLiveListModel *)photoModel {
    self.subscription = [[[RACObserve(photoModel, thumbnailData) filter:^BOOL(id value) {
        return value != nil;
    }] map:^id(id value) {
        return [UIImage imageWithData:value];
    }] setKeyPath:@keypath(self.imageView, image) onObject:self.imageView];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.subscription dispose];
    self.subscription = nil;
}
@end
