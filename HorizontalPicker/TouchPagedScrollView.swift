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
    isPagingEnabled = true
    showsHorizontalScrollIndicator = false
    clipsToBounds = false
    decelerationRate = 0.1
    tapGesture = UITapGestureRecognizer(target: self, action: Selector(("handleTap:")))
    addGestureRecognizer(tapGesture!)
  }
  
  func handleTap(tap: UITapGestureRecognizer) {
    
    let point = tap.location(in: self)
    
    for view in subviews {
      let viewRect = convert(view.frame, to: self)
      if viewRect.contains(point) {
        if let optionView = view as? HorizontalOptionView {
          optionView.optionTapped()
        }
        break
      }
    }
  }
}
