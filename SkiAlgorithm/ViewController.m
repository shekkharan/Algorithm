#import "ViewController.h"
#import "Area.h"
#import "Route.h"
#import "NSMutableArray+AddItems.h"
#import "FileReader.h"

@interface ViewController ()
{
    int gridCount;
    NSMutableArray *array;
    int highestLength;
    NSMutableArray *arrayDrops;
}
@property(nonatomic,strong) NSMutableArray *areaItems;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self parseData];
   // array = (NSMutableArray *)@[@[@4,@8,@7,@3],@[@2,@5,@9,@3],@[@6,@3,@2,@5],@[@4,@4,@1,@6]];
    highestLength = 0;
    gridCount = (int)[array count];
    NSLog(@"");
    [self initializeArrays];
    [self loadValues];
    Route *bestRoute = [self getTheBestRoute];
}

- (void)parseData
{
    array = [NSMutableArray array];
    NSString* filePath = @"Map";//file path...
    NSString* fileRoot = [[NSBundle mainBundle]
                          pathForResource:filePath ofType:@"txt"];
    FileReader * reader = [[FileReader alloc] initWithFilePath:fileRoot];
    NSString * line = nil;
    while ((line = [reader readLine])) {
        NSMutableArray *lineArray = (NSMutableArray *)[line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        for (int i = 0;i< [lineArray count];i++) {
            [lineArray replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:[(NSString *)[lineArray objectAtIndex:i] intValue]]];
        }
        [array addObject:lineArray];
    }
  
}

- (void)initializeArrays
{
    arrayDrops = [NSMutableArray array];
    self.areaItems = [NSMutableArray array];
    for (int i = 0; i < gridCount; i++) {
        
        NSMutableArray *rowArray = [NSMutableArray array];
        [rowArray addItemsWithCount:gridCount];
        [self.areaItems addObject:rowArray];
    }
    NSLog(@"");
}


#pragma mark - Implementation

- (void)loadValues
{
    for (int i = 0; i < gridCount; i++) {
        
        NSMutableArray *rowArray = [self.areaItems objectAtIndex:i];
        for(int j = 0;j < gridCount; j++)
        {
            Area *item = [[Area alloc]init];
            if (!([[rowArray objectAtIndex:j]isKindOfClass:[Area class]])){
                [item setRow:i Column:j andValue:[[array objectAtIndex:i]objectAtIndex:j]];
                item = [self addRightUpDownLeftForArea:item];
            }
            else
            {
                item = [[self.areaItems objectAtIndex:i]objectAtIndex:j];
                item = [self addRightUpDownLeftForArea:item];
            }
            [rowArray replaceObjectAtIndex:j withObject:item];
        }
            [self.areaItems replaceObjectAtIndex:i withObject:rowArray];
    }
}

