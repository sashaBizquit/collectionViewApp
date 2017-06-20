//
//  RootCVC.m
//  objc2less6
//
//  Created by Лыков on 16.02.17.
//  Copyright © 2017 Lykov. All rights reserved.
//

#import "RootCVC.h"

@interface RootCVC ()

@property (nonatomic,strong) NSMutableArray* toyArray;
@property (nonatomic,strong) ToyProvider* toyProvider;

@end

@implementation RootCVC

static NSString * const reuseIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _toyProvider = [ToyProvider new];
    [_toyProvider setDelegate: self];
    [_toyProvider initRequest];
    
}

- (IBAction)refresh:(id)sender {
    [_toyProvider refresh];
    
}

-(void) updateToyArrayWithCount:(NSUInteger) count {
    if (_toyArray == nil) {
        _toyArray = [NSMutableArray new];
    }
    else {
        [_toyArray removeAllObjects];
    }
    
    for ( NSUInteger i = 0 ; i < count; i++ ) {
        [_toyArray addObject: [Toy new]];
    }
}
#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _toyArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *) indexPath {
    ElementCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier: reuseIdentifier forIndexPath: indexPath];
    Toy* currentToy = _toyArray[indexPath.row];
    
    cell.image.image = (currentToy.image)? currentToy.image: [UIImage imageNamed: @"Loading"];
    cell.label.text = currentToy.name;
    
    return cell;
}

#pragma mark - <ToyProviderDelegate>

-(void) requestDidCompleteToyNames:(NSArray*) names {
    
    [self updateToyArrayWithCount:names.count];
    
    for( NSUInteger i = 0; i < _toyArray.count; i++) {
        Toy* currentToy = names[i];
        [_toyArray replaceObjectAtIndex: i withObject: [Toy initWithName: currentToy.name andImage: currentToy.image]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    
}

-(void) requestDidCompleteToyImage:(NSArray*) image withIndex:(NSUInteger) index {
    Toy* currentToy = _toyArray[index];
    
    NSData *pngData = UIImagePNGRepresentation(image.firstObject);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex: 0];
    NSString *name = [NSString stringWithFormat: @"%@.png", currentToy.name];
    NSString *filePath = [documentsPath stringByAppendingPathComponent: name];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath: filePath]) {
        [pngData writeToFile: filePath atomically: YES];
    }
    Toy* tempToy = [Toy initWithName: currentToy.name andImage: [image firstObject]];
    tempToy.imageURL = [NSURL URLWithString: name];
    
    [_toyArray replaceObjectsAtIndexes: [NSIndexSet indexSetWithIndex: index] withObjects: @[tempToy]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow: index inSection: 0];
        [self.collectionView reloadItemsAtIndexPaths: @[indexPath]];
        
    });    
    [self.toyProvider saveToy: tempToy];
}

@end
