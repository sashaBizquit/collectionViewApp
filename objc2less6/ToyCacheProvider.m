//
//  ToyCacheProvider.m
//  objc2less6
//
//  Created by Лыков on 19.02.17.
//  Copyright © 2017 Lykov. All rights reserved.
//

#import "ToyCacheProvider.h"

@interface ToyCacheProvider()

@property (nonatomic, strong) NSPersistentContainer* dbContainer;
@property (nonatomic, strong) NSURLSession * session;

@end

@implementation ToyCacheProvider

static NSString * const modelName = @"ToyModel";


-(instancetype) init {
    if(self = [super init]) {
        
        NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPMaximumConnectionsPerHost = 10;
        self.session = [NSURLSession sessionWithConfiguration: configuration];
        _dbContainer = [NSPersistentContainer persistentContainerWithName: modelName];
        [_dbContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *psd, NSError *error) {
            if(error) {
                NSLog(@"%@", error);
            }
        }];
    }
    return self;
}

#pragma mark - NSPersistentContainer

-(void) saveContext {
    NSError* error = nil;
    [_dbContainer.viewContext save: &error];
    
    if(error) {
        NSLog(@"Cant save context: %@", error);
    }
}

-(void) saveToy: (Toy *) toy {
    
    ToyModel* toyModel = [[ToyModel alloc] initWithContext: _dbContainer.viewContext];
    [toyModel setName: toy.name];
    [toyModel setImageURL: toy.imageURL.absoluteString];
    [_dbContainer.viewContext insertObject: toyModel];
    
    [self saveContext];

}

-(void) saveToys: (NSArray*) toys {
    
    [self clearStorage];
    
    for(Toy* toy in toys) {
        ToyModel* toyModel = [[ToyModel alloc] initWithContext: _dbContainer.viewContext];
        [toyModel setName: toy.name];
        [toyModel setImageURL: toy.imageURL.absoluteString];
        [_dbContainer.viewContext insertObject: toyModel];
    }
    
    [self saveContext];
    
}

-(void) clearStorage {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName: modelName];
    NSError* error = nil;
    
    NSArray* result = [_dbContainer.viewContext executeFetchRequest: request error: &error];
    
    NSUInteger lenth = result.count;
    
    if (!lenth) {
        return;
    }
    
    for (ToyModel* toyModel in result) {
        [_dbContainer.viewContext deleteObject: toyModel];
    }
    
    [_dbContainer.viewContext save: &error];
}

#pragma mark - <ToyProviderProtocol>

-(NSArray*) getToyArray {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName: modelName];
    NSError* error = nil;
    
    NSArray* result = [_dbContainer.viewContext executeFetchRequest: request error: &error];
    
    if(error) {
        NSLog(@"Getting data from storage error: %@", error);
    }
    
    NSMutableArray* toyArray = [NSMutableArray new];
    for (ToyModel* toyModel in result) {
        Toy* temp = [Toy initWithDataModel: toyModel];
        [toyArray addObject: temp];
    }
    
    return toyArray.copy;
}

-(void) getImageWith: (NSURL *) url andIndex: (NSUInteger) index {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex: 0];
    NSString *name = [NSString stringWithFormat: @"%@", url.absoluteString];
    NSString *filePath = [documentsPath stringByAppendingPathComponent: name];
    
    NSData* data = [NSData dataWithContentsOfFile: filePath];
    UIImage* image = [UIImage imageWithData: data];
    
    [self.delegate requestDidCompleteToyImage: @[image] withIndex: index];
}

-(void) setDelegate: (id<ToyProviderDelegate>) delegate {
    _delegate = delegate;
}

@end
