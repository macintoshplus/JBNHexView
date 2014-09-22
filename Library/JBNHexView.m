//
//  JBNHexView.m
//  HexView
//
//  Created by Jean-Baptiste Nahan on 23/09/10.
//  Copyright 2010-2014 Jean-Baptiste Nahan. All rights reserved.
//

#import "JBNHexView.h"

@implementation JBNHexView

@synthesize hexAddress;
@synthesize hexRepresentation;
@synthesize gutterScrollView;
@synthesize hexScrollView;
@synthesize asciiScrollView;
@synthesize asciiRepresentation;
@synthesize data;
@synthesize gutterWidth;
@synthesize hexWidth;


- (id)initWithFrame:(NSRect)frame{
	if(self=[super initWithFrame:frame]){
		data = [[NSData alloc] init];
		gutterWidth=60;
		hexWidth=120;
		
	}
	return self;
}

- (void)awakeFromNib{
	//Calcul de la largeur de la représentation hexa
	//NSLog(@"Largeur : %f, goutière : %f, reste : %f", [self bounds].size.width, (float)gutterWidth, (float)[self bounds].size.width-gutterWidth);
	hexWidth=((([self bounds].size.width - gutterWidth - 20)/4)*3);
	
	//NSLog(@"HexView = %@",self);
	//Init des scrols view et représentation
	
	//Représentation ASCII
    NSRect rect  =NSMakeRect(gutterWidth+hexWidth, 0, [self bounds].size.width - gutterWidth - hexWidth, [self bounds].size.height);
	self.asciiScrollView = [[NSScrollView alloc] initWithFrame:rect ];
	[self.asciiScrollView setBorderType:NSNoBorder];
	[self.asciiScrollView setHasVerticalScroller:YES];
	[self.asciiScrollView setAutohidesScrollers:NO];
	[self.asciiScrollView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	[[self.asciiScrollView contentView] setAutoresizesSubviews:YES];
	NSSize contentSize = [self.asciiScrollView contentSize];
	
	self.asciiRepresentation = [[JBNAsciiTextView alloc] initWithFrame:NSMakeRect(gutterWidth+hexWidth, 0, contentSize.width, contentSize.height)];
	[self.asciiScrollView setDocumentView:asciiRepresentation];
	[self.asciiRepresentation setMinSize:contentSize];
	[self.asciiScrollView setHasHorizontalScroller:NO];
	[self.asciiRepresentation setHorizontallyResizable:NO];
	[[self.asciiRepresentation textContainer] setWidthTracksTextView:YES];
	[[self.asciiRepresentation textContainer] setContainerSize:NSMakeSize(contentSize.width, FLT_MAX)];
	
	//Representation HEX
	
	self.hexScrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(gutterWidth, 0, hexWidth, contentSize.height)];
	[self.hexScrollView setBorderType:NSNoBorder];
	[self.hexScrollView setHasVerticalScroller:NO];
	[self.hexScrollView setHasHorizontalScroller:NO];
	[self.hexScrollView setAutoresizingMask:NSViewHeightSizable];
	[[self.hexScrollView contentView] setAutoresizesSubviews:YES];
	
	JBNHexTextView * hexTextView = [[JBNHexTextView alloc] initWithFrame:NSMakeRect(gutterWidth, 0, hexWidth, contentSize.height - 50)];
	[self.hexScrollView setDocumentView:hexTextView];
	
	//Goutière des adresses
	
	self.gutterScrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(0, 0, gutterWidth, contentSize.height)];
	[self.gutterScrollView setBorderType:NSNoBorder];
	[self.gutterScrollView setHasVerticalScroller:NO];
	[self.gutterScrollView setHasHorizontalScroller:NO];
	[self.gutterScrollView setAutoresizingMask:NSViewHeightSizable];
	[[self.gutterScrollView contentView] setAutoresizesSubviews:YES];
	
	
	//Texte de la goutière
	JBNGutterTextView * gutterTextView = [[JBNGutterTextView alloc] initWithFrame:NSMakeRect(0, 0, gutterWidth, contentSize.height - 50)];
	[self.gutterScrollView setDocumentView:gutterTextView];
	
	self.hexAddress = [[JBNHexAddress alloc] initWithView:self];
	self.hexRepresentation = [[JBNHexRepresentation alloc] initWithView:self];
	
	[[NSNotificationCenter defaultCenter] addObserver:self.hexAddress selector:@selector(viewBoundsDidChange:) name:NSViewBoundsDidChangeNotification object:[self.asciiScrollView contentView]];
	[[NSNotificationCenter defaultCenter] addObserver:self.hexRepresentation selector:@selector(viewBoundsDidChange:) name:NSViewBoundsDidChangeNotification object:[self.asciiScrollView contentView]];
	
	
	[self setSubviews:[NSArray array]];
	[self addSubview:self.asciiScrollView];
	[self addSubview:self.hexScrollView];
	[self addSubview:self.gutterScrollView];
	
	[self addObserver:self.asciiRepresentation forKeyPath:@"data" options:NSKeyValueObservingOptionNew context:nil];
	[self addObserver:hexTextView forKeyPath:@"data" options:NSKeyValueObservingOptionNew context:nil];
	[self addObserver:gutterTextView forKeyPath:@"data" options:NSKeyValueObservingOptionNew context:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewFrameDidChange:) name:NSViewFrameDidChangeNotification object:[self.asciiScrollView contentView]];
	
	//Actualise les Nunero de ligne
	[self.hexAddress updateLineNumbersCheckWidth:NO];
	
}

- (void)viewFrameDidChange:(NSNotification *)aNotification
{
	//NSLog(@"HexView :: viewFrameDidChange, %@", aNotification);
	//NSLog(@"Largeur = %f", [[aNotification object] frame].size.width);
	
	//Recalcule la taille des éléments
	
	hexWidth=((([self bounds].size.width - gutterWidth - 20)/4)*3);
	[hexScrollView setFrame:NSMakeRect(gutterWidth, 0, hexWidth, [self bounds].size.height)];
	
	[asciiScrollView setFrame:NSMakeRect(gutterWidth+hexWidth, 0, [self bounds].size.width - gutterWidth - hexWidth, [self bounds].size.height)];
	
	
}
- (void)setData:(NSData*)ndata{
	[self willChangeValueForKey:@"data"];
	//[data release];
	data = [ndata copy];
	[self didChangeValueForKey:@"data"];
}


- (void)drawRect:(NSRect)rect
{
	[super drawRect:rect];
	
	NSRect bounds = [self bounds]; 
	if ([self needsToDrawRect:NSMakeRect(bounds.size.width - 1, 0, 1, bounds.size.height)] == YES) {
		[[NSColor lightGrayColor] set];
		NSBezierPath *dottedLine = [NSBezierPath bezierPathWithRect:NSMakeRect(bounds.size.width, 0, 0, bounds.size.height)];
		CGFloat dash[2];
		dash[0] = 1.0;
		dash[1] = 2.0;
		[dottedLine setLineDash:dash count:2 phase:1.0];
		[dottedLine stroke];
	}
	
}

@end
