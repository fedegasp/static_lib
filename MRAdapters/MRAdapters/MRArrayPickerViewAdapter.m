//
//  MRArrayPickerViewAdapter.m
//  IK
//
//  Created by Federico Gasperini on 02/03/15.
//  Copyright (c) 2015 Federico Gasperini. All rights reserved.
//

#import "MRArrayPickerViewAdapter.h"
#import <MRBase/lib.h>
#import <MRTableView/lib.h>
#import <objc/runtime.h>
#import <objc/message.h>

static void* ob_selection_context = &ob_selection_context;

@interface MRArrayPickerViewAdapter ()

@property (readonly) id selection;

@property (readonly) NSArray* titles;

-(void)setup;
-(void)notifyDelegateForSelection;

@end

@implementation MRArrayPickerViewAdapter
{
    BOOL arrayOfArray;
    BOOL sendDidSelect;
    BOOL sendDidSelectRowInComponent;
    BOOL sendTitleForRow;
}

#pragma mark - Init

-(instancetype)init
{
    self = [super init];
    if (self)
        [self setup];
    return self;
}

-(void)setup
{
   [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(keyboardOpened:)
                                                name:UIKeyboardDidShowNotification
                                              object:nil];
   dispatch_async(dispatch_get_main_queue(), ^{
      [self addObserver:self
             forKeyPath:@"selection"
                options:0
                context:ob_selection_context];
   });
}

#pragma mark - Notify initial state

-(void)keyboardOpened:(NSNotification*)notification
{
    [self eventuallyFillFirstResponder];
}

+(NSSet*)keyPathsForValuesAffectingSelection
{
    static NSSet* set = nil;
    if (set)
        return set;
    
    set = [NSSet setWithArray:@[@"pickerView", @"data", @"adapterDelegate"]];
    return set;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context != ob_selection_context)
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    else
    {
        _titles = nil;
        [self buildTitles];
        [self.pickerView reloadAllComponents];
        [self notifyDelegateForSelection];
    }
}

-(void)notifyDelegateForSelection
{
    if (self.pickerView && self.adapterDelegate && self.data)
    {
        if (sendDidSelect || sendDidSelectRowInComponent)
        {
            NSMutableArray* selection = sendDidSelect ? [[NSMutableArray alloc] init] : nil;
            
            for (NSInteger i = 0; i < [self numberOfComponentsInPickerView:self.pickerView]; i++)
            {
                NSInteger idx = [self.pickerView selectedRowInComponent:i];
                if (sendDidSelectRowInComponent)
                    [self.adapterDelegate pickerView:self.pickerView
                                        didSelectRow:idx
                                         inComponent:i];
                
                if (sendDidSelect)
                {
                    if (self.data.count > 0) {
                        id obj = nil;
                        if (arrayOfArray)
                            obj = self.data[i][idx];
                        else
                            obj = self.data[idx];
                        [selection addObject:obj];
                    }
                }
            }
            if (sendDidSelect)
                [self.adapterDelegate pickerView:self.pickerView didSelect:selection];
        }
    }
}

-(void)setInitialValues:(NSArray*)value
{
    for (NSInteger i = 0; i < value.count; i++)
    {
        NSUInteger index = [self indexForTitle:value[i] inComponent:i];
        if (index != NSNotFound)
            [self.pickerView selectRow:index inComponent:i animated:NO];
    }
}

-(NSUInteger)indexForTitle:(id)value inComponent:(NSInteger)component
{
    if (self.titles.count > component)
        return [self.titles[component] indexOfObject:value];
    return NSNotFound;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _pickerView.delegate = nil;
    _pickerView.dataSource = nil;
    _pickerView = nil;
    [self removeObserver:self
              forKeyPath:@"selection"];
}

#pragma mark - Properties

-(NSArray*)selection
{
    NSMutableArray* selection = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [self numberOfComponentsInPickerView:self.pickerView]; i++)
    {
        NSInteger idx = [self.pickerView selectedRowInComponent:i];
        id obj = nil;
        if (arrayOfArray)
            obj = self.data[i][idx];
        else
            obj = self.data[idx];
        [selection addObject:obj];
    }
    return selection;
}

-(void)setPlistSource:(NSString *)plistSource
{
    _plistSource = plistSource;
    if (_plistSource)
        self.data = [NSMutableArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:self.plistSource
                                                                                   withExtension:@"plist"]];
    else
        self.data = nil;
}

-(void)setData:(NSMutableArray *)data
{
    _data = data;
    arrayOfArray = self.data.isMultiDimensional;
    [self buildTitles];
}

