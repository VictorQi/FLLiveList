//
//  FLLiveListImporter.m
//  FLLiveList
//
//  Created by v.q on 16/5/29.
//  Copyright © 2016年 victor. All rights reserved.
//

#import "FLLiveListImporter.h"
#import "FLLiveListModel.h"

@implementation FLLiveListImporter
+ (RACSignal *)importPhotos {
    RACReplaySubject *subject = [RACReplaySubject subject];
    NSURLRequest *request = [self popularRequest];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               if (data) {
                                   id results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   
                                   [subject sendNext:[[[results[@"photos"] rac_sequence] map:^id(NSDictionary *photoDictionary) {
                                       FLLiveListModel *model = [FLLiveListModel new];
                                       [self configurePhotoModel:model withDictionary:photoDictionary];
                                       [self downloadThumbnailForPhotoModel:model];
                                       
                                       return model;
                                   }] array]];
                                   [subject sendCompleted];
                               } else {
                                   [subject sendError:connectionError];
                               }
                           }];
    return  subject;
}

+ (NSURLRequest *)popularRequest {
    return [[AppDelegate shareAppDelegate].apiHelper
            urlRequestForPhotoFeature:PXAPIHelperPhotoFeaturePopular
            resultsPerPage:100
            page:0
            photoSizes:PXPhotoModelSizeThumbnail
            sortOrder:PXAPIHelperSortOrderRating
            except:PXPhotoModelCategoryNude];
}

+ (void)configurePhotoModel:(FLLiveListModel *)photoModel withDictionary:(NSDictionary *)dictionary {
    photoModel.photoName = dictionary[@"name"];
    photoModel.identifier = dictionary[@"id"];
    photoModel.photographerName = dictionary[@"user"][@"username"];
    photoModel.rating = dictionary[@"rating"];
    
    photoModel.thumbnailURL = [self urlForImageSize:3 inArray:dictionary[@"images"]];
    
    if (dictionary[@"comments_count"]) {
        photoModel.fullsizedURL = [self urlForImageSize:4 inArray:dictionary[@"images"]];
    }
}

+ (NSString *)urlForImageSize:(NSInteger)size inArray:(NSArray *)array {
    return [[[[[array rac_sequence] filter:^BOOL(NSDictionary *value) {
        return [value[@"size"] integerValue] == size;
    }] map:^id(id value) {
        return value[@"url"];
    }] array] firstObject];
}

+ (void)downloadThumbnailForPhotoModel:(FLLiveListModel *)photoModel {
    NSAssert(photoModel.thumbnailURL, @"Thumbnail URL must not be nil");
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:photoModel.thumbnailURL]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError)  {
                               photoModel.thumbnailData = data;
                           }];
}

@end
