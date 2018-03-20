//
//  MRFiniteStateMachine.m
//  MRFiniteStateMachine
//
//  Created by Federico Gasperini on 20/09/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "MRFiniteStateMachine.h"
#import "MRFSMState.h"

@interface MRFiniteStateMachine<__covariant StateType, __covariant InputType, __covariant OutputType> ()

@property (copy, nonatomic, nonnull) TransitionFunction transitionFunction;
@property (copy, nonatomic, nonnull) OutputFunction outputFunction;

@property (nonatomic) NSMutableSet<MRFSMState*>* states;

@property (strong, nonatomic, nullable) MRFSMState* initialStateWrapper;
@property (strong, nonatomic, nullable) MRFSMState* lastStateWrapper;
@property (strong, nonatomic, nullable) MRFSMState* currentStateWrapper;

@property (strong, nullable) OutputType lastOutput;

@end

@implementation MRFiniteStateMachine

+(instancetype)stateWithTransition:(TransitionFunction)tBlock
                         andOutput:(OutputFunction)oBlock
{
    MRFiniteStateMachine* state = [[self alloc] initWithTransition:tBlock
                                                         andOutput:oBlock];
    return state;
}

-(instancetype)initWithTransition:(TransitionFunction)tBlock
                        andOutput:(OutputFunction)oBlock
{
    self = [super init];
    if (self)
    {
        self.transitionFunction = tBlock;
        self.outputFunction = oBlock;
        self.states = [[NSMutableSet alloc] init];
    }
    return self;
}

-(BOOL)processInput:(id)i
{
    if (!self.currentStateWrapper.isFinalState)
    {
        id nextState = self.transitionFunction(self.currentStateWrapper.internalState, i, [self.states valueForKey:@"internalState"]);
        MRFSMState* state = [self.states member:nextState];
        if (state)
        {
            self.lastOutput = self.outputFunction(self.currentStateWrapper.internalState, i);
            self.currentStateWrapper = state;
            return YES;
        }
    }
    return NO;
}

-(void)addInitialState:(id)object
{
    if (self.initialState == nil)
        self.initialState = object;
}

-(void)setInitialState:(id)initialState
{
    self.currentStateWrapper = nil;
    MRFSMState* state = [MRFSMState stateWithObject:initialState];
    self.currentStateWrapper = state;
    self->_initialStateWrapper = state;
    [self.states addObject:state];
}

-(void)addState:(id)state
{
    MRFSMState* wstate = [MRFSMState stateWithObject:state];
    [self.states addObject:wstate];
}

-(void)addFinalState:(id)state
{
    MRFSMState* wstate = [MRFSMState finalStateWithObject:state];
    [self.states addObject:wstate];
}

-(void)setCurrentStateWrapper:(MRFSMState *)currentStateWrapper
{
    self.lastStateWrapper = self->_currentStateWrapper;
    self->_currentStateWrapper = currentStateWrapper;
}

-(void)reset
{
    self.currentStateWrapper = nil;
    self.lastOutput = nil;
    self.currentStateWrapper = self.initialStateWrapper;
}

-(void)clear
{
    self.currentStateWrapper = nil;
    self.lastStateWrapper = nil;
    self.lastOutput = nil;
    self.initialStateWrapper = nil;
    [self.states removeAllObjects];
}

-(id)currentState
{
    return self.currentStateWrapper.internalState;
}

-(id)initialState
{
    return self.initialStateWrapper.internalState;
}

-(id)lastState
{
    return self.lastStateWrapper.internalState;
}

-(NSUInteger)stateCount
{
    return self.states.count;
}

-(BOOL)isFinalState
{
    return self.currentStateWrapper.isFinalState;
}

@end
