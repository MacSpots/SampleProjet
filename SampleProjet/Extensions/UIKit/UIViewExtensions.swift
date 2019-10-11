//
//  UIViewExtensions.swift
//  SampleProjet
//
//  Created by Jason Jardim on 10/11/19.
//  Copyright © 2019 Jason Jardim. All rights reserved.
//

import Foundation
import UIKit

public enum AnimationEdge {
  case none
  case top
  case bottom
  case left
  case right
}

public extension UIView {
    func slideIn(from edge: AnimationEdge = .none,
                                     x: CGFloat = 0,
                                     y: CGFloat = 0,
                                     duration: TimeInterval = 0.4,
                                     delay: TimeInterval = 0,
                                     completion: ((Bool) -> Void)? = nil) -> UIView {
       let offset = offsetFor(edge: edge)
       transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
       isHidden = false
       UIView.animate(
         withDuration: duration, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 2,
         options: .curveEaseOut, animations: {
           self.transform = .identity
           self.alpha = 1
         }, completion: completion)
       return self
     }
    
    func slideOut(to edge: AnimationEdge = .none,
                                     x: CGFloat = 0,
                                     y: CGFloat = 0,
                                     duration: TimeInterval = 0.25,
                                     delay: TimeInterval = 0,
                                     completion: ((Bool) -> Void)? = nil) -> UIView {
      let offset = offsetFor(edge: edge)
      let endTransform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
      UIView.animate(
        withDuration: duration, delay: delay, options: .curveEaseOut, animations: {
          self.transform = endTransform
        }, completion: completion)
      return self
    }
    
    func bounceIn(from edge: AnimationEdge = .none,
                                     x: CGFloat = 0,
                                     y: CGFloat = 0,
                                     duration: TimeInterval = 0.5,
                                     delay: TimeInterval = 0,
                                     completion: ((Bool) -> Void)? = nil) -> UIView {
      let offset = offsetFor(edge: edge)
      transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
      isHidden = false
      UIView.animate(
        withDuration: duration, delay: delay, usingSpringWithDamping: 0.58, initialSpringVelocity: 3,
        options: .curveEaseOut, animations: {
          self.transform = .identity
          self.alpha = 1
        }, completion: completion)
      return self
    }
    
