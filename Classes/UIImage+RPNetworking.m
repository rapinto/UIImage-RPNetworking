//
//  UIImage+RPNetworking.m
//
//
//  Created by Raphaël Pinto on 19/08/2014.
//
// The MIT License (MIT)
// Copyright (c) 2015 Raphael Pinto.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.




#import "UIImage+RPNetworking.h"



@implementation UIImageView (RPNetworking)



@dynamic af_imageRequestOperation;
@dynamic imageContentMode;
@dynamic placeholderImageContentMode;



+ (NSOperationQueue *)af_sharedImageRequestOperationQueue {
    static NSOperationQueue *_af_sharedImageRequestOperationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _af_sharedImageRequestOperationQueue = [[NSOperationQueue alloc] init];
        _af_sharedImageRequestOperationQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
    });
    
    return _af_sharedImageRequestOperationQueue;
}




- (void)setImageWithURL:(NSURL*)url
       imageContentMode:(UIViewContentMode)imageContentMode
       placeholderImage:(UIImage *)placeholderImage
 placeholderContentMode:(UIViewContentMode)placeholderContentMode
                success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
  downloadProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))downloadProgressBlock

{
    [self cancelImageRequestOperation];
    
    NSURLRequest* imageRequest = [NSURLRequest requestWithURL:url
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];

    
    UIImage *cachedImage = [[[self class] sharedImageCache] cachedImageForRequest:imageRequest];
    if (cachedImage){
        if (success) {
            success(nil, nil, cachedImage);
        } else {
            self.contentMode = imageContentMode;
            self.image = cachedImage;
        }
        
        self.af_imageRequestOperation = nil;
    }
    else {
        if (placeholderImage) {
            self.contentMode = placeholderContentMode;
            self.image = placeholderImage;
        }
        
        __weak __typeof(self)weakSelf = self;
        self.af_imageRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:imageRequest];
        self.af_imageRequestOperation.responseSerializer = self.imageResponseSerializer;
        [self.af_imageRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if ([[imageRequest URL] isEqual:[strongSelf.af_imageRequestOperation.request URL]]) {
                if (success) {
                    success(imageRequest, operation.response, responseObject);
                } else if (responseObject) {
                    strongSelf.contentMode = imageContentMode;
                    strongSelf.image = responseObject;
                }
                
                if (operation == strongSelf.af_imageRequestOperation){
                    strongSelf.af_imageRequestOperation = nil;
                }
            }
            
            [[[strongSelf class] sharedImageCache] cacheImage:responseObject forRequest:imageRequest];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if ([[imageRequest URL] isEqual:[strongSelf.af_imageRequestOperation.request URL]]) {
                if (failure) {
                    failure(imageRequest, operation.response, error);
                }
                
                if (operation == strongSelf.af_imageRequestOperation){
                    strongSelf.af_imageRequestOperation = nil;
                }
            }
        }];
        
        if (downloadProgressBlock)
        {
            [self.af_imageRequestOperation setDownloadProgressBlock:downloadProgressBlock];
        }
        
        [[UIImageView af_sharedImageRequestOperationQueue] addOperation:self.af_imageRequestOperation];
    }
}


- (void)setImageWithURL:(NSURL*)url
       imageContentMode:(UIViewContentMode)_ImageContentMode
       placeholderImage:(UIImage *)placeholderImage
 placeholderContentMode:(UIViewContentMode)_PlaceholderContentMode
                success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    [self setImageWithURL:url
         imageContentMode:_ImageContentMode
         placeholderImage:placeholderImage
   placeholderContentMode:_PlaceholderContentMode
                  success:success
                  failure:failure
    downloadProgressBlock:nil];
}


- (void)setImageWithURL:(NSURL*)url
       imageContentMode:(UIViewContentMode)_ImageContentMode
       placeholderImage:(UIImage *)placeholderImage
 placeholderContentMode:(UIViewContentMode)_PlaceholderContentMode
{
    [self setImageWithURL:url
         imageContentMode:_ImageContentMode
         placeholderImage:placeholderImage
   placeholderContentMode:_PlaceholderContentMode
                  success:nil
                  failure:nil
    downloadProgressBlock:nil];
}

@end
