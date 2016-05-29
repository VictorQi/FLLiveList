//
//  FLLiveListModel.h
//  FLLiveList
//
//  Created by v.q on 16/5/29.
//  Copyright © 2016年 victor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLLiveListModel : NSObject

@property (nonatomic, copy) NSString *photoName;
@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, copy) NSString *photographerName;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, copy) NSString *thumbnailURL;
@property (nonatomic, copy) NSData *thumbnailData;
@property (nonatomic, copy) NSString *fullsizedURL;
@property (nonatomic, copy) NSData *fullsizedData;

@end
