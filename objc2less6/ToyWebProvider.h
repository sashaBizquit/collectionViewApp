//
//  ToyWebProvider.h
//  objc2less6
//
//  Created by Лыков on 19.02.17.
//  Copyright © 2017 Lykov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToyProvider.h"

@interface ToyWebProvider : NSObject <ToyProviderProtocol>

@property (nonatomic,weak) id <ToyProviderDelegate> delegate;

@end