-(void)setDataString:(NSString *)dataString
{
    _dataString = dataString;
    [self setData:[[dataString componentsSeparatedByString:@";"] mutableCopy]];
}

-(void)buildTitles
{
    if (self.data)
    {
        NSArray* data = self.data;
        if (!arrayOfArray)
            data = @[data];
        NSMutableArray* titles = [[NSMutableArray alloc] init];
        for (NSInteger c = 0; c < data.count; c++)
        {
            NSArray* componentData = data[c];
            NSMutableArray* componentTitles = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < componentData.count; i++)
                [componentTitles addObject:[self pickerView:self.pickerView
                                                titleForRow:i
                                               forComponent:c]];
            [titles addObject:[componentTitles copy]];
        }
        _titles = [titles copy];
    }
}

-(void)setTitleBlock:(TitleBlock)titleBlock
{
    _titleBlock = titleBlock;
    _titles = nil;
    [self buildTitles];
    [self.pickerView reloadAllComponents];
}

-(void)setPickerView:(UIPickerView *)pickerView
{
    if (_pickerView != pickerView)
    {
        _pickerView.delegate = nil;
        _pickerView.dataSource = nil;
        _pickerView = pickerView;
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
}

-(void)setAdapterDelegate:(id<MRArrayPickerViewAdapterDelegate>)pickerViewDelegate
{
    _adapterDelegate = pickerViewDelegate;
    sendDidSelect = [_adapterDelegate respondsToSelector:@selector(pickerView:didSelect:)];
    sendDidSelectRowInComponent = [_adapterDelegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)];
    sendTitleForRow = [_adapterDelegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)];
}

#pragma mark - UIPikerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (arrayOfArray)
        return self.data.count;
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (arrayOfArray)
        return [self.data[component] count];
    return self.data.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.titles)
        return self.titles[component][row];
    
    if (sendTitleForRow)
        return [self.adapterDelegate pickerView:pickerView titleForRow:row forComponent:component];
    
    id obj = nil;
    if (arrayOfArray)
        obj = self.data[component][row];
    else
        obj = self.data[row];
    
    if (self.titleBlock)
        return self.titleBlock(obj, component);
    
    if ([obj respondsToSelector:@selector(pikerViewTitle)])
        return [obj pikerViewTitle];
    
    return [obj description];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.data.count > 0) {
        if (sendDidSelectRowInComponent)
            [self.adapterDelegate pickerView:pickerView didSelectRow:row inComponent:component];
        if (sendDidSelect)
            [self.adapterDelegate pickerView:pickerView didSelect:self.selection];
    }
    [self eventuallyFillFirstResponder];
}

-(void)eventuallyFillFirstResponder
{
    if (self.pickerView.numberOfComponents == 1)
    {
        NSString* value = [self pickerView:self.pickerView
                               titleForRow:[self.pickerView selectedRowInComponent:0]
                              forComponent:0];
        id firstResponder = [UIControl currentFirstResponder];
        if ([firstResponder inputView] == self.pickerView)
        {
            if ([firstResponder respondsToSelector:@selector(setText:)])
            {
                [firstResponder setText:value];
                [firstResponder sendActionsForControlEvents:UIControlEventValueChanged];
            }
            else if ([firstResponder respondsToSelector:@selector(setTitle:forState:)])
            {
                [firstResponder setTitle:value
                                forState:UIControlStateNormal];
                [firstResponder sendActionsForControlEvents:UIControlEventValueChanged];
            }
        }
    }
}

#pragma mark - UIPickerViewDelegate methods forwarding

-(BOOL)respondsToSelector:(SEL)aSelector
{
   if (sel_isEqual(aSelector, @selector(pickerView:titleForRow:forComponent:))
       ||
       sel_isEqual(aSelector, @selector(pickerView:didSelectRow:inComponent:)))
      return YES;
   
   struct objc_method_description hasMethod;
   hasMethod = protocol_getMethodDescription(@protocol(UIPickerViewDelegate), aSelector, NO, YES);
   if ( hasMethod.name != NULL )
      return [self.adapterDelegate respondsToSelector:aSelector];
   
   return [[self superclass] instanceMethodSignatureForSelector:aSelector] != nil;
}

-(NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector
{
    return [((NSObject*)self.adapterDelegate) methodSignatureForSelector:aSelector];
}

-(id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.adapterDelegate;
}

@end


@implementation NSNumber (pikerViewTitle)

-(NSString*)pikerViewTitle
{
    return [self stringValue];
}

@end
