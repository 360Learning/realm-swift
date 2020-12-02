////////////////////////////////////////////////////////////////////////////
//
// Copyright 2020 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

#import "RLMTestCase.h"

static NSDate *date(int i) {
    return [NSDate dateWithTimeIntervalSince1970:i];
}
static NSData *data(int i) {
    return [NSData dataWithBytesNoCopy:calloc(i, 1) length:i freeWhenDone:YES];
}
static RLMDecimal128 *decimal128(int i) {
    return [RLMDecimal128 decimalWithNumber:@(i)];
}
static NSMutableArray *objectIds;
static RLMObjectId *objectId(NSUInteger i) {
    if (!objectIds) {
        objectIds = [NSMutableArray new];
    }
    while (i >= objectIds.count) {
        [objectIds addObject:RLMObjectId.objectId];
    }
    return objectIds[i];
}
static void count(NSArray *values, double *sum, NSUInteger *count) {
    for (id value in values) {
        if (value != NSNull.null) {
            ++*count;
            *sum += [value doubleValue];
        }
    }
}
static double sum(NSArray *values) {
    double sum = 0;
    NSUInteger c = 0;
    count(values, &sum, &c);
    return sum;
}
static double average(NSArray *values) {
    double sum = 0;
    NSUInteger c = 0;
    count(values, &sum, &c);
    return sum / c;
}

@interface PrimitiveSetPropertyTests : RLMTestCase
@end

@implementation PrimitiveSetPropertyTests {
    AllPrimitiveSets *unmanaged;
    AllPrimitiveSets *managed;
    AllOptionalPrimitiveSets *optUnmanaged;
    AllOptionalPrimitiveSets *optManaged;
    RLMRealm *realm;
    NSArray<RLMSet *> *allSets;
}

- (void)setUp {
    unmanaged = [[AllPrimitiveSets alloc] init];
    optUnmanaged = [[AllOptionalPrimitiveSets alloc] init];
    realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    managed = [AllPrimitiveSets createInRealm:realm withValue:@[]];
    optManaged = [AllOptionalPrimitiveSets createInRealm:realm withValue:@[]];
    allSets = @[
        $set,
    ];
}

- (void)tearDown {
    if (realm.inWriteTransaction) {
        [realm cancelWriteTransaction];
    }
}

- (void)addObjects {
    [$set addObjects:$values];
}

- (void)testCount {
    XCTAssertEqual(unmanaged.intObj.count, 0U);
    [unmanaged.intObj addObject:@1];
    XCTAssertEqual(unmanaged.intObj.count, 1U);
}

- (void)testType {
    XCTAssertEqual(unmanaged.boolObj.type, RLMPropertyTypeBool);
    XCTAssertEqual(unmanaged.intObj.type, RLMPropertyTypeInt);
    XCTAssertEqual(unmanaged.floatObj.type, RLMPropertyTypeFloat);
    XCTAssertEqual(unmanaged.doubleObj.type, RLMPropertyTypeDouble);
    XCTAssertEqual(unmanaged.stringObj.type, RLMPropertyTypeString);
    XCTAssertEqual(unmanaged.dataObj.type, RLMPropertyTypeData);
    XCTAssertEqual(unmanaged.dateObj.type, RLMPropertyTypeDate);
    XCTAssertEqual(optUnmanaged.boolObj.type, RLMPropertyTypeBool);
    XCTAssertEqual(optUnmanaged.intObj.type, RLMPropertyTypeInt);
    XCTAssertEqual(optUnmanaged.floatObj.type, RLMPropertyTypeFloat);
    XCTAssertEqual(optUnmanaged.doubleObj.type, RLMPropertyTypeDouble);
    XCTAssertEqual(optUnmanaged.stringObj.type, RLMPropertyTypeString);
    XCTAssertEqual(optUnmanaged.dataObj.type, RLMPropertyTypeData);
    XCTAssertEqual(optUnmanaged.dateObj.type, RLMPropertyTypeDate);
}

- (void)testOptional {
    XCTAssertFalse(unmanaged.boolObj.optional);
    XCTAssertFalse(unmanaged.intObj.optional);
    XCTAssertFalse(unmanaged.floatObj.optional);
    XCTAssertFalse(unmanaged.doubleObj.optional);
    XCTAssertFalse(unmanaged.stringObj.optional);
    XCTAssertFalse(unmanaged.dataObj.optional);
    XCTAssertFalse(unmanaged.dateObj.optional);
    XCTAssertTrue(optUnmanaged.boolObj.optional);
    XCTAssertTrue(optUnmanaged.intObj.optional);
    XCTAssertTrue(optUnmanaged.floatObj.optional);
    XCTAssertTrue(optUnmanaged.doubleObj.optional);
    XCTAssertTrue(optUnmanaged.stringObj.optional);
    XCTAssertTrue(optUnmanaged.dataObj.optional);
    XCTAssertTrue(optUnmanaged.dateObj.optional);
}

- (void)testObjectClassName {
    XCTAssertNil(unmanaged.boolObj.objectClassName);
    XCTAssertNil(unmanaged.intObj.objectClassName);
    XCTAssertNil(unmanaged.floatObj.objectClassName);
    XCTAssertNil(unmanaged.doubleObj.objectClassName);
    XCTAssertNil(unmanaged.stringObj.objectClassName);
    XCTAssertNil(unmanaged.dataObj.objectClassName);
    XCTAssertNil(unmanaged.dateObj.objectClassName);
    XCTAssertNil(optUnmanaged.boolObj.objectClassName);
    XCTAssertNil(optUnmanaged.intObj.objectClassName);
    XCTAssertNil(optUnmanaged.floatObj.objectClassName);
    XCTAssertNil(optUnmanaged.doubleObj.objectClassName);
    XCTAssertNil(optUnmanaged.stringObj.objectClassName);
    XCTAssertNil(optUnmanaged.dataObj.objectClassName);
    XCTAssertNil(optUnmanaged.dateObj.objectClassName);
}

