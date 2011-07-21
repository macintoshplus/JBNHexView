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
	asciiScrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(gutterWidth+hexWidth, 0, [self bounds].size.width - gutterWidth - hexWidth, [self bounds].size.height)];
	[asciiScrollView setBorderType:NSNoBorder];
	[asciiScrollView setHasVerticalScroller:YES];
	[asciiScrollView setAutohidesScrollers:NO];
	[asciiScrollView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	[[asciiScrollView contentView] setAutoresizesSubviews:YES];
	NSSize contentSize = [asciiScrollView contentSize];
	
	asciiRepresentation = [[JBNAsciiTextView alloc] initWithFrame:NSMakeRect(gutterWidth+hexWidth, 0, contentSize.width, contentSize.height)];
	[asciiScrollView setDocumentView:asciiRepresentation];
	[asciiRepresentation setMinSize:contentSize];
	[asciiScrollView setHasHorizontalScroller:NO];
	[asciiRepresentation setHorizontallyResizable:NO];
	[[asciiRepresentation textContainer] setWidthTracksTextView:YES];
	[[asciiRepresentation textContainer] setContainerSize:NSMakeSize(contentSize.width, FLT_MAX)];	
	
	//Representation HEX
	
	hexScrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(gutterWidth, 0, hexWidth, contentSize.height)];
	[hexScrollView setBorderType:NSNoBorder];
	[hexScrollView setHasVerticalScroller:NO];
	[hexScrollView setHasHorizontalScroller:NO];
	[hexScrollView setAutoresizingMask:NSViewHeightSizable];
	[[hexScrollView contentView] setAutoresizesSubviews:YES];
	
	JBNHexTextView * hexTextView = [[JBNHexTextView alloc] initWithFrame:NSMakeRect(gutterWidth, 0, hexWidth, contentSize.height - 50)];
	[hexScrollView setDocumentView:hexTextView];
	
	//Goutière des adresses
	
	gutterScrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(0, 0, gutterWidth, contentSize.height)];
	[gutterScrollView setBorderType:NSNoBorder];
	[gutterScrollView setHasVerticalScroller:NO];
	[gutterScrollView setHasHorizontalScroller:NO];
	[gutterScrollView setAutoresizingMask:NSViewHeightSizable];
	[[gutterScrollView contentView] setAutoresizesSubviews:YES];
	
	
	//Texte de la goutière
	JBNGutterTextView * gutterTextView = [[JBNGutterTextView alloc] initWithFrame:NSMakeRect(0, 0, gutterWidth, contentSize.height - 50)];
	[gutterScrollView setDocumentView:gutterTextView];
	
	hexAddress = [[JBNHexAddress alloc] initWithView:self];
	hexRepresentation = [[JBNHexRepresentation alloc] initWithView:self];
	
	[[NSNotificationCenter defaultCenter] addObserver:hexAddress selector:@selector(viewBoundsDidChange:) name:NSViewBoundsDidChangeNotification object:[asciiScrollView contentView]];
	[[NSNotificationCenter defaultCenter] addObserver:hexRepresentation selector:@selector(viewBoundsDidChange:) name:NSViewBoundsDidChangeNotification object:[asciiScrollView contentView]];
	
	
	[self setSubviews:[NSArray array]];
	[self addSubview:asciiScrollView];
	[self addSubview:hexScrollView];
	[self addSubview:gutterScrollView];
	
	[self addObserver:asciiRepresentation forKeyPath:@"data" options:NSKeyValueObservingOptionNew context:nil];
	[self addObserver:hexTextView forKeyPath:@"data" options:NSKeyValueObservingOptionNew context:nil];
	[self addObserver:gutterTextView forKeyPath:@"data" options:NSKeyValueObservingOptionNew context:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewFrameDidChange:) name:NSViewFrameDidChangeNotification object:[asciiScrollView contentView]];
	
	//Actualise les Nunero de ligne
	[hexAddress updateLineNumbersCheckWidth:NO];
	
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
	[data release];
	data = [ndata retain];
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
