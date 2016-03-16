//
//  HorizontalPicker.swift
//  HorizontalPicker
//
//  Created by Andrew C on 2/26/16.
//  Copyright © 2016 Andrew Crookston. All rights reserved.
//

import UIKit

public protocol HorizontalPickerDelegate : class {
    func horizontalPickerOptionSelected(index: Int)
    func horizontalPickerOptionViewCount() -> Int
    func horizontalPickerOptionViewSize() -> CGSize
    func horizontalPickerOptionView(index: Int) -> HorizontalOptionView
}

public protocol HorizontalPickerOptionViewDelegate : class {
    func selectOption(index: Int)
    func selectOption(index: Int, animated: Bool)
}

public class HorizontalPicker : UIView, UIScrollViewDelegate, HorizontalPickerOptionViewDelegate {

    public var defaultPage = 0 {
        didSet { selectOption(defaultPage) }
    }

    public var visiblePages = 5 {
        willSet {
            if newValue % 2 == 0 {
                print("HorizontalPicker#visibleViews must be an odd number")
                abort()
            }
        }
        didSet { updateScrollViewFrame() }
    }
    public weak var delegate : HorizontalPickerDelegate? {
        didSet { setup() }
    }

    private var currentPage = 0
    private var previousPage : Int = -1 // Can't be same as currentPage
    private var pageWidth : CGFloat = 1

    private var scrollView : TouchPagedScrollView = { return TouchPagedScrollView(frame: CGRect.zero) }()


    // MARK: - Init / Setup

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        guard let delegate = self.delegate else { return }

        let size = delegate.horizontalPickerOptionViewSize()
        let count = delegate.horizontalPickerOptionViewCount()

        pageWidth = size.width

        updateScrollViewFrame()
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: CGFloat(count + 1) * size.width, height: size.height)
        print("size", visiblePages, scrollView.frame, scrollView.contentSize)

        for ix in 0...count {
            let view = delegate.horizontalPickerOptionView(ix)
            view.frame = CGRect(x: CGFloat(ix) * size.width, y: 0, width: size.width, height: size.height)
            view.index = ix
            view.pickerDelegate = self
            scrollView.addSubview(view)
        }
        addSubview(scrollView)
        selectOption(defaultPage, animated: false)
//        scrollView.scrollRectToVisible(rectForOption(defaultPage), animated: false)
//        selectPage(currentPage)
    }

    override public func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        // This hittest allows the user to start scrolling from outside the scrollview's bounds.
        // ie the views next to the current page, which are outside but visible thanks to clipsToBounds.
        return pointInside(point, withEvent: event) ? scrollView : nil
    }

    private func updateScrollViewFrame() {
        scrollView.frame = CGRect(x: pageWidth * CGFloat(Int((visiblePages) / 2)), y: 0, width: pageWidth, height: self.bounds.size.height)
    }

    // MARK: - UIScrollViewDelegate

    public func scrollViewDidScroll(scrollView: UIScrollView) {
        selectPage(Int(round(scrollView.contentOffset.x / pageWidth)))
    }

    private func selectPage(page: Int) {
        if page != previousPage {
            currentPage = page

            if scrollView.subviews.count > currentPage && currentPage >= 0 {
                if let view = scrollView.subviews[currentPage] as? HorizontalOptionViewProtocol {
                    delegate?.horizontalPickerOptionSelected(currentPage)
                    view.optionSelected()
                }
            }

            let eachSide = Int(Double(visiblePages - 1) / 2.0)

            let visible = (1...eachSide).map({ i in currentPage - i }) +
                (1...eachSide).map({ i in currentPage + i })

            for i in visible {
                if i >= 0 && i < scrollView.subviews.count {
                    if let view = scrollView.subviews[i] as? HorizontalOptionViewProtocol {
                        view.optionDeselected(abs(i - currentPage))
                    }
                }
            }
            previousPage = currentPage
        }
    }

    // MARK: HorizontalPageOptionDelegate

    private func rectForOption(index: Int) -> CGRect {
        if index >= 0 && scrollView.subviews.count > index {
            return scrollView.subviews[index].frame
        }
        return CGRect.zero
    }

    public func selectOption(index: Int) {
        selectOption(index, animated: true)
    }

    public func selectOption(index: Int, animated: Bool) {
        scrollView.scrollRectToVisible(rectForOption(index), animated: animated)
        selectPage(currentPage)
    }
}
