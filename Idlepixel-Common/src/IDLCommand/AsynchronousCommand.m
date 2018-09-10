/*
 Copyright (c) 2012 Tim Sawtell
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS 
 IN THE SOFTWARE.
 */

#import "AsynchronousCommand.h"
#import "TSCommandRunner.h"
#import "NSMutableArray+Idlepixel.h"
#import "IDLNSInlineExtensions.h"

NSString * const kAsynchronousCommandKeyValueFinished = @"isFinished";
NSString * const kAsynchronousCommandKeyValueExecuting = @"isExecuting";

@interface AsynchronousCommand ()

+(NSMutableArray *)executingCommandArray;

-(void)registerExecutingCommand;
-(void)deregisterExecutingCommand;

@end

@implementation AsynchronousCommand
@synthesize commandCompletionBlock, multiThreaded, finished, executing, subCommands;

+(NSMutableArray *)executingCommandArray
{
    __strong static NSMutableArray* set = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        set = [NSMutableArray new];
    });
    return set;
}

+(void)addExecutingCommand:(AsynchronousCommand *)command
{
    if (command) {
        NSMutableArray *commands = [self executingCommandArray];
        @synchronized(commands) {
            [commands addObject:command];
        }
    }
}

+(void)removeExecutingCommand:(AsynchronousCommand *)command
{
    if (command) {
        NSMutableArray *commands = [self executingCommandArray];
        @synchronized(commands) {
            [commands removeObject:command];
        }
    }
}

+ (NSArray *)executingCommands
{
    NSArray *array = nil;
    NSMutableArray *commands = [self executingCommandArray];
    if (commands) {
        @synchronized(commands) {
            array = [NSArray arrayWithArray:commands];
        }
    }
    return array;
}

+ (NSArray *)executingCommandsWithClass:(Class)aClass
{
    NSArray *executingArray = [self executingCommands];
    NSMutableArray *array = [NSMutableArray array];
    //
    for (AsynchronousCommand *command in executingArray) {
        if ([command isKindOfClass:aClass]) {
            [array addObject:command];
        }
    }
    
    if (array.count > 0) {
        return [NSArray arrayWithArray:array];
    } else {
        return nil;
    }
}

+ (BOOL)matchingCommandAlreadyExecuting:(AsynchronousCommand *)command
{
    if (command != nil) {
        NSArray *executingCommands = [self executingCommands];
        for (AsynchronousCommand *executingCommand in executingCommands) {
            if ([command isEqualToCommand:executingCommand]) {
                return YES;
            }
        }
    }
    return NO;
}

-(void)registerExecutingCommand
{
    AsynchronousCommand *selfCommand = self;
    [[self class] addExecutingCommand:selfCommand];
}

-(void)deregisterExecutingCommand
{
    AsynchronousCommand *selfCommand = self;
    [[self class] removeExecutingCommand:selfCommand];
}

- (BOOL)isEqualToCommand:(AsynchronousCommand *)command
{
    if (command == self) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    } else if (![object isKindOfClass:[self class]]) {
        return NO;
    } else {
        return [self isEqualToCommand:(AsynchronousCommand *)object];
    }
}

- (void)configure
{
    [super configure];
    self.subCommands = [NSMutableArray array];
}

- (void) start
{
    [self setFinished: NO];
    [self main];
}

- (void) main
{
    //set the NSOperation's completionBlock which occurs at the end of main
    __weak AsynchronousCommand *weakSelf = self;
    self.completionBlock = ^{
        __strong AsynchronousCommand *strongSelf = weakSelf;
        if (strongSelf.commandCompletionBlock != NULL && !strongSelf.isCancelled) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                strongSelf.commandCompletionBlock(strongSelf.error, strongSelf.completionData);
            });
        }
        strongSelf.commandCompletionBlock = nil;
    };
    //subclass should override execute to perform the logic of the command
    [self execute];
    
    //subclass MUST call [self finish] at the appropriate time, generally in the commandCompletionBlock
}


- (BOOL)isMultiThreaded
{
    return YES;
}

- (void)cancel
{
    NSArray *commands = [self.subCommands copy];
    for (Command *cmd in commands) {
        [cmd cancel];
    }
    //in subclasses add your logic to cancel the processing in execute.
    [super cancel];
}

- (void) setFinished:(BOOL) isFinished
{
    [self setExecuting: !isFinished];
    [self willChangeValueForKey: kAsynchronousCommandKeyValueFinished];
    finished = isFinished;
    [self didChangeValueForKey: kAsynchronousCommandKeyValueFinished];
}

- (void) setExecuting:(BOOL) isExecuting
{
    [self willChangeValueForKey: kAsynchronousCommandKeyValueExecuting];
    executing = isExecuting;
    if (executing) {
        [self registerExecutingCommand];
    } else {
        [self deregisterExecutingCommand];
    }
    [self didChangeValueForKey: kAsynchronousCommandKeyValueExecuting];
}

- (void) finish
{
    if (nil != self.parentCommand) {
        [self.parentCommand.subCommands removeObject:self];
        if ([self.parentCommand.subCommands count] == 0) {
            [self setFinished: YES];
            [self.parentCommand subCommandsFinished];
            return;
        }
    }
    [self setFinished: YES];
}

#define kCompletionDataArrayTag     @"AsynchronousCommand.CompletionData.Array"

-(void)addCompletionData:(NSObject *)data
{
    if (data != nil) {
        NSArray *array = self.completionData;
        
        if (array == nil) array = @[];
        
        if ([data isKindOfClass:[NSArray class]] && NSStringEquals(kCompletionDataArrayTag, data.stringTag)) {
            array = [array arrayByAddingObjectsFromArray:(NSArray *)data];
        } else {
            array = [array arrayByAddingObject:data];
        }
        
        if (array.count > 0) {
            array.stringTag = kCompletionDataArrayTag;
            self.completionData = array;
        } else {
            self.completionData = nil;
        }
    }
}

- (void)subCommandsFinished
{
    // do nothing, meant for override. sub-classes should call [self finish] at the very least.
}

- (void)executeOnSharedCommandRunner
{
    [self executeAsynchronousOnSharedCommandRunner];
}

- (void)executeAsynchronousOnSharedCommandRunner
{
    [self executeAsynchronousOnSharedCommandRunner:NO];
}

- (void)executeAsynchronousOnSharedCommandRunner:(BOOL)exclusiveExecution
{
    BOOL execute = YES;
    if (exclusiveExecution) {
        NSArray *existingCommands = [AsynchronousCommand executingCommandsWithClass:[self class]];
        execute = (existingCommands.count == 0);
    }
    
    if (execute) {
        [[TSCommandRunner sharedCommandRunner] executeAsynchronousCommand:self];
    }
}

@end
