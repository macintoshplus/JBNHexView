//
//  JBNHexAddress.h
//  HexView
//
//  Created by Jean-Baptiste Nahan on 23/09/10.
//  Copyright 2010-2014 Jean-Baptiste Nahan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "JBNAsciiTextView.h"
//#import "JBNHexTextView.h"

@class JBNAsciiTextView;

@interface JBNHexAddress : NSObject {
	id document;
	
	
	NSPoint zeroPoint;
	NSDictionary *attributes;
	
	NSScrollView *scrollView;
	NSScrollView *gutterScrollView;
	NSLayoutManager *layoutManager;
	NSRect visibleRect;
	NSRange visibleRange;
	NSString *textString;
	NSString *searchString;
	
	NSInteger index;
	NSInteger lineNumber;
	
	NSInteger indexNonWrap;
	NSInteger maxRangeVisibleRange;
	NSInteger numberOfGlyphsInTextString;
	BOOL oneMoreTime;
	unichar lastGlyph;
	
	NSRange range;
	NSInteger widthOfStringInGutter;
	NSInteger gutterWidth;
	NSRect currentViewBounds;
	NSInteger gutterY;
	
	NSInteger currentLineHeight;
	
	CGFloat addToScrollPoint;
    
	//textView
    
	JBNAsciiTextView * textView;
	
}

- (id)initWithView:(id)doc;
- (void)updateLineNumbersCheckWidth:(BOOL)checkWidth;
- (void)updateLineNumbersForClipView:(NSClipView *)clipView checkWidth:(BOOL)checkWidth;

@end