- (void)testRealm {
    XCTAssertNil(unmanaged.boolObj.realm);
    XCTAssertNil(unmanaged.intObj.realm);
    XCTAssertNil(unmanaged.floatObj.realm);
    XCTAssertNil(unmanaged.doubleObj.realm);
    XCTAssertNil(unmanaged.stringObj.realm);
    XCTAssertNil(unmanaged.dataObj.realm);
    XCTAssertNil(unmanaged.dateObj.realm);
    XCTAssertNil(optUnmanaged.boolObj.realm);
    XCTAssertNil(optUnmanaged.intObj.realm);
    XCTAssertNil(optUnmanaged.floatObj.realm);
    XCTAssertNil(optUnmanaged.doubleObj.realm);
    XCTAssertNil(optUnmanaged.stringObj.realm);
    XCTAssertNil(optUnmanaged.dataObj.realm);
    XCTAssertNil(optUnmanaged.dateObj.realm);
}

- (void)testInvalidated {
    RLMSet *set;
    @autoreleasepool {
        AllPrimitiveSets *obj = [[AllPrimitiveSets alloc] init];
        set = obj.intObj;
        XCTAssertFalse(set.invalidated);
    }
    XCTAssertFalse(set.invalidated);
}

- (void)testDeleteObjectsInRealm {
    RLMAssertThrowsWithReason([realm deleteObjects:$allSets], @"Cannot delete objects from RLMSet");
}

- (void)testObjectAtIndex {
    RLMAssertThrowsWithReason([unmanaged.intObj objectAtIndex:0],
                              @"Index 0 is out of bounds (must be less than 0).");

    [unmanaged.intObj addObject:@1];
    XCTAssertEqualObjects([unmanaged.intObj objectAtIndex:0], @1);
}

- (void)testFirstObject {
    XCTAssertNil($allSets.firstObject);

    [self addObjects];
    XCTAssertEqualObjects($set.firstObject, $first);

    [$allSets removeAllObjects];

    %o [$set addObject:NSNull.null];
    %o XCTAssertEqualObjects($set.firstObject, NSNull.null);
}

- (void)testLastObject {
    XCTAssertNil($allSets.lastObject);

    [self addObjects];

    XCTAssertEqualObjects($set.lastObject, $last);

    [$allSets removeAllObjects];
    XCTAssertNil($set.lastObject);
}

- (void)testAddObject {
    RLMAssertThrowsWithReason([$set addObject:$wrong], ^n @"Invalid value '$wdesc' of type '$wtype' for expected type '$type'");
    %r RLMAssertThrowsWithReason([$set addObject:NSNull.null], ^n @"Invalid value '<null>' of type 'NSNull' for expected type '$type'");

    [$set addObject:$v0];
    XCTAssertEqualObjects($set[0], $v0);

    %o [$set addObject:NSNull.null];
    %o XCTAssertEqualObjects($set[0], NSNull.null);
}

- (void)testAddObjects {
    RLMAssertThrowsWithReason([$set addObjects:@[$wrong]], ^n @"Invalid value '$wdesc' of type '$wtype' for expected type '$type'");
    %r RLMAssertThrowsWithReason([$set addObjects:@[NSNull.null]], ^n @"Invalid value '<null>' of type 'NSNull' for expected type '$type'");

    [self addObjects];
    XCTAssertEqualObjects($set[0], $v0);
    XCTAssertEqualObjects($set[1], $v1);
    %o XCTAssertEqualObjects($set[2], $v2);
}

- (void)testRemoveObject {
    [self addObjects];
    %r XCTAssertEqual($set.count, 2U);
    %o XCTAssertEqual($set.count, 3U);

    [$allSets removeObject:$allSets[0]];
    %r XCTAssertEqual($set.count, 1U);
    %o XCTAssertEqual($set.count, 2U);

    XCTAssertEqualObjects($set[0], $v1);
    %o XCTAssertEqualObjects($set[1], $v2);
}

- (void)testIndexOfObject {
    XCTAssertEqual(NSNotFound, [$set indexOfObject:$v0]);

    RLMAssertThrowsWithReason([$set indexOfObject:$wrong], ^n @"Invalid value '$wdesc' of type '$wtype' for expected type '$type'");

    %r RLMAssertThrowsWithReason([$set indexOfObject:NSNull.null], ^n @"Invalid value '<null>' of type 'NSNull' for expected type '$type'");
    %o XCTAssertEqual(NSNotFound, [$set indexOfObject:NSNull.null]);

    [self addObjects];

    XCTAssertEqual(1U, [$set indexOfObject:$v1]);
}

- (void)testIndexOfObjectSorted {
    %man %r [$set addObjects:@[$v0, $v1, $v0, $v1]];
    %man %o [$set addObjects:@[$v0, $v1, NSNull.null, $v1, $v0]];

    %man %r XCTAssertEqual(0U, [[$set sortedResultsUsingKeyPath:@"self" ascending:NO] indexOfObject:$v1]);
    %man %r XCTAssertEqual(1U, [[$set sortedResultsUsingKeyPath:@"self" ascending:NO] indexOfObject:$v0]);

    %man %o XCTAssertEqual(0U, [[$set sortedResultsUsingKeyPath:@"self" ascending:NO] indexOfObject:$v1]);
    %man %o XCTAssertEqual(1U, [[$set sortedResultsUsingKeyPath:@"self" ascending:NO] indexOfObject:$v0]);
    %man %o XCTAssertEqual(1U, [[$set sortedResultsUsingKeyPath:@"self" ascending:NO] indexOfObject:NSNull.null]);
}

- (void)testIndexOfObjectDistinct {
    %man %r [$set addObjects:@[$v0, $v0, $v1]];
    %man %o [$set addObjects:@[$v0, $v0, NSNull.null, $v1, $v0]];

    %man %r XCTAssertEqual(0U, [[$set distinctResultsUsingKeyPaths:@[@"self"]] indexOfObject:$v0]);
    %man %r XCTAssertEqual(1U, [[$set distinctResultsUsingKeyPaths:@[@"self"]] indexOfObject:$v1]);

    %man %o XCTAssertEqual(0U, [[$set distinctResultsUsingKeyPaths:@[@"self"]] indexOfObject:$v0]);
    %man %o XCTAssertEqual(1U, [[$set distinctResultsUsingKeyPaths:@[@"self"]] indexOfObject:$v1]);
    %man %o XCTAssertEqual(0U, [[$set distinctResultsUsingKeyPaths:@[@"self"]] indexOfObject:NSNull.null]);
}

