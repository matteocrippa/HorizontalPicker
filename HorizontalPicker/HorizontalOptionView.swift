//
//  HorizontalOptionView.swift
//  HorizontalPicker
//
//  Created by Andrew C on 2/26/16.
//  Copyright © 2016 Andrew Crookston. All rights reserved.
//

import UIKit

public protocol HorizontalOptionViewProtocol : class {
  func optionSelected()
  func optionDeselected(offset: Int)
}

open class HorizontalOptionView : UIView {
  var index : Int = 0
  weak var pickerDelegate : HorizontalPickerOptionViewDelegate?
  
  func optionTapped() {
    pickerDelegate?.selectOption(index: index)
  }
}