- (Area *)addRightUpDownLeftForArea:(Area*)area
{
    if (area.row - 1 >= 0) {
        //up area
        if ([[array objectAtIndex:area.row]objectAtIndex:area.column] > [[array objectAtIndex:area.row - 1]objectAtIndex:area.column])
        {
            area.upArea = [[Area alloc]initWithRow:area.row - 1 Column:area.column andValue:[[array objectAtIndex:area.row - 1]objectAtIndex:area.column]];
            if (!([[[self.areaItems objectAtIndex:area.row - 1]objectAtIndex:area.column]isKindOfClass:[Area class]])){
                [[self.areaItems objectAtIndex:area.row - 1] replaceObjectAtIndex:area.column withObject:area.upArea ];
            }
        }
    }
    if (area.column + 1 < gridCount) {
        //right area
        if ([[array objectAtIndex:area.row]objectAtIndex:area.column] > [[array objectAtIndex:area.row]objectAtIndex:area.column + 1])
        {
            area.rightArea = [[Area alloc]initWithRow:area.row Column:area.column + 1 andValue:[[array objectAtIndex:area.row]objectAtIndex:area.column + 1]];
            if (!([[[self.areaItems objectAtIndex:area.row]objectAtIndex:area.column + 1]isKindOfClass:[Area class]])){
                [[self.areaItems objectAtIndex:area.row] replaceObjectAtIndex:area.column + 1 withObject:area.rightArea ];
            }
        }
    }
    
    if (area.row + 1 < gridCount) {
        //down area
        if ([[array objectAtIndex:area.row]objectAtIndex:area.column] > [[array objectAtIndex:area.row + 1]objectAtIndex:area.column])
        {
            area.downArea = [[Area alloc]initWithRow:area.row + 1 Column:area.column andValue:[[array objectAtIndex:area.row + 1]objectAtIndex:area.column]];
            if (!([[[self.areaItems objectAtIndex:area.row + 1]objectAtIndex:area.column]isKindOfClass:[Area class]])){
                [[self.areaItems objectAtIndex:area.row + 1] replaceObjectAtIndex:area.column withObject:area.downArea ];
            }
        }
    }
    
    if (area.column - 1 >= 0) {
        //left area
        if ([[array objectAtIndex:area.row]objectAtIndex:area.column] > [[array objectAtIndex:area.row]objectAtIndex:area.column - 1])
        {
            area.leftArea = [[Area alloc]initWithRow:area.row Column:area.column - 1 andValue:[[array objectAtIndex:area.row]objectAtIndex:area.column - 1]];
            if (!([[[self.areaItems objectAtIndex:area.row]objectAtIndex:area.column - 1]isKindOfClass:[Area class]])){
                 [[self.areaItems objectAtIndex:area.row] replaceObjectAtIndex:area.column - 1 withObject:area.leftArea ];
            }
        }
    }
    return area;
}

- (void)scanArea:(Area *)area
{
    if (area.rightArea) {
        area.rightArea = [[self.areaItems objectAtIndex:area.rightArea.row]objectAtIndex:area.rightArea.column];
        [self setPossibleMovementWithToArea:area.rightArea andFromArea:area];
    }
    if (area.upArea) {
        area.upArea = [[self.areaItems objectAtIndex:area.upArea.row]objectAtIndex:area.upArea.column];
        [self setPossibleMovementWithToArea:area.upArea andFromArea:area];
    }
    if (area.downArea) {
        area.downArea = [[self.areaItems objectAtIndex:area.downArea.row]objectAtIndex:area.downArea.column];
        [self setPossibleMovementWithToArea:area.downArea andFromArea:area];
    }
    if (area.leftArea) {
        area.leftArea = [[self.areaItems objectAtIndex:area.leftArea.row]objectAtIndex:area.leftArea.column];
        [self setPossibleMovementWithToArea:area.leftArea andFromArea:area];
    }
    
}

- (void)setPossibleMovementWithToArea:(Area*)toArea andFromArea:(Area *)fromArea
{
    toArea.tag = fromArea.tag + 1;
    toArea.firstValue = fromArea.firstValue;
    if (toArea.tag >= highestLength) {
        int drop = toArea.firstValue - toArea.value.intValue;
        if (toArea.tag != highestLength) {
            arrayDrops = [NSMutableArray array];
            
        }
        [arrayDrops addObject:[NSNumber numberWithInt:drop]];
        highestLength = toArea.tag;
    }
    [self scanArea:toArea];
}

- (Route *)getTheBestRoute
{
    Route *bestRoute = [[Route alloc]init];
    for (int i = 0; i < gridCount; i++) {
        for (int j = 0; j < gridCount; j++) {
            Area *area = [[self.areaItems objectAtIndex:i]objectAtIndex:j];
            if (area.downArea != nil || area.upArea != nil || area.rightArea != nil || area.leftArea != nil) {
         
            area.tag = 1;
            area.firstValue = area.value.intValue;
            [self scanArea:area];
                
            }
        }
    }
    bestRoute.length = highestLength;
    bestRoute.drop = [arrayDrops valueForKeyPath:@"@max.intValue"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",bestRoute.length] forKey:@"BestLength"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",bestRoute.drop] forKey:@"BestDrop"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"The best route length - %d drop - %@",bestRoute.length, bestRoute.drop);
    return bestRoute;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
