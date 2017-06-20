//
//  Pet.m
//  objc2less3
//
//  Created by Лыков on 07.02.17.
//  Copyright © 2017 Lykov. All rights reserved.
//

#import "Toy.h"

@implementation Toy

-(instancetype) initWithName: (NSString*) name andimageURL:(NSURL*) imageURL andImage:(UIImage*) image{
    if(self = [super init]){
        _name = name;
        _image = image;
        _imageURL = imageURL;
    }
    
    return self;
}

+(instancetype) initWithName:(NSString*) name andImage:(UIImage*) image{
    return [[Toy alloc] initWithName: name
                         andimageURL: nil
                            andImage: image];
}

+(instancetype) initWithName:(NSString*) name andImageURL:(NSURL*) imageURL{
    return [[Toy alloc] initWithName: name
                         andimageURL: imageURL
                            andImage: nil];
}

+(instancetype) initWithDataModel: (ToyModel*) toyModel{
    
    NSURL* url = [NSURL URLWithString: toyModel.imageURL];
    return [[Toy alloc] initWithName: toyModel.name
                         andimageURL: url
                            andImage: nil];
}

+(instancetype) createNewToy{
    Toy* newToy = [Toy new];
    switch (arc4random()%10) {
        case 0:
            newToy.name = @"Bucket";
            break;
        case 1:
            newToy.name = @"Ball";
            break;
        case 2:
            newToy.name = @"Bear";
            break;
        case 3:
            newToy.name = @"Tree";
            break;
        case 4:
            newToy.name = @"Snowman";
            break;
        case 5:
            newToy.name = @"Fir";
            break;
        case 6:
            newToy.name = @"Balloon";
            break;
        case 7:
            newToy.name = @"Pyramid";
            break;
        case 8:
            newToy.name = @"Tumbler";
            break;
        case 9:
            newToy.name = @"Mushroom";
            break;
        default:
            newToy.name = @"Ball";
            break;
    }
    newToy.image = [UIImage imageNamed: newToy.name];
    
    newToy.imageURL = [NSURL URLWithString: newToy.name];
    
    //    NSBundle* b = [[NSBundle mainBundle].infoDictionary objectForKey:@"com.myapp.projectdir"];
    //
    //    newToy.imageURL = [NSURL URLWithString:[NSString stringWithFormat: @"%@/objc2less6/Assets.xcassets/%@.imageset/%@.png",(NSString*)b,newToy.name,newToy.name]];
    
    return newToy;
}


@end
