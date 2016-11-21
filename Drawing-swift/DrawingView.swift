//
//  DrawingView.swift
//  Drawing-swift
//
//  Created by Han Chen on 2016/11/21.
//  Copyright © 2016年 Han Chen. All rights reserved.
//

// https://code.tutsplus.com/tutorials/smooth-freehand-drawing-on-ios--mobile-13164

import Foundation
import UIKit

class DrawingView: UIView {
  
  @IBInspectable var lineWidth: CGFloat = 8.0
  
  private var path: UIBezierPath!
  private var incremental_Image: UIImage!
  private var points = [CGPoint?](repeating: nil, count: 5) // we now need to keep track of the four points of a Bezier segment and the first control point of the next segment
  private var index: Int = 0
  
  func clear() {
    incremental_Image = nil
    setNeedsDisplay()
  }
  
  override func awakeFromNib() {
    isMultipleTouchEnabled = false
    backgroundColor = backgroundColor ?? UIColor.white
    path = UIBezierPath()
    path.lineCapStyle = .round
    path.lineWidth = lineWidth
  }
  
  // Only override drawRect: if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func draw(_ rect: CGRect) {
    if incremental_Image != nil {
      incremental_Image.draw(in: rect)
    }
    path.stroke()
  }
  
  private func drawBitmap() {
    UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
    if incremental_Image == nil {
      let rectPath = UIBezierPath(rect: bounds)
      backgroundColor!.setFill()
      rectPath.fill()
    } else {
      incremental_Image.draw(at: CGPoint.zero)
    }
    UIColor.black.setStroke()
    path.stroke()
    incremental_Image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard touches.first != nil else {
      return
    }
    let point = touches.first?.location(in: self)
    index = 0
    points[index] = point
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard touches.first != nil else {
      return
    }
    let point = touches.first?.location(in: self)
    index += 1
    points[index] = point
    if index == points.count - 1 {
      points[3] = CGPoint(x: (points[2]!.x + points[4]!.x) / 2.0,
                          y: (points[2]!.y + points[4]!.y) / 2.0)
      path.move(to: points[0]!)
      path.addCurve(to: points[3]!, controlPoint1: points[1]!, controlPoint2: points[2]!)
      self.setNeedsDisplay()
      points[0] = points[3]
      points[1] = points[4]
      index = 1
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard touches.first != nil else {
      return
    }
    drawBitmap()
    self.setNeedsDisplay()
    path.removeAllPoints()
    index = 0
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    touchesEnded(touches, with: event)
  }
}
