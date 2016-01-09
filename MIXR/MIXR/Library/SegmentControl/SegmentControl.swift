

import Foundation
import UIKit

//Segment view allows an assortment of button objects to bring an effect of
//the standard UI Kit segmented control. Note that this is not an in place
//replacement to that of standard control. Instead, visually it provides similar
//functionality and much more customization with respect to the appearance.

@IBDesignable
class SegmentControl : UIControl {

  var segments : [UIButton] = []

  //MARK: Configurable properties
  //Border encompassing the segment view
  @IBInspectable var borderWidth: CGFloat = 2 {
    didSet {
      layer.borderWidth = borderWidth
      updateButtonStatus()
    }
  }

  //Border color
  @IBInspectable
  var borderColor: UIColor? = UIColor.redColor(){
    didSet {
      layer.borderColor = borderColor?.CGColor
    }
  }

  //Number of segments in the segment view
  @IBInspectable var segmentCount : Int = 1{
    didSet {

      //Remove all currently added segment buttons
      for button in segments {
        button.removeFromSuperview()
      }
      segments.removeAll()

      for index in 0..<segmentCount {
        let button = buttonForIndex(index)
        addSubview(button)
        segments.append(button)
      }

      updateButtonStatus()
    }
  }

  //The color of the selected segment
  @IBInspectable var segmentSelectedColor : UIColor = UIColor.redColor() {
    didSet {
      updateButtonStatus()
    }
  }

  //Color of the segment when the segment is deselected
  @IBInspectable var normalSegmentColor : UIColor = UIColor.whiteColor() {
    didSet {
      updateButtonStatus()
    }
  }

  //Color of text when the segment is selected
  @IBInspectable var selectedTextColor : UIColor = UIColor.whiteColor() {
    didSet {
      updateButtonStatus()
    }
  }

  //Normal text color
  @IBInspectable var normalTextColor : UIColor = UIColor.blackColor() {
    didSet {
      updateButtonStatus()
    }
  }

  //Highlight Text color when user is trying to select
  @IBInspectable var highlightTextColor : UIColor = UIColor.grayColor() {
    didSet {
      updateButtonStatus()
    }
  }

  //Index of currently selected index.
  @IBInspectable var selectedIndex : Int = 0 {
    didSet {
      updateButtonStatus()
    }
  }

  //This is a trick used to enable setting the title of independent segments in one go
  //from within interface builder. Suppose you have 3 segments and their titles are
  //'One', 'Two', 'Three', then you will need to supply "One|Two|Three" as the concatenated text
  @IBInspectable var concatenatedTitle: String = "Segment0" {
    didSet{
      setIndividualTitlesFromConcatenatedTitle()
    }
  }

  //Title font
//  var titleFont:UIFont = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1) {
    
    var titleFont:UIFont = UIFont(name: "ForgottenFuturistRg-Regular", size: 18)! {
    didSet{
      updateButtonStatus()
    }
  }

  //MARK: Helper methods

  func setIndividualTitlesFromConcatenatedTitle() {

    let individualTitles = concatenatedTitle.componentsSeparatedByString("|")
    var index = 0
    for button in segments {
      if button.tag < individualTitles.count {
         button.setTitle(individualTitles[index++], forState: UIControlState.Normal)
        button.titleLabel?.font = titleFont
      }
    }
  }

  func buttonForIndex(index: Int) -> UIButton {

    let button =  UIButton(type:UIButtonType.Custom)

    button.setTitle("Segment\(index)", forState: UIControlState.Normal)
    button.setTitleColor(highlightTextColor, forState: UIControlState.Highlighted)
    button.tag = index

    //Set button frame
    button.frame = segmentFrameForIndex(index)

    button.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchUpInside)

    return button

  }

  func segmentFrameForIndex(index : Int) -> CGRect {
    let width = (frame.width - borderWidth * 2 ) / CGFloat(segmentCount)
    let height = frame.height - borderWidth * 2
    let x = borderWidth + CGFloat(index) * width
    let y = borderWidth

    return CGRect(x: x, y: y, width: width, height: height)

  }

  func updateButtonStatus() {
    for button in segments {
      if(selectedIndex == button.tag) {
        button.backgroundColor = segmentSelectedColor
        button.setTitleColor(selectedTextColor, forState: UIControlState.Normal)
      }else {
        button.backgroundColor = normalSegmentColor
        button.setTitleColor(normalTextColor, forState: UIControlState.Normal)
      }

      button.setTitleColor(highlightTextColor, forState: UIControlState.Highlighted)

      //Set frames as well
      button.frame = segmentFrameForIndex(button.tag)
    }
  }

  func buttonTapped(button:UIButton) {
    selectedIndex = button.tag
      //Fire target action
    sendActionsForControlEvents(allControlEvents())
   }

  override func layoutSubviews() {

    super.layoutSubviews()

    var index = 0
    for button in segments {
      button.frame = segmentFrameForIndex(index++)
    }
  }

  
}