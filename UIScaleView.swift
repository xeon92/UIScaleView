//
//  UIScaleView.swift
//  UIScaleView
//
//  Created by Xeon on 21/11/2018.
//  Copyright © 2018 Yu Tae Yeon. All rights reserved.
//

import UIKit

final class UIScaleView: UIView {
    
    private var _minimumScaleFactor: CGFloat = CGFloat(0) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    private var _maximumScaleFactor: CGFloat = CGFloat.greatestFiniteMagnitude {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    var minimumScaleFactor: CGFloat {
        set {
            guard newValue <= 1.0, newValue >= 0.0 else { return }
            self._minimumScaleFactor = newValue
        }
        
        get {
            return _minimumScaleFactor
        }
    }
    
    var maximumScaleFactor: CGFloat {
        set {
            guard newValue >= 1.0 else { return }
            self._maximumScaleFactor = newValue
        }
        
        get {
            return _maximumScaleFactor
        }
    }
    
    enum SizeFittingViewAxis {
        case horizontal
        case vertical
    }
    
    var axis: SizeFittingViewAxis = SizeFittingViewAxis.horizontal {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    weak var contentsView: UIView! {
        didSet {
            oldValue?.removeFromSuperview()
            self.addSubview(contentsView)
            self.setNeedsLayout()
        }
    }
    
    func constraintView(targetSize: CGSize) {
        
        let contentsSize: CGSize
        switch self.axis {
        case .horizontal:
            contentsSize = contentsView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: CGFloat.greatestFiniteMagnitude) )
        case .vertical:
            contentsSize = contentsView.systemLayoutSizeFitting(CGSize(width: CGFloat.greatestFiniteMagnitude, height: targetSize.height) )
        }
        
        let targetRatio: CGFloat
        switch self.axis {
        case .horizontal:
            targetRatio = targetSize.width/contentsSize.width
        case .vertical:
            targetRatio = targetSize.height/contentsSize.height
        }
        
        let constraintedRatio = min(max(self._minimumScaleFactor, targetRatio), self._maximumScaleFactor)
        
        let constraintedSize: CGSize
        switch self.axis {
        case .horizontal:
            constraintedSize = CGSize(width: targetSize.width / constraintedRatio, height: contentsSize.height)
        case .vertical:
            constraintedSize = CGSize(width: contentsSize.width, height: targetSize.height / constraintedRatio)
        }
        
        let v: CGFloat
        
        switch self.axis {
        case .horizontal:
            v = targetSize.width / constraintedSize.width
        case .vertical:
            v = targetSize.height / constraintedSize.height
        }
        
        contentsView.bounds = CGRect(origin: CGPoint.zero, size: constraintedSize)
        contentsView.center = CGPoint(x: (constraintedSize.width * v)/2, y: (constraintedSize.height * v)/2)
        contentsView.transform = CGAffineTransform(scaleX: v, y: v)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let _ = contentsView {
            self.constraintView(targetSize: self.bounds.size)
        }
        
        self.invalidateIntrinsicContentSize()
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        switch self.axis {
        case .horizontal:
            let contentsSize = contentsView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: CGFloat.greatestFiniteMagnitude) )
            let targetRatio = targetSize.width/contentsSize.width
            
            let constraintedRatio = min(max(self._minimumScaleFactor, targetRatio), self._maximumScaleFactor)
            
            return CGSize(width: targetSize.width, height: contentsSize.height * constraintedRatio)
        case .vertical:
            let contentsSize = contentsView.systemLayoutSizeFitting(CGSize(width: CGFloat.greatestFiniteMagnitude, height: targetSize.height) )
            let targetRatio = targetSize.height/contentsSize.height
            
            let constraintedRatio = min(max(self._minimumScaleFactor, targetRatio), self._maximumScaleFactor)
            
            return CGSize(width: contentsSize.width * constraintedRatio, height: targetSize.height)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return self.systemLayoutSizeFitting(bounds.size)
    }
}
