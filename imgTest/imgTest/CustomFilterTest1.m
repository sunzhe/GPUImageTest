//
//  CustomFilterTest1.m
//  imgTest
//
//  Created by admin on 2017/2/8.
//  Copyright © 2017年 Huaimayi. All rights reserved.
//

#import "CustomFilterTest1.h"

#import "GPUImage.h"

NSString *const kCustomFilterTest1String = SHADER_STRING
(
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 void main()
 {
     
     lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     lowp vec4 outputColor;
     outputColor.r = (textureColor.r * 0.393) + (textureColor.g * 0.769) + (textureColor.b * 0.189);
     outputColor.g = (textureColor.r * 0.349) + (textureColor.g * 0.686) + (textureColor.b * 0.168);
     outputColor.b = (textureColor.r * 0.872) + (textureColor.g * 0.534) + (textureColor.b * 0.131);
     outputColor.a = 1.0;
     
     gl_FragColor = outputColor;
 }
 );

@implementation CustomFilterTest1

- (id)init
{
    if (!(self = [super init]))
    {
        return nil;
    }
    //GPUImageThreeInputFilter *filter = [[GPUImageThreeInputFilter alloc] initWithFragmentShaderFromString:kCustomFilterTest1String];
    GPUImageFilter *filter = [[GPUImageFilter alloc] initWithFragmentShaderFromString:kCustomFilterTest1String];
    
    GPUImageCrosshatchFilter *filter1 = [[GPUImageCrosshatchFilter alloc] init];
    //[filter1 addTarget:filter atTextureLocation:1];
    
    GPUImageVignetteFilter *filter2 = [[GPUImageVignetteFilter alloc] init];
    //[filter2 addTarget:filter atTextureLocation:2];
    
    [self addGPUImageFilters:@[filter1,filter, filter2]];
    return self;
}

- (void)addGPUImageFilters:(NSArray *)imageFilters
{
    GPUImageFilterGroup *_filterGroup = self;
    NSInteger count = imageFilters.count;
    if (count == 0)
    {
        return;
    }
    if (count == 1)
    {
        _filterGroup.initialFilters = imageFilters;
        _filterGroup.terminalFilter = imageFilters.firstObject;
    } else
    {
        GPUImageOutput<GPUImageInput> *lastFilter = nil;
        for (int i = 0; i < count; i++)
        {
            GPUImageOutput<GPUImageInput> *filter = imageFilters[i];
            [_filterGroup addFilter:filter];
            if (lastFilter){
                [lastFilter addTarget:filter];
            }
            lastFilter = filter;
        }
        _filterGroup.initialFilters = @[imageFilters.firstObject];
        _filterGroup.terminalFilter = lastFilter;
    }
}

@end