- (void)testIndexOfObjectWhere {
    %man RLMAssertThrowsWithReason([$set indexOfObjectWhere:@"TRUEPREDICATE"], @"implemented");
    %man RLMAssertThrowsWithReason([[$set sortedResultsUsingKeyPath:@"self" ascending:NO] ^n  indexOfObjectWhere:@"TRUEPREDICATE"], @"implemented");

    %unman XCTAssertEqual(NSNotFound, [$set indexOfObjectWhere:@"TRUEPREDICATE"]);

    [self addObjects];

    %unman XCTAssertEqual(0U, [$set indexOfObjectWhere:@"TRUEPREDICATE"]);
    %unman XCTAssertEqual(NSNotFound, [$set indexOfObjectWhere:@"FALSEPREDICATE"]);
}

- (void)testIndexOfObjectWithPredicate {
    %man RLMAssertThrowsWithReason([$set indexOfObjectWithPredicate:[NSPredicate predicateWithValue:YES]], @"implemented");
    %man RLMAssertThrowsWithReason([[$set sortedResultsUsingKeyPath:@"self" ascending:NO] ^n  indexOfObjectWithPredicate:[NSPredicate predicateWithValue:YES]], @"implemented");

    %unman XCTAssertEqual(NSNotFound, [$set indexOfObjectWithPredicate:[NSPredicate predicateWithValue:YES]]);

    [self addObjects];

    %unman XCTAssertEqual(0U, [$set indexOfObjectWithPredicate:[NSPredicate predicateWithValue:YES]]);
    %unman XCTAssertEqual(NSNotFound, [$set indexOfObjectWithPredicate:[NSPredicate predicateWithValue:NO]]);
}

- (void)testSort {
    %unman RLMAssertThrowsWithReason([$set sortedResultsUsingKeyPath:@"self" ascending:NO], ^n @"This method may only be called on RLMSet instances retrieved from an RLMRealm");
    %unman RLMAssertThrowsWithReason([$set sortedResultsUsingDescriptors:@[]], ^n @"This method may only be called on RLMSet instances retrieved from an RLMRealm");
    %man RLMAssertThrowsWithReason([$set sortedResultsUsingKeyPath:@"not self" ascending:NO], ^n @"can only be sorted on 'self'");

    %man %r [$set addObjects:@[$v0, $v1, $v0]];
    %man %o [$set addObjects:@[$v0, $v1, NSNull.null, $v1, $v0]];

    %man %r XCTAssertEqualObjects([[[$set sortedResultsUsingDescriptors:@[]] valueForKey:@"self"] allObjects], ^n (@[$v0, $v1]));
    %man %o XCTAssertEqualObjects([[[$set sortedResultsUsingDescriptors:@[]] valueForKey:@"self"] allObjects], ^n (@[$v0, $v1]));

    %man %r XCTAssertEqualObjects([[[$set sortedResultsUsingKeyPath:@"self" ascending:NO] valueForKey:@"self"] allObjects], ^n (@[$v1, $v0]));
    %man %o XCTAssertEqualObjects([[[$set sortedResultsUsingKeyPath:@"self" ascending:NO] valueForKey:@"self"] allObjects], ^n (@[$v1, $v0]));

    %man %r XCTAssertEqualObjects([[[$set sortedResultsUsingKeyPath:@"self" ascending:YES] valueForKey:@"self"] allObjects], ^n (@[$v0, $v1]));
    %man %o XCTAssertEqualObjects([[[$set sortedResultsUsingKeyPath:@"self" ascending:YES] valueForKey:@"self"] allObjects], ^n (@[NSNull.null, $v1]));
}

- (void)testFilter {
    %unman RLMAssertThrowsWithReason([$set objectsWhere:@"TRUEPREDICATE"], ^n @"This method may only be called on RLMSet instances retrieved from an RLMRealm");
    %unman RLMAssertThrowsWithReason([$set objectsWithPredicate:[NSPredicate predicateWithValue:YES]], ^n @"This method may only be called on RLMSet instances retrieved from an RLMRealm");

    %man RLMAssertThrowsWithReason([$set objectsWhere:@"TRUEPREDICATE"], ^n @"implemented");
    %man RLMAssertThrowsWithReason([$set objectsWithPredicate:[NSPredicate predicateWithValue:YES]], ^n @"implemented");

    %man RLMAssertThrowsWithReason([[$set sortedResultsUsingKeyPath:@"self" ascending:NO] ^n  objectsWhere:@"TRUEPREDICATE"], @"implemented");
    %man RLMAssertThrowsWithReason([[$set sortedResultsUsingKeyPath:@"self" ascending:NO] ^n  objectsWithPredicate:[NSPredicate predicateWithValue:YES]], @"implemented");
}

- (void)testNotifications {
    %unman RLMAssertThrowsWithReason([$set addNotificationBlock:^(__unused id a, __unused id c, __unused id e) { }], ^n @"This method may only be called on RLMSet instances retrieved from an RLMRealm");
}

