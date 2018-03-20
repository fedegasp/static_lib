//
//  MRFiniteStateMachine.h
//  MRFiniteStateMachine
//
//  Created by Federico Gasperini on 20/09/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MRFiniteStateMachine<__covariant StateType, __covariant InputType, __covariant OutputType> : NSObject

typedef StateType _Nullable(^_Nonnull TransitionFunction)(StateType _Nonnull s, InputType _Nonnull i, NSSet<StateType>* _Nonnull S);
typedef OutputType _Nullable(^_Nonnull OutputFunction)(StateType _Nonnull s, InputType _Nonnull i);

-(instancetype _Nonnull)init NS_UNAVAILABLE;

-(instancetype _Nonnull)initWithTransition:(TransitionFunction)tBlock
andOutput:(OutputFunction)oBlock NS_DESIGNATED_INITIALIZER;

+(instancetype _Nonnull)stateWithTransition:(TransitionFunction)tBlock
andOutput:(OutputFunction)oBlock;

-(void)reset;
-(void)clear;

-(void)addInitialState:(StateType)state;
-(void)addState:(StateType)state;
-(void)addFinalState:(StateType)state;

@property (readonly, nonatomic, nullable) StateType initialState;
@property (readonly, nonatomic, nullable) StateType lastState;
@property (readonly, nonatomic, nullable) StateType currentState;

@property (readonly, nonatomic, nullable) StateType lastOutput;

@property (readonly, nonatomic) NSUInteger stateCount;

@property (readonly, nonatomic, getter=isFinalState) BOOL finalState;

-(BOOL)processInput:(InputType)i;

@end

NS_ASSUME_NONNULL_END
