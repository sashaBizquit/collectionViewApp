//
//  ToyWebProvider.m
//  objc2less6
//
//  Created by Лыков on 19.02.17.
//  Copyright © 2017 Lykov. All rights reserved.
//

#import "ToyWebProvider.h"

@interface ToyWebProvider()

@property (nonatomic, strong) NSURLSession * session;

@end

@implementation ToyWebProvider

static NSString * const rssString = @"https://raw.githubusercontent.com/sashaBizquit/objc2less1/master/toys.json";

- (instancetype) init {
    if(self = [super init]) {
        NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPMaximumConnectionsPerHost = 10;
        self.session = [NSURLSession sessionWithConfiguration: configuration];
    }
    return self;
}

#pragma mark - <ToyProviderProtocol>

- (void) setDelegate: (id<ToyProviderDelegate>) delegate {
    _delegate = delegate;
}

- (NSArray*) getToyArray {
    NSArray* toyArray = [[NSArray alloc] initWithArray: [self loadingSession]];
    
    NSMutableArray* tempArray = [NSMutableArray new];
    for(NSMutableDictionary* tempDict in toyArray){
        Toy* tempToy = [Toy initWithName: [tempDict objectForKey: @"name"]
                             andImageURL: [NSURL URLWithString: [tempDict objectForKey: @"url"]]
                        ];
        [tempArray addObject: tempToy];
    }
    return tempArray.copy;
}

- (void) getImageWith: (NSURL *) url andIndex: (NSUInteger) index {
    
    NSURLSessionDataTask * dataTask = [self.session dataTaskWithURL: url
                                                  completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
                                                      UIImage *image = [UIImage imageWithData: data];
                                                      [self.delegate requestDidCompleteToyImage: @[image] withIndex: index];
                                             }
                                       ];
    [dataTask resume];
}


#pragma mark - Connection Trigger Method

- (NSArray*) loadingSession {
    NSMutableArray* webToyArray = [NSMutableArray new];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    
    NSURL *url = [NSURL URLWithString: rssString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL: url
                                             completionHandler:^ (NSData *data, NSURLResponse *response, NSError *error) {
                                           NSMutableDictionary *dict  = [NSJSONSerialization JSONObjectWithData: data
                                                                                                        options: 0
                                                                                                          error: NULL];
                                           NSArray *toysList = dict[@"toys"];
                                           [webToyArray addObjectsFromArray: toysList];
                                           
                                           dispatch_group_leave(group);
                                       }];
    [dataTask resume];
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    return webToyArray.copy;
}

@end