    func bounceOut(to edge: AnimationEdge = .none,
                                      x: CGFloat = 0,
                                      y: CGFloat = 0,
                                      duration: TimeInterval = 0.35,
                                      delay: TimeInterval = 0,
                                      completion: ((Bool) -> Void)? = nil) -> UIView {
      let offset = offsetFor(edge: edge)
      let delta = CGPoint(x: offset.x + x, y: offset.y + y)
      let endTransform = CGAffineTransform(translationX: delta.x, y: delta.y)
      let prepareTransform = CGAffineTransform(translationX: -delta.x * 0.2, y: -delta.y * 0.2)
      UIView.animateKeyframes(
        withDuration: duration, delay: delay, options: .calculationModeCubic, animations: {
          UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
            self.transform = prepareTransform
          }
          UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2) {
            self.transform = prepareTransform
          }
          UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.6) {
            self.transform = endTransform
          }
        }, completion: completion)
      return self
    }
    
    func popIn(fromScale: CGFloat = 0.5,
                                  duration: TimeInterval = 0.5,
                                  delay: TimeInterval = 0,
                                  completion: ((Bool) -> Void)? = nil) -> UIView {
      isHidden = false
      alpha = 0
      transform = CGAffineTransform(scaleX: fromScale, y: fromScale)
      UIView.animate(
        withDuration: duration, delay: delay, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
        options: .curveEaseOut, animations: {
          self.transform = .identity
          self.alpha = 1
        }, completion: completion)
      return self
    }
    
    func popOut(toScale: CGFloat = 0.5,
                                   duration: TimeInterval = 0.3,
                                   delay: TimeInterval = 0,
                                   completion: ((Bool) -> Void)? = nil) -> UIView {
      let endTransform = CGAffineTransform(scaleX: toScale, y: toScale)
      let prepareTransform = CGAffineTransform(scaleX: 1.1, y: 1.1)
      UIView.animateKeyframes(
        withDuration: duration, delay: delay, options: .calculationModeCubic, animations: {
          UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
            self.transform = prepareTransform
          }
          UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.3) {
            self.transform = prepareTransform
          }
          UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
            self.transform = endTransform
            self.alpha = 0
          }
        }, completion: completion)
      return self
    }
    
    func shake(toward edge: SimpleAnimationEdge = .none,
                                  amount: CGFloat = 0.15,
                                  duration: TimeInterval = 0.6,
                                  delay: TimeInterval = 0,
                                  completion: ((Bool) -> Void)? = nil) -> UIView {
      let steps = 8
      let timeStep = 1.0 / Double(steps)
      var dx: CGFloat, dy: CGFloat
      if edge == .left || edge == .right {
        dx = (edge == .left ? -1 : 1) * self.bounds.size.width * amount;
        dy = 0
      } else {
        dx = 0
        dy = (edge == .top ? -1 : 1) * self.bounds.size.height * amount;
      }
      UIView.animateKeyframes(
        withDuration: duration, delay: delay, options: .calculationModeCubic, animations: {
          var start = 0.0
          for i in 0..<(steps - 1) {
            UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: timeStep) {
              self.transform = CGAffineTransform(translationX: dx, y: dy)
            }
            if (edge == .none && i % 2 == 0) {
              swap(&dx, &dy)  // Change direction
              dy *= -1
            }
            dx *= -0.85
            dy *= -0.85
            start += timeStep
          }
          UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: timeStep) {
            self.transform = .identity
          }
        }, completion: completion)
      return self
    }
    
    
    private func offsetFor(edge: AnimationEdge) -> CGPoint {
      if let parentSize = self.superview?.frame.size {
        switch edge {
        case .none: return CGPoint.zero
        case .top: return CGPoint(x: 0, y: -frame.maxY)
        case .bottom: return CGPoint(x: 0, y: parentSize.height - frame.minY)
        case .left: return CGPoint(x: -frame.maxX, y: 0)
        case .right: return CGPoint(x: parentSize.width - frame.minX, y: 0)
        }
      }
      return .zero
    }
    
}

public extension UIView {

    func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
                 self.alpha = 1.0
                 }, completion: completion)
    }
     
    func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.alpha = 0.0
                }, completion: completion)
        }
    

     /// - Parameters:
     ///   - color:
     ///   - radius:
     ///   - offset:
     ///   - opacity:
     func addShadow(ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0), radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.5) {
         layer.shadowColor = color.cgColor
         layer.shadowOffset = offset
         layer.shadowRadius = radius
         layer.shadowOpacity = opacity
         layer.masksToBounds = false
     }
    
}


// MARK: - Properties
public extension UIView {

    /// Border color of view; also inspectable from Storyboard.
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            // Fix React-Native conflict issue
            guard String(describing: type(of: color)) != "__NSCFType" else { return }
            layer.borderColor = color.cgColor
        }
    }

    /// Border width of view; also inspectable from Storyboard.
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    /// Corner radius of view; also inspectable from Storyboard.
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }

    /// Height of view.
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }

    /// Check if view is in RTL format.
    var isRightToLeft: Bool {
        if #available(iOS 10.0, *, tvOS 10.0, *) {
            return effectiveUserInterfaceLayoutDirection == .rightToLeft
        } else {
            return false
        }
    }

    /// Take screenshot of view (if applicable).
    var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    /// Shadow color of view; also inspectable from Storyboard.
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }

    /// Shadow offset of view; also inspectable from Storyboard.
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    /// Shadow opacity of view; also inspectable from Storyboard.
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    /// Shadow radius of view; also inspectable from Storyboard.
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    /// Size of view.
    var size: CGSize {
        get {
            return frame.size
        }
        set {
            width = newValue.width
            height = newValue.height
        }
    }

    /// Get view's parent view controller
    var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }

    /// Width of view.
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }

    /// x origin of view.
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }

    /// y origin of view.
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
}

