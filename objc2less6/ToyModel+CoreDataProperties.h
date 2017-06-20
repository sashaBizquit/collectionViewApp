//
//  ToyModel+CoreDataProperties.h
//  objc2less6
//
//  Created by Лыков on 03.03.17.
//  Copyright © 2017 Lykov. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "ToyModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ToyModel (CoreDataProperties)

+ (NSFetchRequest<ToyModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *imageURL;
@property (nullable, nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
