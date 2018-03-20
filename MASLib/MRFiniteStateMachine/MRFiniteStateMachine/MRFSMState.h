//
//  MRFSMState.h
//  MRFiniteStateMachine
//
//  Created by Federico Gasperini on 20/09/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MRFSMState<__covariant ObjectType> : NSObject

-(instancetype)init NS_UNAVAILABLE;

-(instancetype)initFinal:(BOOL)finalState withObject:(ObjectType)obj NS_DESIGNATED_INITIALIZER;
-(instancetype)initWithObject:(ObjectType)obj;
+(instancetype)stateWithObject:(ObjectType)obj;
+(instancetype)finalStateWithObject:(id)obj;

@property (readonly, nonnull) ObjectType internalState;
@property (readonly, getter=isFinalState) BOOL finalState;

@end

NS_ASSUME_NONNULL_END
