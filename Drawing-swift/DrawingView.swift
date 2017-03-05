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
  
  @IBInspectable var lineWidth: CGFloat = 15.0
  
  private var path: UIBezierPath!
  private var currentPath_Array: [(UIColor, Bool, UIBezierPath)] = [] // Drawing color, isDrawing, UIBezierPath
  private var previousPath_Array: [(UIColor, Bool, UIBezierPath)] = [] // Drawing color, isDrawing, UIBezierPath
  private var isDrawing: Bool = true
  private var color: UIColor! = UIColor.black
  private var draw_Image: UIImage!
  private var points = [CGPoint?](repeating: nil, count: 5) // we now need to keep track of the four points of a Bezier segment and the first control point of the next segment
  private var index: Int = 0
  
  // MARK: - Public
  func clear() {
    draw_Image = nil
    currentPath_Array = []
    previousPath_Array = []
    setNeedsDisplay()
  }
  
  func changeColor(color: UIColor) {
    self.color = color
  }
  
  func undo() {
    guard currentPath_Array.last != nil else {
      return
    }
    previousPath_Array.append(currentPath_Array.last!)
    currentPath_Array.removeLast()
    setNeedsDisplay()
  }
  
  func redo() {
    guard previousPath_Array.last != nil else {
      return
    }
    currentPath_Array.append(previousPath_Array.last!)
    previousPath_Array.removeLast()
    setNeedsDisplay()
  }
  
  func drawOrErase(isDrawing: Bool) {
    self.isDrawing = isDrawing
  }
  
  // MARK: - Life Cycle
  override func awakeFromNib() {
    backgroundColor = UIColor.clear
    isMultipleTouchEnabled = false
  }
  
  // Only override drawRect: if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    if draw_Image != nil {
      draw_Image.draw(in: rect)
    }
    for pathProperties in currentPath_Array {
      let color = pathProperties.0
      let isDrawing = pathProperties.1
      let path = pathProperties.2
      color.setStroke()
      path.lineWidth = lineWidth
      path.lineCapStyle = .round
      path.stroke(with: isDrawing ? .normal : .clear, alpha: 1.0)
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard touches.first != nil else {
      return
    }
    path = UIBezierPath()
    previousPath_Array = []
    currentPath_Array.append((color, isDrawing, path))
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
      setNeedsDisplay()
      points[0] = points[3]
      points[1] = points[4]
      index = 1
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard touches.first != nil else {
      return
    }
    setNeedsDisplay()
    index = 0
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    touchesEnded(touches, with: event)
  }
}
