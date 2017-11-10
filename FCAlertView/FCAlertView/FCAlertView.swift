//
//  FCAlertView.swift
//  FCAlertView
//
//  Created by Kris Penney on 2016-08-26.
//  Copyright © 2016 Kris Penney. All rights reserved.
//

import UIKit

public enum FCAlertType {
  case caution
  case success
  case warning
}

public class FCAlertView: UIView {
  
  var defaultHeight: CGFloat = 200
  var defaultSpacing: CGFloat = 105
  
  var alertView: UIView?
  var alertViewContents: UIView?
  let circleLayer: CAShapeLayer = {
    let circle = CAShapeLayer()
    circle.fillColor = UIColor.whiteColor().CGColor
    return circle
  }()
  
  var buttonTitles: [String]?
  var alertViewWithVector = 0
  var doneTitle: String?
  var vectorImage: UIImage?
  
  var firstRun = true
  
  //Delegate
  public var delegate: FCAlertViewDelegate?
  
  //AlertView Title & Subtitle Text
  var title: String?
  var subTitle: String = "You need to have a title or subtitle to use FCAlertView 😀"
  
  // AlertView Background : Probably take frame out & make it constant
  let alertBackground: UIView = {
    let alertBackgroundView = UIView()
    alertBackgroundView.backgroundColor = UIColor(white: 0, alpha: 0.35)
    
    return alertBackgroundView
  }()
  
  // AlertView Customizations
  var numberOfButtons = 0
  public var autoHideSeconds = 0
  public var cornerRadius: CGFloat = 18
  
  public var dismissOnOutsideTouch = false
  public var hideAllButtons = false
  public var hideDoneButton = false
  
  // Color Schemes
  public var colorScheme: UIColor?
  public var titleColor: UIColor = .blackColor()
  public var subTitleColor: UIColor = .blackColor()
  
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    firstRun = true
    
    backgroundColor = .clearColor()
    
    addSubview(alertBackground)
    
