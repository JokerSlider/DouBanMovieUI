//
//  HQRosterStorageTool.m
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/30.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "HQRosterStorageTool.h"

@implementation HQRosterStorageTool
-(instancetype)init{
    self = [super init];
    if (self) {
        [self getFriendList];
        [self getGroupList];
    }
    return self;
}

- (void)getFriendList{
    NSManagedObjectContext * context = [HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext;
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    NSString * jid = [HQXMPPUserInfo shareXMPPUserInfo].jid;
    NSPredicate * pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",jid];
    request.predicate = pre;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    if (context) {
        self.friendResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        self.friendResultsController.delegate = self;
        NSError *err = nil;
        [self.friendResultsController performFetch:&err];
        if (err) {
            NSLog(@"%@",err);
        }
    }
    
}

- (void)getGroupList{
    NSManagedObjectContext *moc = [HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext;
    if (!moc) {
        return;
    }
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPGroupCoreDataStorageObject"
                                              inManagedObjectContext:moc];
    
    NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    //NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, nil];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setFetchBatchSize:10];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
    NSError *err = nil;
    [self.fetchedResultsController performFetch:&err];
    if (err) {
        NSLog(@"%@",err);
    }
}


#pragma mark NSFetchedResultsController delegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
        if (self.dataUpdate != nil) {
            self.dataUpdate(nil);
        }
}

@end