- (void)testUnion {
    %man %r [$set addObjects:@[$v0, $v1]];
    %man %o [$set addObjects:@[$v0, $v1, NSNull.null]];
    %man %r [$set2 addObjects:@[$v3, $v4]];
    %man %o [$set2 addObjects:@[$v3, $v4, NSNull.null]];
    [realm commitWriteTransaction];

    %unman %r [$set addObjects:@[$v0, $v1]];
    %unman %o [$set addObjects:@[$v0, $v1, NSNull.null]];
    %unman %r [$set2 addObjects:@[$v3, $v4]];
    %unman %o [$set2 addObjects:@[$v3, $v4, NSNull.null]];

    %man XCTAssertThrows([$set unionSet:$set2]);
    %unman [$set unionSet:$set2];

    [realm beginWriteTransaction];
    %man [$set unionSet:$set2];
    [realm commitWriteTransaction];

    %unman %r %maxtwovalues XCTAssertEqual($set.count, 2U);
    %unman %r %maxtwovalues XCTAssertEqualObjects($set.array, (@[$v0, $v1]));
    %unman %r %nomaxvalues XCTAssertEqual($set.count, 3U);
    %unman %r %nomaxvalues XCTAssertEqualObjects($set.array, (@[$v0, $v1, $v4]));
    %unman %o %maxtwovalues XCTAssertEqual($set.count, 3U);
    %unman %o %maxtwovalues XCTAssertEqualObjects($set.array, (@[$v0, $v1, $v2]));
    %unman %o %nomaxvalues XCTAssertEqual($set.count, 4U);
    %unman %o %nomaxvalues XCTAssertEqualObjects($set.array, (@[$v0, $v1, $v3, $v4]));
    %man %r %maxtwovalues XCTAssertEqual($set.count, 2U);
    %man %r %maxtwovalues XCTAssertEqualObjects($set.array, (@[$v0, $v1]));
    %man %r %nomaxvalues XCTAssertEqual($set.count, 3U);
    %man %r %nomaxvalues XCTAssertEqualObjects($set.array, (@[$v0, $v1, $v4]));
    %man %o %maxtwovalues XCTAssertEqual($set.count, 3U);
    %man %o %maxtwovalues XCTAssertEqualObjects($set.array, (@[$v0, $v1, %v2]));
    %man %o %nomaxvalues XCTAssertEqual($set.count, 4U);
    %man %o %nomaxvalues XCTAssertEqualObjects($set.array, (@[$v0, $v1, %v3, %v4]));
}

- (void)testIntersect {
    %man %r [$set addObjects:@[$v0, $v1]];
    %man %o [$set addObjects:@[$v0, $v1, NSNull.null]];
    %man %r [$set2 addObjects:@[$v3, $v4]];
    %man %o [$set2 addObjects:@[$v3, $v4, NSNull.null]];
    [realm commitWriteTransaction];

    %unman %r [$set addObjects:@[$v0, $v1]];
    %unman %o [$set addObjects:@[$v0, $v1, NSNull.null]];
    %unman %r [$set2 addObjects:@[$v3, $v4]];
    %unman %o [$set2 addObjects:@[$v3, $v4, NSNull.null]];

    %man XCTAssertThrows([$set intersectSet:$set2]);
    %man XCTAssertTrue([$set intersectsSet:$set2]);
    %unman XCTAssertTrue([$set intersectsSet:$set2]);

    %unman [$set intersectSet:$set2];

    [realm beginWriteTransaction];
    %man [$set intersectSet:$set2];
    [realm commitWriteTransaction];

    %unman %r %maxtwovalues XCTAssertEqual($set.count, 2U);
    %unman %r %maxtwovalues XCTAssertEqualObjects($set.array, (@[$v0, $v1]));
    %unman %r %nomaxvalues XCTAssertEqual($set.count, 1U);
    %unman %r %nomaxvalues XCTAssertEqualObjects($set.array, (@[$v0]));
    %unman %o %maxtwovalues XCTAssertEqual($set.count, 2U);
    %unman %o %maxtwovalues XCTAssertEqualObjects($set.array, (@[$v0, $v1]));
    %unman %o %nomaxvalues XCTAssertEqual($set.count, 1U);
    %unman %o %nomaxvalues XCTAssertEqualObjects($set.array, (@[$v0]));
    %man %r %maxtwovalues XCTAssertEqual($set.count, 2U);
    %man %r %maxtwovalues XCTAssertEqualObjects($set.array, (@[$v0, $v1]));
    %man %r %nomaxvalues XCTAssertEqual($set.count, 1U);
    %man %r %nomaxvalues XCTAssertEqualObjects($set.array, (@[$v1]));
    %man %o %maxtwovalues XCTAssertEqual($set.count, 2U);
    %man %o %maxtwovalues XCTAssertEqualObjects($set.array, (@[$v0, $v1]));
    %man %o %nomaxvalues XCTAssertEqual($set.count, 1U);
    %man %o %nomaxvalues XCTAssertEqualObjects($set.array, (@[$v0]));
}

- (void)testMinus {
    %man %r [$set addObjects:@[$v0, $v1]];
    %man %o [$set addObjects:@[$v0, $v1, NSNull.null]];
    %man %r [$set2 addObjects:@[$v3, $v4]];
    %man %o [$set2 addObjects:@[$v3, $v4, NSNull.null]];
    [realm commitWriteTransaction];

    %unman %r [$set addObjects:@[$v0, $v1]];
    %unman %o [$set addObjects:@[$v0, $v1, NSNull.null]];
    %unman %r [$set2 addObjects:@[$v3, $v4]];
    %unman %o [$set2 addObjects:@[$v3, $v4, NSNull.null]];

    %man XCTAssertThrows([$set minusSet:$set2]);

    %unman [$set minusSet:$set2];

    [realm beginWriteTransaction];
    %man [$set minusSet:$set2];
    [realm commitWriteTransaction];

    %unman %r %maxtwovalues XCTAssertEqual($set.count, 0U);
    %unman %r %maxtwovalues XCTAssertEqualObjects($set.array, (@[]));
    %unman %r %nomaxvalues XCTAssertEqual($set.count, 1U);
    %unman %r %nomaxvalues XCTAssertEqualObjects($set.array, (@[$v1]));
    %unman %o %maxtwovalues XCTAssertEqual($set.count, 0U);
    %unman %o %maxtwovalues XCTAssertEqualObjects($set.array, (@[]));
    %unman %o %nomaxvalues XCTAssertEqual($set.count, 1U);
    %unman %o %nomaxvalues XCTAssertEqualObjects($set.array, (@[$v1]));
    %man %r %maxtwovalues XCTAssertEqual($set.count, 0U);
    %man %r %maxtwovalues XCTAssertEqualObjects($set.array, (@[]));
    %man %r %nomaxvalues XCTAssertEqual($set.count, 1U);
    %man %r %nomaxvalues XCTAssertEqualObjects($set.array, (@[$v0]));
    %man %o %maxtwovalues XCTAssertEqual($set.count, 0U);
    %man %o %maxtwovalues XCTAssertEqualObjects($set.array, (@[]));
    %man %o %nomaxvalues XCTAssertEqual($set.count, 1U);
    %man %o %nomaxvalues XCTAssertEqualObjects($set.array, (@[$v1]));
}