    checkCustomizationValid()
  }
  
  // Default Init
  public convenience init() {
    
    let result = UIScreen.mainScreen().bounds.size
    
    let frame = CGRectMake(0, 0, result.width, result.height)
    
    self.init(frame: frame)
    
  }
  
  // Initialize with a default theme
  public convenience init(type: FCAlertType){
    let result = UIScreen.mainScreen().bounds.size
    
    let frame = CGRectMake(0, 0, result.width, result.height)
    self.init(frame: frame)
    
    switch type {
    case .caution:
      makeAlertTypeCaution()
    case .success:
      makeAlertTypeSuccess()
    case .warning:
      makeAlertTypeWarning()
    }
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Customization Data Checkpoint
  private func checkCustomizationValid(){
    if (title == nil || title!.isEmpty) &&
      subTitle.isEmpty {
      subTitle = "You need to have a title or subtitle to use FCAlertView 😀"
    }
    
    if (doneTitle == nil || doneTitle!.isEmpty){
      doneTitle = "Ok"
    }
    
    if cornerRadius == 0 {
      cornerRadius = 18
    }
    
    if vectorImage != nil {
      alertViewWithVector = 1
    }
  }
  
  // MARK: Touch Events
  override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let touch = touches.first {
      let touchPoint = touch.locationInView(alertBackground)
      let touchPoint2 = touch.locationInView(alertViewContents)
      
      let isPointInsideBackview = alertBackground.pointInside(touchPoint, withEvent: nil)
      let isPointInsideAlertView = alertViewContents!.pointInside(touchPoint2, withEvent: nil)
      
      if dismissOnOutsideTouch && isPointInsideBackview && !isPointInsideAlertView {
        dismissAlertView()
      }
    }
  }
  
  // MARK: Drawing AlertView
  private func setupAlertViewFrame() -> CGRect {
    let result = UIScreen.mainScreen().bounds.size
    var alertViewFrame: CGRect

    alertBackground.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
    
    //  Adjusting AlertView Frames
    if alertViewWithVector == 1 {
      alertViewFrame = CGRectMake(self.frame.size.width/2 - ((result.width - defaultSpacing)/2),
                                  self.frame.size.height/2 - (200.0/2),
                                  result.width - defaultSpacing,
                                  defaultHeight)
    }else{
      alertViewFrame = CGRectMake(self.frame.size.width/2 - ((result.width - defaultSpacing)/2),
                                  self.frame.size.height/2 - (170.0/2),
                                  result.width - defaultSpacing,
                                  defaultHeight - 30)
    }
    
    //  Frames for when AlertView doesn't contain a title
    if title == nil {
      alertViewFrame = CGRectMake(self.frame.size.width/2 - ((result.width - defaultSpacing)/2),
                                  self.frame.size.height/2 - ((alertViewFrame.size.height - 50)/2),
                                  result.width - defaultSpacing,
                                  alertViewFrame.size.height - 10)
    }
    
    //  Frames for when AlertView has hidden all buttons
    if hideAllButtons {
      alertViewFrame = CGRectMake(self.frame.size.width/2 - ((result.width - defaultSpacing)/2),
                                  self.frame.size.height/2 - ((alertViewFrame.size.height - 50)/2), result.width - defaultSpacing,
                                  alertViewFrame.size.height - 45)
    } else{
      
      // Frames for when AlertView has hidden the DONE/DISMISS button
      if hideDoneButton && numberOfButtons == 0 {
        alertViewFrame = CGRectMake(self.frame.size.width/2 - ((result.width - defaultSpacing)/2),
                                    self.frame.size.height/2 - ((alertViewFrame.size.height - 50)/2), result.width - defaultSpacing,
                                    alertViewFrame.size.height - 45)
      }
      
      // Frames for AlertView with 2 added buttons (vertical buttons)
      if !hideDoneButton && numberOfButtons >= 2 {
        alertViewFrame = CGRectMake(self.frame.size.width/2 - ((result.width - defaultSpacing)/2),
                                    self.frame.size.height/2 - ((alertViewFrame.size.height - 50 + 140)/2), result.width - defaultSpacing,
                                    alertViewFrame.size.height - 50 + 140)
      }
    }
    return alertViewFrame
  }
  
  private func renderCircleCutout(withAlertViewFrame alertViewFrame: CGRect){
    let radius = alertView!.frame.size.width
    let rectPath = UIBezierPath(roundedRect: CGRectMake(0,
      0,
      frame.size.width,
      alertView!.frame.size.height),
                                cornerRadius: 0)
    let circlePath = UIBezierPath(roundedRect: CGRectMake(alertViewFrame.size.width/2 - 33.75,
      -33.75,
      67.5,
      67.5),
                                  cornerRadius: radius)
    
    rectPath.appendPath(circlePath)
    rectPath.usesEvenOddFillRule = true
    
    let fillLayer = CAShapeLayer()
    fillLayer.path = rectPath.CGPath
    fillLayer.fillRule = kCAFillRuleEvenOdd
    fillLayer.fillColor = UIColor.whiteColor().CGColor
    fillLayer.opacity = 1
    
    alertView!.layer.addSublayer(fillLayer)
  }
  
  private func renderHeader(withAlertViewFrame alertViewFrame: CGRect){

    let titleLabel = UILabel(frame: CGRectMake(15.0,
      20.0 + CGFloat(alertViewWithVector * 30),
      alertViewFrame.size.width - 30.0,
      20.0))
    titleLabel.font = UIFont.systemFontOfSize(18, weight: UIFontWeightMedium)
    titleLabel.numberOfLines = 1
    titleLabel.textColor = titleColor
    titleLabel.text = title
    titleLabel.textAlignment = .Center
    
    let descriptionLevel = (title == nil) ? 25 : 45
    
    let descriptionLabel = UILabel(frame: CGRectMake(25.0,
      CGFloat(descriptionLevel + alertViewWithVector * 30),
      alertViewFrame.size.width - 50.0,
      60.0))
    descriptionLabel.font = (title == nil) ? UIFont.systemFontOfSize(16, weight: UIFontWeightRegular) :
      UIFont.systemFontOfSize(15, weight: UIFontWeightLight)
    
    descriptionLabel.numberOfLines = 4
    descriptionLabel.textColor = subTitleColor
    descriptionLabel.text = subTitle
    descriptionLabel.textAlignment = .Center
    descriptionLabel.adjustsFontSizeToFitWidth = true
    
    //  Separator Line - Separating Header View with Button View
    let separatorLineView = UIView(frame: CGRectMake(0,
      alertViewFrame.size.height - 47,
      alertViewFrame.size.width,
      2))
    separatorLineView.backgroundColor = UIColor(white: 100/255, alpha: 1)
    
    let blurEffect = UIBlurEffect(style: .ExtraLight)
    
    let visualEffectView = UIVisualEffectView(effect: blurEffect)
    visualEffectView.frame = separatorLineView.bounds
    visualEffectView.userInteractionEnabled = false
    
    separatorLineView.addSubview(visualEffectView)
    
    //  Adding Contents - Conteained in Header and Separator Views
    alertViewContents!.addSubview(titleLabel)
    alertViewContents!.addSubview(descriptionLabel)
    
//     numberOfButtons == 1 && !hideDoneButton &&
    if !hideAllButtons {
      alertViewContents!.addSubview(separatorLineView)
    }
  }
  
  override public func drawRect(rect: CGRect) {
    
    alpha = 0
    
    let alertViewFrame = setupAlertViewFrame()
    
    //  Setting up contents of AlertView
    alertViewContents = UIView(frame: alertViewFrame)
    alertViewContents!.backgroundColor = .clearColor()
    addSubview(alertViewContents!)
    
    alertView = UIView(frame: CGRectMake(0, 0, alertViewFrame.size.width, alertViewFrame.size.height))
    
    //  Setting Background Color of AlertView
    if alertViewWithVector == 1 {
      alertView!.backgroundColor = .clearColor()
    }else{
      alertView!.backgroundColor = .whiteColor()
    }
    
    alertViewContents!.addSubview(alertView!)
    
    // CREATING ALERTVIEW
    // CUSTOM SHAPING - Displaying Cut out circle for Vector Type Alerts
    
    if alertViewWithVector == 1 {
      renderCircleCutout(withAlertViewFrame: alertViewFrame)
    }
    
    //  HEADER VIEW - With Title & Subtitle
    renderHeader(withAlertViewFrame: alertViewFrame)
    
    //  Button(s) View - Section containing all Buttons
    
    // View only contains DONE/DISMISS Button
    if(!hideAllButtons && !hideDoneButton && numberOfButtons == 0) {
      let doneButton = UIButton(type: .System)
      if let colorScheme = self.colorScheme {
        doneButton.backgroundColor = colorScheme
        doneButton.tintColor = .whiteColor()
      }else{
        doneButton.backgroundColor = .whiteColor()
      }
      
      doneButton.frame = CGRectMake(0,
                                    alertViewFrame.size.height - 45,
                                    alertViewFrame.size.width,
                                    45)
      doneButton.setTitle(doneTitle, forState: .Normal)
      doneButton.addTarget(self, action: #selector(donePressed(_:)), forControlEvents: .TouchUpInside)
      doneButton.titleLabel!.font = UIFont.systemFontOfSize(18, weight: UIFontWeightMedium)
      
      
      alertView!.addSubview(doneButton)
    }
    else if !hideAllButtons && numberOfButtons == 1 { // View also contains OTHER (One) Button
      
      // Render user button
      let otherButton = UIButton(type: .System)
      otherButton.backgroundColor = .whiteColor()
      
      otherButton.setTitle(buttonTitles![0], forState: .Normal)
      otherButton.addTarget(self, action: #selector(handleButton(_:)), forControlEvents: .TouchUpInside)
      otherButton.titleLabel?.font = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
      otherButton.tintColor = colorScheme
      otherButton.titleLabel?.adjustsFontSizeToFitWidth = true
      otherButton.titleLabel?.minimumScaleFactor = 0.8

      
      if !hideDoneButton {
        
        otherButton.frame = CGRectMake(0,
                                       alertViewFrame.size.height - 45,
                                       alertViewFrame.size.width/2,
                                       45)
        
        //Render Done buttons
        let doneButton = UIButton(type: .System)
        
        if let colorScheme = self.colorScheme {
          doneButton.backgroundColor = colorScheme
          doneButton.tintColor = .whiteColor()
        }else{
          doneButton.backgroundColor = .whiteColor()
        }
        
        doneButton.frame = CGRectMake(alertViewFrame.size.width/2,
                                      alertViewFrame.size.height - 45,
                                      alertViewFrame.size.width/2,
                                      45)
        doneButton.setTitle(doneTitle, forState: .Normal)
        doneButton.addTarget(self, action: #selector(donePressed(_:)), forControlEvents: .TouchUpInside)
        doneButton.titleLabel?.font = UIFont.systemFontOfSize(16, weight: UIFontWeightMedium)
        
        let horizontalSeparator = UIView(frame: CGRectMake(alertViewFrame.size.width/2 - 1,
          otherButton.frame.origin.y - 2,
          2,
          45))
        horizontalSeparator.backgroundColor = UIColor(white: 100/255, alpha: 1)
        
        let blurEffect = UIBlurEffect(style: .ExtraLight)
        
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = horizontalSeparator.bounds
        visualEffectView.userInteractionEnabled = false
        horizontalSeparator.addSubview(visualEffectView)
        
        alertView!.addSubview(doneButton)
        alertView!.addSubview(horizontalSeparator)
      }else{
        otherButton.frame = CGRectMake(0,
                                       alertViewFrame.size.height - 45,
                                       alertViewFrame.size.width,
                                       45)
      }
      
      alertView!.addSubview(otherButton)
      
    }else if(!hideAllButtons && numberOfButtons >= 2){
      let firstButton = UIButton(type: .System)
      firstButton.backgroundColor = .whiteColor()
      
      if hideDoneButton {
        firstButton.frame = CGRectMake(0,
                                       alertViewFrame.size.height - 45,
                                       alertViewFrame.size.width/2,
                                       45)
      }else {
        firstButton.frame = CGRectMake(0,
                                       alertViewFrame.size.height - 135,
                                       alertViewFrame.size.width,
                                       45)
      }
      
      firstButton.setTitle(buttonTitles![0], forState: .Normal)
      firstButton.addTarget(self, action: #selector(handleButton(_:)), forControlEvents: .TouchUpInside)
      firstButton.titleLabel?.font = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
      firstButton.tintColor = colorScheme
      firstButton.titleLabel?.adjustsFontSizeToFitWidth = true
      firstButton.titleLabel?.minimumScaleFactor = 0.8
      firstButton.tag = 0
      
      let secondButton = UIButton(type: .System)
      secondButton.backgroundColor = .whiteColor()
      secondButton.setTitle(buttonTitles![1], forState: .Normal)
      secondButton.addTarget(self, action: #selector(handleButton(_:)), forControlEvents: .TouchUpInside)
      secondButton.titleLabel?.font = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
      secondButton.tintColor = colorScheme
      secondButton.titleLabel?.adjustsFontSizeToFitWidth = true
      secondButton.titleLabel?.minimumScaleFactor = 0.8
      secondButton.tag = 0
      
      let firstSeparator = UIView(frame: CGRectMake(0,
        firstButton.frame.origin.y - 2,
        alertViewFrame.size.width,
        2))
      firstSeparator.backgroundColor = UIColor(white: 100/255, alpha: 1)
      
      let secondSeparator = UIView(frame: CGRectMake(0, 0, 0, 0))
      secondSeparator.backgroundColor = UIColor(white: 100/255, alpha: 1)
      
      let blurEffect = UIBlurEffect(style: .ExtraLight)
      
      let visualEffectView = UIVisualEffectView(effect: blurEffect)
      visualEffectView.frame = firstSeparator.bounds
      visualEffectView.userInteractionEnabled = false
      firstSeparator.addSubview(visualEffectView)
      
      let visualEffectView2 = UIVisualEffectView(effect: blurEffect)
      visualEffectView2.userInteractionEnabled = false
      secondSeparator.addSubview(visualEffectView2)
      
      if !hideDoneButton {
        secondButton.frame = CGRectMake(0,
                                        alertViewFrame.size.height - 90,
                                        alertViewFrame.size.width,
                                        45)
        secondSeparator.frame = CGRectMake(0,
                                        secondButton.frame.origin.y - 2,
                                        alertViewFrame.size.width,
                                        2)
        let doneButton = UIButton(type: .System)
        
        if let colorScheme = colorScheme {
          doneButton.backgroundColor = colorScheme
          doneButton.tintColor = .whiteColor()
        }else{
          doneButton.backgroundColor = .whiteColor()
        }
        
        doneButton.frame = CGRectMake(0,
                                      alertViewFrame.size.height - 45,
                                      alertViewFrame.size.width,
                                      45)
        doneButton.setTitle(doneTitle, forState: .Normal)
        doneButton.addTarget(self, action: #selector(donePressed(_:)), forControlEvents: .TouchUpInside)
        doneButton.titleLabel?.font = UIFont.systemFontOfSize(18, weight: UIFontWeightMedium)
        
        alertView!.addSubview(doneButton)
      }else {
        // Set proper frames for no donebutton
        secondButton.frame = CGRectMake(alertViewFrame.size.width/2,
                                        alertViewFrame.size.height - 45,
                                        alertViewFrame.size.width/2,
                                        45)
        
        secondSeparator.frame = CGRectMake(alertViewFrame.size.width/2 - 1,
                                           secondButton.frame.origin.y,
                                           2,
                                           45)
      }
      
      visualEffectView2.frame = secondSeparator.bounds
      
      
      alertView!.addSubview(firstButton)
      alertView!.addSubview(secondButton)
      alertView!.addSubview(firstSeparator)
      alertView!.addSubview(secondSeparator)
    }

    
    circleLayer.path = UIBezierPath(ovalInRect: CGRectMake(alertViewContents!.frame.size.width/2 - 30.0, -30.0, 60.0, 60.0)).CGPath
    
    
    let alertViewVector = UIButton(type: .System)
    alertViewVector.frame = CGRectMake(alertViewContents!.frame.size.width/2 - 15.0,
                                       -15.0,
                                       30.0,
                                       30.0)
    alertViewVector.setImage(vectorImage, forState: .Normal)
    alertViewVector.userInteractionEnabled = false
    alertViewVector.tintColor = colorScheme
    
    //  VIEW Border - Rounding Corners of AlertView
    alertView?.layer.cornerRadius = cornerRadius
    alertView?.clipsToBounds = true
    
    if alertViewWithVector == 1 {
      alertViewContents!.layer.addSublayer(circleLayer)
      alertViewContents!.addSubview(alertViewVector)
    }
    
    //  Scaling AlertView - Before Animation
    alertViewContents!.transform = CGAffineTransformMakeScale(1.15, 1.15)
    
    //  Applying Shadow
    layer.shadowColor = UIColor.blackColor().CGColor
    layer.shadowOpacity = 0.1
    layer.shadowRadius = 10
    layer.shadowOffset = CGSizeMake(0, 0)
    
    
    showAlertView()
  }
  
  
  // Default Types of Alerts
  private func makeAlertTypeWarning() {
    if let path = NSBundle(forClass: FCAlertView.self).pathForResource("close-round", ofType: "png") {
      setTheme(iconPath: path, tintColor: .flatRed)
    }
  }
  
  private func makeAlertTypeCaution() {
    if let path = NSBundle(forClass: FCAlertView.self).pathForResource("alert-round", ofType: "png") {
      setTheme(iconPath: path, tintColor: .flatOrange)
    }
  }
  
  private func makeAlertTypeSuccess(){
    if let path = NSBundle(forClass: FCAlertView.self).pathForResource("checkmark-round", ofType: "png") {
      setTheme(iconPath: path, tintColor: .flatGreen)
    }
  }
  
  private func setTheme(iconPath path: String, tintColor color: UIColor){
    vectorImage = UIImage(contentsOfFile: path)
    alertViewWithVector = 1
    self.colorScheme = color
  }
  
  //Presenting AlertView
  public func showAlert(inView view: UIViewController, withTitle title: String?, withSubtitle subTitle: String, withCustomImage image: UIImage?, withDoneButtonTitle done: String?, andButtons buttons: [String]?) {
    
    self.title = title
    self.subTitle = subTitle
    
    if let image = image {
      self.vectorImage = image
      alertViewWithVector = 1
    }
    
    doneTitle = done
    
    buttonTitles = buttons
    numberOfButtons = buttons?.count ?? 0
    
    checkCustomizationValid()
    view.view.window?.addSubview(self)
    
    if !firstRun {
      showAlertView()
    }else{
      firstRun = false
    }
    
  }
  
  // MARK: Showing and Hiding AlertView
  
  func showAlertView() {
    
    if let delegate = self.delegate {
      delegate.FCAlertViewWillAppear(self)
    }
    
    UIView.animateWithDuration(0.3, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseInOut, animations: {
      self.alpha = 1
      self.alertViewContents?.transform = CGAffineTransformMakeScale(1, 1)
    }) { (finished) in
      if self.autoHideSeconds != 0 {
        self.performSelector(#selector(self.dismissAlertView), withObject: nil, afterDelay: Double(self.autoHideSeconds))
      }
    }
  }
  
  // Dismissing AlertView
  public func dismissAlertView() {
    UIView.animateWithDuration(0.175, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseInOut, animations: {
      self.alpha = 0
      self.alertViewContents?.transform = CGAffineTransformMakeScale(0.9, 0.9)
    }) { (finished) in
      
      if let delegate = self.delegate {
        delegate.FCAlertViewDismissed(self)
      }
      
      self.removeFromSuperview()
    }
  }
  
  @objc private func handleButton(sender: UIButton){
    guard let delegate = delegate else {
      return
    }
    
    delegate.alertView(self, clickedButtonIndex: sender.tag, buttonTitle: sender.titleLabel!.text!)
    
    self.dismissAlertView()
  }
  
  @objc private func donePressed(sender: UIButton){
    
    if let delegate = delegate {
      delegate.FCAlertDoneButtonClicked(self)
    }
    
    self.dismissAlertView()
  }
}
