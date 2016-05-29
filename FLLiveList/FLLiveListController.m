//
//  FLLiveListController.m
//  FLLiveList
//
//  Created by v.q on 16/5/28.
//  Copyright © 2016年 victor. All rights reserved.
//

#import "FLLiveListController.h"
#import "FLLiveListFlowLayout.h"
#import "FLLiveListImporter.h"
#import "FLLiveListCell.h"

@interface FLLiveListController ()
@property (nonatomic, copy) NSArray *photoArray;

@end

@implementation FLLiveListController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init {
    FLLiveListFlowLayout *flowLayout = [[FLLiveListFlowLayout alloc]init];
    self = [self initWithCollectionViewLayout:flowLayout];
    if (!self) {
        return nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Popular on 500px";
    
    // Register cell classes
    [self.collectionView registerClass:[FLLiveListCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    @weakify(self);
    [RACObserve(self, photoArray) subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
    
    [self loadPopularPhotos];
}

- (void)loadPopularPhotos {
    [[FLLiveListImporter importPhotos] subscribeNext:^(id x) {
        self.photoArray = x;
    } error:^(NSError *error) {
        NSLog(@"Couldn't fetch photo from 500px: %@",error);
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
 
    FLLiveListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setPhotoModel:self.photoArray[indexPath.row]];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>


@end
