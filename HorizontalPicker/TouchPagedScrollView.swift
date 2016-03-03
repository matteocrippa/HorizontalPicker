//
//  TouchPagedScrollView.swift
//  HorizontalPicker
//
//  Created by Andrew C on 2/26/16.
//  Copyright © 2016 Andrew Crookston. All rights reserved.
//

import UIKit

class TouchPagedScrollView: UIScrollView {

    var tapGesture : UITapGestureRecognizer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    deinit {
        if tapGesture != nil {
            removeGestureRecognizer(tapGesture!)
            tapGesture = nil
        }
    }

    func setup() {
        tapGesture = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        addGestureRecognizer(tapGesture!)
    }

    func handleTap(tap: UITapGestureRecognizer) {

        let point = tap.locationInView(self)

        for view in subviews {
            let viewRect = convertRect(view.frame, toView: self)
            if CGRectContainsPoint(viewRect, point) {
                if let optionView = view as? HorizontalOptionView {
                    optionView.optionTapped()
                }
                break
            }
        }
    }
}
