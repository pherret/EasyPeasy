// The MIT License (MIT) - Copyright (c) 2016 Carlos Vidal
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import AppKit
import EasyPeasy

class FeedView: NSView {
    
    private static let headerPadding: CGFloat = 12.0

    private lazy var titleLabel: NSTextField = {
        let label = NSTextField(frame: CGRectZero)
        label.font = NSFont.boldSystemFontOfSize(14.0)
        label.textColor = NSColor.darkGrayColor()
        label.bezeled = false
        label.editable = false
        label.selectable = false
        return label
    }()
    
    private lazy var scrollView: NSScrollView = {
        let view = NSScrollView(frame: CGRectZero)
        return view
    }()
    
    private lazy var contentView: NSView = {
        let view = NSView(frame: CGRectZero)
        return view
    }()
    
    private lazy var separatorView: NSView = {
        let view = NSView(frame: CGRectZero)
        view.alphaValue = 0.4
        return view
    }()
    
    var title: String? {
        didSet {
            self.titleLabel.stringValue = self.title ?? ""
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }
    
    override func drawRect(dirtyRect: NSRect) {
        NSColor.whiteColor().setFill()
        NSRectFill(dirtyRect)
        super.drawRect(dirtyRect)
    }
    
    override func layout() {
        super.layout()
        
        self.separatorView.layer?.backgroundColor = NSColor.lightGrayColor().CGColor
    }
    
    // MARK: Public methods
    
    func configure(with tweets: [TweetModel]) {
        var priority = 500 - Float(tweets.count)
        var previousItem: NSView = self.contentView
        // Creates a tweetView for every tweet model within tweets array
        for tweet in tweets {
            let tweetView = TweetView(frame: CGRectZero)
            tweetView.configure(with: tweet)
            
            // Layout "cells"
            self.contentView.addSubview(tweetView)
            tweetView <- [
                Top(0.0).to(previousItem),
                Left(0.0),
                Right(0.0),
                Height(>=TweetView.minimumHeight)
            ]
            
            // Pins contentView to bottom of the this item
            self.contentView <- [
                Bottom(>=0.0).to(tweetView, .Bottom).with(.CustomPriority(priority))
            ]
            
            // Set properties that apply to next tweetview creation
            previousItem = tweetView
            priority += 1.0
        }
    }
    
}

/**
    Autolayout constraints
 */
extension FeedView {
    
    private func setup() {
        // Title header
        self.addSubview(self.titleLabel)
        self.titleLabel <- [
            Top(FeedView.headerPadding),
            Size(>=0.0),
            CenterX(0.0)
        ]
        
        // Separator beneath title
        self.addSubview(self.separatorView)
        self.separatorView <- [
            Top(FeedView.headerPadding).to(self.titleLabel),
            Left(0.0),
            Right(0.0),
            Height(1.0)
        ]
        
        // Scroll view
        self.addSubview(self.scrollView)
        self.scrollView <- [
            Top(0.0).to(self.separatorView),
            Left(0.0),
            Right(0.0),
            Bottom(0.0)
        ]
        
        // Content of the scroll
        self.scrollView.documentView = self.contentView
        self.contentView <- [
            Top(0.0),
            Left(0.0),
            Bottom(>=0.0),
            Width(0.0).like(self.scrollView),
            Height(>=0.0)
        ]
        
        
        self.scrollView.contentSize
    }
    
}