- (void)testIsSubsetOfSet {
    %man %r [$set addObjects:@[$v0, $v1]];
    %man %o [$set addObjects:@[$v0, $v1, NSNull.null]];
    %man %r [$set2 addObjects:@[$v0, $v1, $v3, $v4]];
    %man %o [$set2 addObjects:@[$v0, $v1, $v3, $v4, NSNull.null]];
    [realm commitWriteTransaction];

    %unman %r [$set addObjects:@[$v0, $v1]];
    %unman %o [$set addObjects:@[$v0, $v1, NSNull.null]];
    %unman %r [$set2 addObjects:@[$v0, $v1, $v3, $v4]];
    %unman %o [$set2 addObjects:@[$v0, $v1, $v3, $v4, NSNull.null]];

    %maxtwovalues %r %man XCTAssertTrue([$set2 isSubsetOfSet:$set]);
    %maxtwovalues %r %unman XCTAssertTrue([$set2 isSubsetOfSet:$set]);
    %maxtwovalues %o %man XCTAssertFalse([$set2 isSubsetOfSet:$set]);
    %maxtwovalues %o %unman XCTAssertFalse([$set2 isSubsetOfSet:$set]);

    %maxtwovalues %r %man XCTAssertTrue([$set isSubsetOfSet:$set2]);
    %maxtwovalues %r %unman XCTAssertTrue([$set isSubsetOfSet:$set2]);
    %maxtwovalues %o %man XCTAssertTrue([$set isSubsetOfSet:$set2]);
    %maxtwovalues %o %unman XCTAssertTrue([$set isSubsetOfSet:$set2]);

    %nomaxvalues %man XCTAssertTrue([$set isSubsetOfSet:$set2]);
    %nomaxvalues %unman XCTAssertTrue([$set isSubsetOfSet:$set2]);
    %nomaxvalues %man XCTAssertFalse([$set2 isSubsetOfSet:$set]);
    %nomaxvalues %unman XCTAssertFalse([$set2 isSubsetOfSet:$set]);
}

- (void)testMin {
    %nominmax %unman RLMAssertThrowsWithReason([$set minOfProperty:@"self"], ^n @"minOfProperty: is not supported for $type set");
    %nominmax %man RLMAssertThrowsWithReason([$set minOfProperty:@"self"], ^n @"minOfProperty: is not supported for $type set '$class.$prop'");

    %minmax XCTAssertNil([$set minOfProperty:@"self"]);

    [self addObjects];

    %minmax %unman %r XCTAssertEqualObjects([$set minOfProperty:@"self"], $v0);
    %minmax %unman %o XCTAssertEqualObjects([$set minOfProperty:@"self"], $v1);

    %minmax %man %r XCTAssertEqualObjects([$set minOfProperty:@"self"], $v0);
    %minmax %man %o XCTAssertEqualObjects([$set minOfProperty:@"self"], $v1);
}

- (void)testMax {
    %nominmax %unman RLMAssertThrowsWithReason([$set maxOfProperty:@"self"], ^n @"maxOfProperty: is not supported for $type set");
    %nominmax %man RLMAssertThrowsWithReason([$set maxOfProperty:@"self"], ^n @"maxOfProperty: is not supported for $type set '$class.$prop'");

    %minmax XCTAssertNil([$set maxOfProperty:@"self"]);

    [self addObjects];

    %minmax %unman %r XCTAssertEqualObjects([$set maxOfProperty:@"self"], $v1);
    %minmax %unman %o XCTAssertEqualObjects([$set maxOfProperty:@"self"], $v2);

    %minmax %man %r XCTAssertEqualObjects([$set maxOfProperty:@"self"], $v1);
    %minmax %man %o XCTAssertEqualObjects([$set maxOfProperty:@"self"], $v2);
}

- (void)testSum {
    %nosum %unman RLMAssertThrowsWithReason([$set sumOfProperty:@"self"], ^n @"sumOfProperty: is not supported for $type set");
    %nosum %man RLMAssertThrowsWithReason([$set sumOfProperty:@"self"], ^n @"sumOfProperty: is not supported for $type set '$class.$prop'");

    %sum XCTAssertEqualObjects([$set sumOfProperty:@"self"], @0);

    [self addObjects];

    %sum XCTAssertEqualWithAccuracy([$set sumOfProperty:@"self"].doubleValue, sum($values), .001);
}

- (void)testAverage {
    %noavg %unman RLMAssertThrowsWithReason([$set averageOfProperty:@"self"], ^n @"averageOfProperty: is not supported for $type set");
    %noavg %man RLMAssertThrowsWithReason([$set averageOfProperty:@"self"], ^n @"averageOfProperty: is not supported for $type set '$class.$prop'");

    %avg XCTAssertNil([$set averageOfProperty:@"self"]);

    [self addObjects];

    %avg XCTAssertEqualWithAccuracy([$set averageOfProperty:@"self"].doubleValue, average($values), .001);
}

- (void)testFastEnumeration {
    for (int i = 0; i < 10; ++i) {
        [self addObjects];
    }

    { ^nl NSUInteger i = 0; ^nl NSArray *values = $values; ^nl for (id value in $set) { ^nl XCTAssertEqualObjects(values[i++ % values.count], value); ^nl } ^nl XCTAssertEqual(i, $set.count); ^nl } ^nl
}

- (void)testValueForKeySelf {
    XCTAssertEqualObjects([[$allSets valueForKey:@"self"] allObjects], @[]);

    [self addObjects];

    XCTAssertEqualObjects([[$set valueForKey:@"self"] allObjects], ($values));
}

