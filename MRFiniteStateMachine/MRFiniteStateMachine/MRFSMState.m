//
//  MRFSMState.m
//  MRFiniteStateMachine
//
//  Created by Federico Gasperini on 20/09/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "MRFSMState.h"

@interface MRFSMState ()

@end

@implementation MRFSMState

-(instancetype)initWithObject:(id)obj
{
    self = [self initFinal:NO withObject:obj];
    return self;
}

-(instancetype)initFinal:(BOOL)finalState withObject:(id)obj
{
    self = [super init];
    if (self)
    {
        self->_internalState = obj;
        self->_finalState = finalState;
    }
    return self;
}

+(instancetype)stateWithObject:(id)obj
{
    return [[self alloc] initFinal:NO withObject:obj];
}

+(instancetype)finalStateWithObject:(id)obj
{
    return [[self alloc] initFinal:YES withObject:obj];
}

-(NSUInteger)hash
{
    return [self.internalState hash];
}

-(BOOL)isEqual:(id)object
{
    if (self == object)
        return YES;

    if ([object isKindOfClass:MRFSMState.class])
        return [self.internalState isEqual:[object internalState]];
    
    return [self.internalState isEqual:object];
}

@end
