//
//  PetProvider.m
//  objc2less3
//
//  Created by Лыков on 07.02.17.
//  Copyright © 2017 Lykov. All rights reserved.
//

#import "ToyProvider.h"

@interface ToyProvider() <ToyProviderProtocol>

@property (strong) ToyWebProvider *toyWebProvider;
@property (strong) ToyCacheProvider *toyCacheProvider;

@end

@implementation ToyProvider

-(instancetype) init {
    if(self = [super init]) {
        _toyCacheProvider = [ToyCacheProvider new];
        _toyWebProvider  = [ToyWebProvider new];
    }
    return self;
}

-(void) initRequest {
        NSMutableArray* cacheArr = [[NSMutableArray alloc] initWithArray: _toyCacheProvider.getToyArray];
        if(cacheArr.count) {
            
            [self requestWithProvider: _toyCacheProvider andArray: cacheArr];
        }
        else {
            [self refresh];
        }
}

-(void) refresh{
    
    NSMutableArray* webArr = [[NSMutableArray alloc] initWithArray: _toyWebProvider.getToyArray];
    [self requestWithProvider: _toyWebProvider andArray: webArr];
}

-(void) saveToy:(Toy *)toy {
    [_toyCacheProvider saveToy: toy];
}

-(void) requestWithProvider: (id<ToyProviderProtocol>) someProvider andArray: (NSMutableArray*) arr {
    
    NSMutableArray* toyArr = arr;
    
    [someProvider.delegate requestDidCompleteToyNames: toyArr.copy];
    
    for( NSUInteger i = 0 ; i < toyArr.count ; i++ ) {
        Toy* toy = [toyArr objectAtIndex: i];
        [someProvider getImageWith: toy.imageURL andIndex: i];
    }
}

#pragma mark - <ToyProviderProtocol>

-(void) setDelegate: (id<ToyProviderDelegate>) delegate {
    _delegate = delegate;
    [_toyWebProvider setDelegate: delegate];
    [_toyCacheProvider setDelegate: delegate];
}

-(NSArray*) getToyArray {
    NSMutableArray* toyArray = [NSMutableArray new];
    int count = 100;
    for(int i = 0; i < count; i++) {
        Toy* toyListElem = [Toy createNewToy];
        [toyArray addObject: toyListElem];
    }
    return toyArray.copy;
}

-(UIImage*) getImageWithToy: (Toy*) toy {
    
    NSData *imageData = [NSData dataWithContentsOfURL: toy.imageURL];
    UIImage* image = [UIImage imageWithData: imageData];
    return image;
}

-(void) getImageWith:(NSURL *)url andIndex:(NSUInteger)index {
    
    UIImage* image = [UIImage imageNamed: url.absoluteString];
    [self.delegate requestDidCompleteToyImage: @[image] withIndex: index];
}

-(NSURL*) getImageURL:  (Toy*) toy{
    return toy.imageURL;
}

@end