- (void)testValueForKeyNumericAggregates {
    %minmax XCTAssertNil([$set valueForKeyPath:@"@min.self"]);
    %minmax XCTAssertNil([$set valueForKeyPath:@"@max.self"]);
    %sum XCTAssertEqualObjects([$set valueForKeyPath:@"@sum.self"], @0);
    %avg XCTAssertNil([$set valueForKeyPath:@"@avg.self"]);

    [self addObjects];

    %minmax %unman %r XCTAssertEqualObjects([$set valueForKeyPath:@"@min.self"], $v0);
    %minmax %unman %o XCTAssertEqualObjects([$set valueForKeyPath:@"@max.self"], $v2);

    %minmax %man %r XCTAssertEqualObjects([$set valueForKeyPath:@"@min.self"], $v0);
    %minmax %man %o XCTAssertEqualObjects([$set valueForKeyPath:@"@max.self"], $v2);

    %sum XCTAssertEqualWithAccuracy([[$set valueForKeyPath:@"@sum.self"] doubleValue], sum($values), .001);
    %avg XCTAssertEqualWithAccuracy([[$set valueForKeyPath:@"@avg.self"] doubleValue], average($values), .001);
}

- (void)testValueForKeyLength {
    XCTAssertEqualObjects([[$allSets valueForKey:@"length"] allObjects], @[]);

    [self addObjects];
    // Note: using `valueForKey:@"length"` on an NSSet will always return distinct values
    // so if we have an array with the values @["a", "b"], the length would be 2, but for a set it will be 1
    %string XCTAssertEqualObjects([[$set valueForKey:@"length"] allObjects], ([$values valueForKey:@"length"]));
}

- (void)testSetValueForKey {
    RLMAssertThrowsWithReason([$allSets setValue:@0 forKey:@"not self"], ^n @"this class is not key value coding-compliant for the key not self.");
    RLMAssertThrowsWithReason([$set setValue:$wrong forKey:@"self"], ^n @"Invalid value '$wdesc' of type '$wtype' for expected type '$type'");
    %r RLMAssertThrowsWithReason([$set setValue:NSNull.null forKey:@"self"], ^n @"Invalid value '<null>' of type 'NSNull' for expected type '$type'");

    [self addObjects];

    // setValue overrides all existing values
    [$set setValue:$v0 forKey:@"self"];

    %unman RLMAssertThrowsWithReason($set[1], @"Index 1 is out of bounds (must be less than 1).");
    %man RLMAssertThrowsWithReason($set[1], @"Requested index 1 greater than max 0");

    XCTAssertEqualObjects($set[0], $v0);
    %o XCTAssertEqualObjects($set[0], $v0);

    %o [$set setValue:NSNull.null forKey:@"self"];
    %o XCTAssertEqualObjects($set[0], NSNull.null);
}

- (void)testAssignment {
    $set = (id)@[$v1]; ^nl XCTAssertEqualObjects($set[0], $v1);

    // Should replace and not append
    $set = (id)$values; ^nl XCTAssertEqualObjects([[$set valueForKey:@"self"] allObjects], ($values)); ^nl

    // Should not clear the set
    $set = $set; ^nl XCTAssertEqualObjects([[$set valueForKey:@"self"] allObjects], ($values)); ^nl

    [unmanaged.intObj removeAllObjects];
    unmanaged.intObj = managed.intObj;
    XCTAssertEqualObjects([[unmanaged.intObj valueForKey:@"self"] allObjects], (@[@2, @3]));

    [managed.intObj removeAllObjects];
    managed.intObj = unmanaged.intObj;
    XCTAssertEqualObjects([[managed.intObj valueForKey:@"self"] allObjects], (@[@2, @3]));
}

- (void)testDynamicAssignment {
    $obj[@"$prop"] = (id)@[$v1]; ^nl XCTAssertEqualObjects($obj[@"$prop"][0], $v1);

    // Should replace and not append
    $obj[@"$prop"] = (id)$values; ^nl XCTAssertEqualObjects([$obj[@"$prop"] valueForKey:@"self"], ($values)); ^nl

    // Should not clear the set
    $obj[@"$prop"] = $obj[@"$prop"]; ^nl XCTAssertEqualObjects([$obj[@"$prop"] valueForKey:@"self"], ($values)); ^nl

    [unmanaged[@"intObj"] removeAllObjects];
    unmanaged[@"intObj"] = managed.intObj;
    XCTAssertEqualObjects([unmanaged[@"intObj"] valueForKey:@"self"], (@[@2, @3]));

    [managed[@"intObj"] removeAllObjects];
    managed[@"intObj"] = unmanaged.intObj;
    XCTAssertEqualObjects([managed[@"intObj"] valueForKey:@"self"], (@[@2, @3]));
}

- (void)testInvalidAssignment {
    RLMAssertThrowsWithReason(unmanaged.intObj = (id)@[NSNull.null],
                              @"Invalid value '<null>' of type 'NSNull' for 'int' set property 'AllPrimitiveSets.intObj'.");
    RLMAssertThrowsWithReason(unmanaged.intObj = (id)@[@"a"],
                              @"Invalid value 'a' of type '__NSCFConstantString' for 'int' set property 'AllPrimitiveSets.intObj'.");
    RLMAssertThrowsWithReason(unmanaged.intObj = (id)(@[@1, @"a"]),
                              @"Invalid value 'a' of type '__NSCFConstantString' for 'int' set property 'AllPrimitiveSets.intObj'.");
    RLMAssertThrowsWithReason(unmanaged.intObj = (id)unmanaged.floatObj,
                              @"RLMSet<float> does not match expected type 'int' for property 'AllPrimitiveSets.intObj'.");
    RLMAssertThrowsWithReason(unmanaged.intObj = (id)optUnmanaged.intObj,
                              @"RLMSet<int?> does not match expected type 'int' for property 'AllPrimitiveSets.intObj'.");
    RLMAssertThrowsWithReason(unmanaged[@"intObj"] = unmanaged[@"floatObj"],
                              @"RLMSet<float> does not match expected type 'int' for property 'AllPrimitiveSets.intObj'.");
    RLMAssertThrowsWithReason(unmanaged[@"intObj"] = optUnmanaged[@"intObj"],
                              @"RLMSet<int?> does not match expected type 'int' for property 'AllPrimitiveSets.intObj'.");

    RLMAssertThrowsWithReason(managed.intObj = (id)@[NSNull.null],
                              @"Invalid value '<null>' of type 'NSNull' for 'int' set property 'AllPrimitiveSets.intObj'.");
    RLMAssertThrowsWithReason(managed.intObj = (id)@[@"a"],
                              @"Invalid value 'a' of type '__NSCFConstantString' for 'int' set property 'AllPrimitiveSets.intObj'.");
    RLMAssertThrowsWithReason(managed.intObj = (id)(@[@1, @"a"]),
                              @"Invalid value 'a' of type '__NSCFConstantString' for 'int' set property 'AllPrimitiveSets.intObj'.");
    RLMAssertThrowsWithReason(managed.intObj = (id)managed.floatObj,
                              @"RLMSet<float> does not match expected type 'int' for property 'AllPrimitiveSets.intObj'.");
    RLMAssertThrowsWithReason(managed.intObj = (id)optManaged.intObj,
                              @"RLMSet<int?> does not match expected type 'int' for property 'AllPrimitiveSets.intObj'.");
    RLMAssertThrowsWithReason(managed[@"intObj"] = (id)managed[@"floatObj"],
                              @"RLMSet<float> does not match expected type 'int' for property 'AllPrimitiveSets.intObj'.");
    RLMAssertThrowsWithReason(managed[@"intObj"] = (id)optManaged[@"intObj"],
                              @"RLMSet<int?> does not match expected type 'int' for property 'AllPrimitiveSets.intObj'.");
}

