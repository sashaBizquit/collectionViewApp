//
//  Pet.h
//  objc2less3
//
//  Created by Лыков on 07.02.17.
//  Copyright © 2017 Lykov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ToyModel+CoreDataProperties.h"

@interface Toy : NSObject

@property (strong) NSString* name;
@property (strong) UIImage* image;
@property (strong) NSURL* imageURL;

+(instancetype) initWithName: (NSString*) name andImage: (UIImage*) image;
+(instancetype) initWithName: (NSString*) name andImageURL: (NSURL*) imageURL;
+(instancetype) initWithDataModel: (ToyModel*) toyModel;

+(instancetype) createNewToy;

@end

#pragma mark - Protocols

@protocol ToyProviderDelegate <NSObject>

-(void) requestDidCompleteToyNames: (NSArray*) names;
-(void) requestDidCompleteToyImage: (NSArray*) image withIndex: (NSUInteger) index;

@end

@protocol ToyProviderProtocol <NSObject>

@property (nonatomic,weak) id <ToyProviderDelegate> delegate;

-(void) setDelegate: (id<ToyProviderDelegate>)delegate;
-(NSArray*) getToyArray;
-(void) getImageWith: (NSURL*) url andIndex: (NSUInteger) index;

@end
