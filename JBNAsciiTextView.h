//
//  JBNAsciiTextView.h
//  HexView
//
//  Created by Jean-Baptiste Nahan on 23/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class HexView;

@interface JBNAsciiTextView : NSTextView {
	int lineHeight;
	float charWidth;
	float width;
	int nbChar;
	int nbLine;
	NSDictionary *attributes;
}

- (BOOL)isPrintableChar:(unichar)caratere;
- (NSRange)convertedSelectedRange;
- (NSRange)convertedRange:(NSRange)range;
- (void)refreshContent:(id)object;

- (int)getNbCharByLine;
- (int)getNbLine;
- (int)lineHeight;

@end