- (void)testAllMethodsCheckThread {
    RLMSet *set = managed.intObj;
    [self dispatchAsyncAndWait:^{
        RLMAssertThrowsWithReason([set count], @"thread");
        RLMAssertThrowsWithReason([set objectAtIndex:0], @"thread");
        RLMAssertThrowsWithReason([set firstObject], @"thread");
        RLMAssertThrowsWithReason([set lastObject], @"thread");

        RLMAssertThrowsWithReason([set addObject:@0], @"thread");
        RLMAssertThrowsWithReason([set addObjects:@[@0]], @"thread");
        RLMAssertThrowsWithReason([set removeAllObjects], @"thread");

        RLMAssertThrowsWithReason([set indexOfObject:@1], @"thread");
        /* RLMAssertThrowsWithReason([set indexOfObjectWhere:@"TRUEPREDICATE"], @"thread"); */
        /* RLMAssertThrowsWithReason([set indexOfObjectWithPredicate:[NSPredicate predicateWithValue:NO]], @"thread"); */
        /* RLMAssertThrowsWithReason([set objectsWhere:@"TRUEPREDICATE"], @"thread"); */
        /* RLMAssertThrowsWithReason([set objectsWithPredicate:[NSPredicate predicateWithValue:NO]], @"thread"); */
        RLMAssertThrowsWithReason([set sortedResultsUsingKeyPath:@"self" ascending:YES], @"thread");
        RLMAssertThrowsWithReason([set sortedResultsUsingDescriptors:@[[RLMSortDescriptor sortDescriptorWithKeyPath:@"self" ascending:YES]]], @"thread");
        RLMAssertThrowsWithReason(set[0], @"thread");
        RLMAssertThrowsWithReason([set valueForKey:@"self"], @"thread");
        RLMAssertThrowsWithReason([set setValue:@1 forKey:@"self"], @"thread");
        RLMAssertThrowsWithReason({for (__unused id obj in set);}, @"thread");
    }];
}

- (void)testAllMethodsCheckForInvalidation {
    RLMSet *set = managed.intObj;
    [realm cancelWriteTransaction];
    [realm invalidate];

    XCTAssertNoThrow([set objectClassName]);
    XCTAssertNoThrow([set realm]);
    XCTAssertNoThrow([set isInvalidated]);

    RLMAssertThrowsWithReason([set count], @"invalidated");
    RLMAssertThrowsWithReason([set objectAtIndex:0], @"invalidated");
    RLMAssertThrowsWithReason([set firstObject], @"invalidated");
    RLMAssertThrowsWithReason([set lastObject], @"invalidated");

    RLMAssertThrowsWithReason([set addObject:@0], @"invalidated");
    RLMAssertThrowsWithReason([set addObjects:@[@0]], @"invalidated");
    RLMAssertThrowsWithReason([set removeAllObjects], @"invalidated");

    RLMAssertThrowsWithReason([set indexOfObject:@1], @"invalidated");
    /* RLMAssertThrowsWithReason([set indexOfObjectWhere:@"TRUEPREDICATE"], @"invalidated"); */
    /* RLMAssertThrowsWithReason([set indexOfObjectWithPredicate:[NSPredicate predicateWithValue:YES]], @"invalidated"); */
    /* RLMAssertThrowsWithReason([set objectsWhere:@"TRUEPREDICATE"], @"invalidated"); */
    /* RLMAssertThrowsWithReason([set objectsWithPredicate:[NSPredicate predicateWithValue:YES]], @"invalidated"); */
    RLMAssertThrowsWithReason([set sortedResultsUsingKeyPath:@"self" ascending:YES], @"invalidated");
    RLMAssertThrowsWithReason([set sortedResultsUsingDescriptors:@[[RLMSortDescriptor sortDescriptorWithKeyPath:@"self" ascending:YES]]], @"invalidated");
    RLMAssertThrowsWithReason(set[0], @"invalidated");
    RLMAssertThrowsWithReason([set valueForKey:@"self"], @"invalidated");
    RLMAssertThrowsWithReason([set setValue:@1 forKey:@"self"], @"invalidated");
    RLMAssertThrowsWithReason({for (__unused id obj in set);}, @"invalidated");

    [realm beginWriteTransaction];
}

