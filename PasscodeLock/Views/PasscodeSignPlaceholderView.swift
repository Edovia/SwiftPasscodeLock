//
//  PasscodeSignPlaceholderView.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

@IBDesignable
public class PasscodeSignPlaceholderView: UIView {
    
    public enum State {
        case inactive
        case active
        case error
    }
    
    @IBInspectable
    public var inactiveColor: UIColor = UIColor.clear {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    public var activeColor: UIColor = UIColor.systemBlue {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    public var errorColor: UIColor = UIColor.systemRed {
        didSet {
            setupView()
        }
    }
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    public override var intrinsicContentSize: CGSize {
        
        return CGSize(width: 16, height: 16)
    }
    
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            self.setupView()
        }
    }
    
    private func setupView() {
        let savedTc = UITraitCollection.current
        
        UITraitCollection.current = traitCollection
        
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = activeColor.cgColor
        backgroundColor = inactiveColor
        
        UITraitCollection.current = savedTc
    }
    
    private func colorsForState(_ state: State) -> (backgroundColor: UIColor, borderColor: UIColor) {
        
        switch state {
        case .inactive: return (inactiveColor, activeColor)
        case .active: return (activeColor, activeColor)
        case .error: return (errorColor, errorColor)
        }
    }
    
    public func animateState(_ state: State) {
        
        let colors = colorsForState(state)
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                let savedTc = UITraitCollection.current
                
                UITraitCollection.current = self.traitCollection
                
                self.backgroundColor = colors.backgroundColor
                self.layer.borderColor = colors.borderColor.cgColor
                
                UITraitCollection.current = savedTc
            },
            completion: nil
        )
    }
}
