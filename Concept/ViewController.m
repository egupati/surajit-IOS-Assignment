//
//  ViewController.m
//  Concept
//
//  Created by Surajit on 17/03/2016.
//  Copyright © 2016 axomedia. All rights reserved.
//

#import "ViewController.h"
#import "PureLayout.h"
#import "ConceptTableViewCell.h"
#import "RequestManager.h"
#import "ResponseProcessor.h"
#import  "IconDownloader.h"
#import "Record.h"

static NSString *cellIdentifier = @"HistoryCell";

#define FONT_SIZE 12.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 20.0f

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,copy) NSString *viewTitle;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic,strong) UIActivityIndicatorView *activityView;
@end

@implementation ViewController

#pragma mark - LOAD ACTIONS
- (void) refreshData {
      //[self.refreshControl endRefreshing];
    if (self.refreshControl) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@",
                           [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
       
        [self loadRequest:[[NSBundle mainBundle]
                           objectForInfoDictionaryKey:@"requestURL"]];
    }
}

/**
 @abstract Loading feed request
 @param UrlString as url request.
 */
- (void) loadRequest:(NSString *)urlString{
    [RequestManager CreateDownloadRequest:urlString
    success:^(NSDictionary *data, NSURLResponse *response) {
      self.dataArray  =  [ResponseProcessor processNoOfRows:data];
      self.viewTitle = [ResponseProcessor processTitle:data];
      dispatch_async(dispatch_get_main_queue(), ^{
          [_activityView stopAnimating];
          [self.tableView reloadData];
          self.navigationItem.title = self.viewTitle;
          self.navigationController.navigationBarHidden = NO;
          [self.refreshControl endRefreshing];
        });
     } failure:^(NSError *error) {
     }];
}

- (void) beginRefreshingTableView {
    [self.refreshControl beginRefreshing];
    if (self.tableView.contentOffset.y == 0) {
        [UIView animateWithDuration:0.25 delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^(void){
        self.tableView.contentOffset = CGPointMake(0,-self.refreshControl.frame.size.height);
        } completion:^(BOOL finished){
            
        }];
        
    }
}

#pragma mark - VIEW CYCLES
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor grayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(refreshData)
                  forControlEvents:UIControlEventValueChanged];
    
    _imageDownloadsInProgress = [NSMutableDictionary dictionary];
    self.navigationController.navigationBarHidden = YES;
}

// -------------------------------------------------------------------------------
//	terminateAllDownloads
// -------------------------------------------------------------------------------
- (void)terminateAllDownloads{
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    [self.imageDownloadsInProgress removeAllObjects];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
     [self terminateAllDownloads];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableviewConfiguration
- (void) configureTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor grayColor];
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0) ;
}


#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    if (_dataArray) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
        
    } else {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc]
                                 initWithFrame:CGRectMake(0,
                                                          0,
                                                          self.view.bounds.size.width,
                                                          self.view.bounds.size.height)];
        
        self.activityView  = [[UIActivityIndicatorView alloc]
                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.tableView.backgroundView addSubview:_activityView];
        [_activityView startAnimating];
        
        messageLabel.text = @"Please Wait downloading Data ...";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = _activityView;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      }
    return 0;
}

// number of row in the section, I assume there is only 1 row
- (NSInteger) tableView:(UITableView *)theTableView
                                    numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}


- (UITableViewCell *) tableView:(UITableView *)theTableView
                                cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger nodeCount = self.dataArray.count;
    ConceptTableViewCell *cell = (ConceptTableViewCell *)[theTableView
                              dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ConceptTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:cellIdentifier];
    }
    if (nodeCount > 0){
    Record *objRecord = [self.dataArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = objRecord.titleText;
    cell.descriptionLabel.text = objRecord.descriptionText;
        if (!objRecord.appIcon){
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO){
                if (![objRecord.imageUrl isEqualToString:@""]){
                    [self startIconDownload:objRecord forIndexPath:indexPath];
                    
                }
                else{
                    cell.imageIcon.image = [UIImage imageNamed:@"Placeholder"];
                }
            }
            cell.imageIcon.image = [UIImage imageNamed:@"Placeholder"];
        }
        else
        {
            cell.imageIcon.image = objRecord.appIcon;
        }
    }
    cell.titleLabel.numberOfLines = 0;
    cell.descriptionLabel.numberOfLines = 0;
    [cell updateConstraintsIfNeeded];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView
                            heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArray.count >0) {
        Record *recordObject =   [_dataArray objectAtIndex:indexPath.row];
        NSString *description = recordObject.descriptionText;
            CGFloat height = [self calculateHeightOfAString:description];
            CGFloat heightTitle = [self calculateHeightOfAString:recordObject.titleText];
            CGFloat totalHeight = height+heightTitle+18;
        if (totalHeight < [ConceptTableViewCell fetchImageIconHeight]) {
            return totalHeight = [ConceptTableViewCell fetchImageIconHeight]+10;
        }else{
            return totalHeight;
        }
    }
    else{
        return [ConceptTableViewCell fetchImageIconHeight];
    }
}





#pragma mark - UTILITY METHODS

- (CGFloat) calculateHeightOfAString:(NSString *)stringVal {
    CGSize size;
    CGFloat height;
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    if (stringVal != (id)[NSNull null] ) {
        CGRect textRect = [stringVal boundingRectWithSize:constraint
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]}
                                         context:nil];
        size = textRect.size;
        height = size.height;
    }
    return height;
}

#pragma mark - Table cell image support

// -------------------------------------------------------------------------------
//	startIconDownload:forIndexPath:
// -------------------------------------------------------------------------------
- (void)startIconDownload:(Record *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = (self.imageDownloadsInProgress)[indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        [iconDownloader setCompletionHandler:^{
            ConceptTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            // Display the newly loaded image
            cell.imageIcon.image = appRecord.appIcon;
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        (self.imageDownloadsInProgress)[indexPath] = iconDownloader;
        [iconDownloader startDownload];
    }
}
// -------------------------------------------------------------------------------
//	loadImagesForOnscreenRows
//  This method is used in case the user scrolled into a set of cells that don't
//  have their app icons yet.
// -------------------------------------------------------------------------------
- (void)loadImagesForOnscreenRows
{
    if (self.dataArray.count > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            Record *appRecord = (self.dataArray)[indexPath.row];
            
            if (!appRecord.appIcon)
                // Avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
        }
    }
}


#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:scrollView
//  When scrolling stops, proceed to load the app icons that are on screen.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}


@end
