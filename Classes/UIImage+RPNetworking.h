//
//  UIImage+RPNetworking.h
//  Dealabs
//
//  Created by Raphaël Pinto on 03/08/2015.
//  Copyright (c) 2015 HUME Network. All rights reserved.
//


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



#import <UIKit/UIKit.h>
#import "AFNetworking.h"



@interface UIImageView (RPNetworking)



@property UIViewContentMode imageContentMode;
@property UIViewContentMode placeholderImageContentMode;
@property (readwrite, nonatomic, strong, setter = af_setImageRequestOperation:) AFHTTPRequestOperation *af_imageRequestOperation;



- (void)setImageWithURL:(NSURL *)url
       imageContentMode:(UIViewContentMode)_ImageContentMode
       placeholderImage:(UIImage *)placeholderImage
 placeholderContentMode:(UIViewContentMode)_PlaceholderContentMode
                success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
  downloadProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))downloadProgressBlock;


- (void)setImageWithURL:(NSURL*)url
       imageContentMode:(UIViewContentMode)_ImageContentMode
       placeholderImage:(UIImage *)placeholderImage
 placeholderContentMode:(UIViewContentMode)_PlaceholderContentMode
                success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;


- (void)setImageWithURL:(NSURL*)url
       imageContentMode:(UIViewContentMode)_ImageContentMode
       placeholderImage:(UIImage *)placeholderImage
 placeholderContentMode:(UIViewContentMode)_PlaceholderContentMode;


+ (NSOperationQueue *)af_sharedImageRequestOperationQueue;

@end
