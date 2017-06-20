//
//  PetProvider.h
//  objc2less3
//
//  Created by Лыков on 07.02.17.
//  Copyright © 2017 Lykov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Toy.h"
#import "ToyWebProvider.h"
#import "ToyCacheProvider.h"

@interface ToyProvider : NSObject <ToyProviderProtocol>

@property (nonatomic,weak) id <ToyProviderDelegate> delegate;

-(void) initRequest;
-(void) refresh;
-(void) saveToy: (Toy*) toy;

@end