- (void)testMutatingMethodsCheckForWriteTransaction {
    RLMSet *set = managed.intObj;
    [set addObject:@0];
    [realm commitWriteTransaction];

    XCTAssertNoThrow([set objectClassName]);
    XCTAssertNoThrow([set realm]);
    XCTAssertNoThrow([set isInvalidated]);

    XCTAssertNoThrow([set count]);
    XCTAssertNoThrow([set objectAtIndex:0]);
    XCTAssertNoThrow([set firstObject]);
    XCTAssertNoThrow([set lastObject]);

    XCTAssertNoThrow([set indexOfObject:@1]);
    /* XCTAssertNoThrow([set indexOfObjectWhere:@"TRUEPREDICATE"]); */
    /* XCTAssertNoThrow([set indexOfObjectWithPredicate:[NSPredicate predicateWithValue:YES]]); */
    /* XCTAssertNoThrow([set objectsWhere:@"TRUEPREDICATE"]); */
    /* XCTAssertNoThrow([set objectsWithPredicate:[NSPredicate predicateWithValue:YES]]); */
    XCTAssertNoThrow([set sortedResultsUsingKeyPath:@"self" ascending:YES]);
    XCTAssertNoThrow([set sortedResultsUsingDescriptors:@[[RLMSortDescriptor sortDescriptorWithKeyPath:@"self" ascending:YES]]]);
    XCTAssertNoThrow(set[0]);
    XCTAssertNoThrow([set valueForKey:@"self"]);
    XCTAssertNoThrow({for (__unused id obj in set);});


    RLMAssertThrowsWithReason([set addObject:@0], @"write transaction");
    RLMAssertThrowsWithReason([set addObjects:@[@0]], @"write transaction");
    RLMAssertThrowsWithReason([set removeAllObjects], @"write transaction");

    RLMAssertThrowsWithReason([set setValue:@1 forKey:@"self"], @"write transaction");
}

- (void)testDeleteOwningObject {
    RLMSet *set = managed.intObj;
    XCTAssertFalse(set.isInvalidated);
    [realm deleteObject:managed];
    XCTAssertTrue(set.isInvalidated);
}

#pragma clang diagnostic ignored "-Warc-retain-cycles"

- (void)testNotificationSentInitially {
    [realm commitWriteTransaction];

    id expectation = [self expectationWithDescription:@""];
    id token = [managed.intObj addNotificationBlock:^(RLMSet *set, RLMCollectionChange *change, NSError *error) {
        XCTAssertNotNil(set);
        XCTAssertNil(change);
        XCTAssertNil(error);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:2.0 handler:nil];
    [(RLMNotificationToken *)token invalidate];
}

- (void)testNotificationSentAfterCommit {
    [realm commitWriteTransaction];

    __block bool first = true;
    __block id expectation = [self expectationWithDescription:@""];
    id token = [managed.intObj addNotificationBlock:^(RLMSet *set, RLMCollectionChange *change, NSError *error) {
        XCTAssertNotNil(set);
        XCTAssertNil(error);
        if (first) {
            XCTAssertNil(change);
        }
        else {
            XCTAssertEqualObjects(change.insertions, @[@0]);
        }

        first = false;
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];

    expectation = [self expectationWithDescription:@""];
    [self dispatchAsyncAndWait:^{
        RLMRealm *r = [RLMRealm defaultRealm];
        [r transactionWithBlock:^{
            RLMSet *set = [(AllPrimitiveSets *)[AllPrimitiveSets allObjectsInRealm:r].firstObject intObj];
            [set addObject:@0];
        }];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];

    [(RLMNotificationToken *)token invalidate];
}

- (void)testNotificationNotSentForUnrelatedChange {
    [realm commitWriteTransaction];

    id expectation = [self expectationWithDescription:@""];
    id token = [managed.intObj addNotificationBlock:^(__unused RLMSet *set, __unused RLMCollectionChange *change, __unused NSError *error) {
        // will throw if it's incorrectly called a second time due to the
        // unrelated write transaction
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];

    // All notification blocks are called as part of a single runloop event, so
    // waiting for this one also waits for the above one to get a chance to run
    [self waitForNotification:RLMRealmDidChangeNotification realm:realm block:^{
        [self dispatchAsyncAndWait:^{
            RLMRealm *r = [RLMRealm defaultRealm];
            [r transactionWithBlock:^{
                [AllPrimitiveSets createInRealm:r withValue:@[]];
            }];
        }];
    }];
    [(RLMNotificationToken *)token invalidate];
}

- (void)testNotificationSentOnlyForActualRefresh {
    [realm commitWriteTransaction];

    __block id expectation = [self expectationWithDescription:@""];
    id token = [managed.intObj addNotificationBlock:^(RLMSet *set, __unused RLMCollectionChange *change, NSError *error) {
        XCTAssertNotNil(set);
        XCTAssertNil(error);
        // will throw if it's called a second time before we create the new
        // expectation object immediately before manually refreshing
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];

    // Turn off autorefresh, so the background commit should not result in a notification
    realm.autorefresh = NO;

    // All notification blocks are called as part of a single runloop event, so
    // waiting for this one also waits for the above one to get a chance to run
    [self waitForNotification:RLMRealmRefreshRequiredNotification realm:realm block:^{
        [self dispatchAsyncAndWait:^{
            RLMRealm *r = [RLMRealm defaultRealm];
            [r transactionWithBlock:^{
                RLMSet *set = [(AllPrimitiveSets *)[AllPrimitiveSets allObjectsInRealm:r].firstObject intObj];
                [set addObject:@0];
            }];
        }];
    }];

    expectation = [self expectationWithDescription:@""];
    [realm refresh];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];

    [(RLMNotificationToken *)token invalidate];
}

- (void)testDeletingObjectWithNotificationsRegistered {
    [managed.intObj addObjects:@[@10, @20]];
    [realm commitWriteTransaction];

    __block bool first = true;
    __block id expectation = [self expectationWithDescription:@""];
    id token = [managed.intObj addNotificationBlock:^(RLMSet *set, RLMCollectionChange *change, NSError *error) {
        XCTAssertNotNil(set);
        XCTAssertNil(error);
        if (first) {
            XCTAssertNil(change);
            first = false;
        }
        else {
            XCTAssertEqualObjects(change.deletions, (@[@0, @1]));
        }
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];

    [realm beginWriteTransaction];
    [realm deleteObject:managed];
    [realm commitWriteTransaction];

    expectation = [self expectationWithDescription:@""];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];

    [(RLMNotificationToken *)token invalidate];
}

@end
