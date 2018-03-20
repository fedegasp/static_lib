//
//  MRViewModel.m
//  MRComponents
//
//  Created by Enrico Cupellini on 15/09/2017.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "MRViewModel.h"
#import <SDWebImage/lib.h>

@implementation MRViewModel

+(NSMutableDictionary*)getModelWithIdentifier:(NSString*)identifier tag:(NSInteger)tag andObject:(id)obj
{
    NSMutableDictionary* viewModel = @{}.mutableCopy;
    [viewModel setValue:identifier forKey:@"cellIdentifier"];
    [viewModel setValue:@(tag) forKey:@"tag"];
    [viewModel setValue:obj forKey:@"obj"];
    return viewModel;
}

+(NSMutableDictionary*)getModelWithIdentifier:(NSString *)identifier tag:(NSInteger)tag
{
    NSMutableDictionary* viewModel = @{}.mutableCopy;
    [viewModel setValue:identifier forKey:@"cellIdentifier"];
    [viewModel setValue:@(tag) forKey:@"tag"];
    
    return viewModel;
}

+(void)setLabelModel:(NSMutableDictionary *)viewModel withTextArray:(NSArray<id> *)textArray
{
    if (textArray)
        [viewModel setValue:textArray forKey:@"labelArray"];
}

+(void)setImageModel:(NSMutableDictionary *)viewModel withImageArray:(NSArray<id> *)imageArray placeHolder:(NSString *)placeHolder
{
    if (imageArray)
        [viewModel setValue:imageArray forKey:@"imageViewArray"];
    if (placeHolder) {
        [viewModel setValue:placeHolder forKey:@"imageViewPlaceHolder"];
    }
}

+(void)setTextFieldModel:(NSMutableDictionary *)viewModel withTextArray:(NSArray<NSString *> *)textArray placeholder:(NSArray<NSString *> *)placeholder enabled:(NSArray<NSNumber *> *)enabled
{
    if (textArray)
        [viewModel setValue:textArray forKey:@"textFieldArray"];
    if (placeholder) {
        [viewModel setValue:placeholder forKey:@"textFieldPlaceholder"];
    }
    [viewModel setValue:enabled forKey:@"enabled"];
}

+(void)setTextViewModel:(NSMutableDictionary *)viewModel withTextArray:(NSArray<NSString *> *)textArray placeholder:(NSArray<NSString *> *)placeholder
{
    if (textArray)
        [viewModel setValue:textArray forKey:@"textViewArray"];
    if (placeholder) {
        [viewModel setValue:placeholder forKey:@"textViewPlaceHolder"];
    }
}

+(void)setViewModels:(NSMutableDictionary*)viewModel withColorArray:(NSArray<UIColor*>*)colorArray{
    if (colorArray)
        [viewModel setValue:colorArray forKey:@"colorArray"];
}

+(void)setWebViewModel:(NSMutableDictionary *)viewModel withUrlArray:(NSArray<NSURL *> *)urlArray{
    if (urlArray)
        [viewModel setValue:urlArray forKey:@"webViewUrl"];
}

+(void)setButtonModel:(NSMutableDictionary *)viewModel buttonEnabled:(NSArray<NSNumber *> *)buttonEnabled buttonHidden:(NSArray<NSNumber *> *)buttonHidden{

    if (buttonEnabled) {
        [viewModel setValue:buttonEnabled forKey:@"buttonEnabled"];
    }
    if (buttonHidden) {
        [viewModel setValue:buttonHidden forKey:@"buttonHidden"];
    }
}

+(void)setViewModels:(NSMutableDictionary*)viewModel withCustomValue:(NSObject*)v forKey:(NSString*)k;
{
    if (v && k)
        viewModel[k] = v;
    else if (k)
        [viewModel removeObjectForKey:k];
}

-(void)setContent:(id)content
{
    
    for (int i = 0 ; i < [content[@"labelArray"] count] ; i++) {
        id labelText = content[@"labelArray"][i];
        if ([labelText isKindOfClass:[NSString class]]) {
            [self.label[i] setText:labelText];
        }
        else if ([labelText isKindOfClass:[NSAttributedString class]])
        {
            [self.label[i] setAttributedText:labelText];
        }
    }
    
    for (int i = 0 ; i < [content[@"imageViewArray"] count] ; i++) {
        id imageString = content[@"imageViewArray"][i];
        
        if ([imageString isKindOfClass:[NSString class]]) {
            [self.image[i] setImage:[UIImage imageNamed:imageString]];
        }
        else if ([imageString isKindOfClass:[NSURL class]])
        {
            [self.image[i] setImageWithURL:imageString placeholderImage:[UIImage imageNamed:content[@"imageViewPlaceHolder"][i]]];
        }
    }
    
    for (int i = 0; i < [content[@"textFieldArray"] count]; i++) {
        [self.textField[i] setText:content[@"textFieldArray"][i]];
        [self.textField[i] setPlaceholder:content[@"textViewPlaceHolder"][i]];
        [self.textField[i] setEnabled:[content[@"enabled"]boolValue]];
    }
    
    for (int i = 0; i < [content[@"textViewArray"] count]; i++) {
        [self.textView[i] setText:content[@"textViewArray"][i]];
        if ([self.textView respondsToSelector:@selector(setPlaceholder:)]) {
            [self.textView[i] setPlaceholder:content[@"textViewPlaceHolder"][i]];
        }
    }
    
    for (int i = 0; i < [content[@"webViewUrl"] count]; i++) {
        [self.webView[i] loadRequest:[NSURLRequest requestWithURL:content[@"webViewUrl"][i]]];
    }
    
    for (int i = 0; i < [content[@"buttonEnabled"] count]; i++) {
        [self.button[i] setEnabled:content[@"buttonEnabled"][i]];
        [self.button[i] setHidden:content[@"buttonHidden"][i]];
    }
    
    for (int i = 0; i < [content[@"colorArray"] count]; i++) {
        [(UIView*)self.view[i] setBackgroundColor:content[@"colorArray"][i]];
    }
    
    self.tag = [content[@"tag"] integerValue];
}
             
             
             
-(void)setLabel:(NSArray *)label
{
    _label = [label sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES]]];
}

-(void)setImage:(NSArray *)image
{
    _image = [image sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES]]];
}

-(void)setTextField:(NSArray *)textField
{
    _textField = [textField sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES]]];
}

-(void)setTextView:(NSArray *)textView
{
    _textView = [textView sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES]]];
}

-(void)setWebView:(NSArray *)webView
{
    _webView = [webView sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES]]];
}

-(void)setButton:(NSArray *)button
{
    _button = [button sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES]]];
}

-(void)setView:(NSArray *)view
{
    _view = [view sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES]]];
}

@end
