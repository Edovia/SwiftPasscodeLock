//
//  PasscodeLockPresenter.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/29/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

public class PasscodeLockPresenter {
    
    private var mainWindow: UIWindow?
    private var passcodeLockWindow: UIWindow?
    
    private let passcodeConfiguration: PasscodeLockConfigurationType
    public var isPasscodePresented = false
    public let passcodeLockVC: PasscodeLockViewController
    
    public init(mainWindow window: UIWindow?, configuration: PasscodeLockConfigurationType, viewController: PasscodeLockViewController) {
        
        mainWindow = window
        mainWindow?.windowLevel = UIWindow.Level(rawValue: 1)
        passcodeConfiguration = configuration
        
        passcodeLockVC = viewController
    }

    public convenience init(mainWindow window: UIWindow?, configuration: PasscodeLockConfigurationType) {
        
        let passcodeLockVC = PasscodeLockViewController(state: .enterPasscode, configuration: configuration)
        
        self.init(mainWindow: window, configuration: configuration, viewController: passcodeLockVC)
    }
    
    public func presentPasscodeLock(_ completion: (() -> Void)?) {
        
        guard passcodeConfiguration.repository.hasPasscode else { return }
        guard !isPasscodePresented else { return }
        
        isPasscodePresented = true
        
        self.passcodeLockWindow = UIWindow(frame: UIScreen.main.bounds)
        self.passcodeLockWindow?.windowLevel = UIWindow.Level(rawValue: 0)
        self.passcodeLockWindow?.makeKeyAndVisible()
        
        self.passcodeLockWindow?.windowLevel = UIWindow.Level(rawValue: 2)
        self.passcodeLockWindow?.isHidden = false
        
        mainWindow?.windowLevel = UIWindow.Level(rawValue: 1)
        mainWindow?.endEditing(true)
        
        let passcodeLockVC = PasscodeLockViewController(state: .enterPasscode, configuration: passcodeConfiguration)
        let userDismissCompletionCallback = passcodeLockVC.dismissCompletionCallback
        
        passcodeLockVC.dismissCompletionCallback = { [weak self] in
            
            userDismissCompletionCallback?()
            
            self?.dismissPasscodeLock()
            
            completion?()
        }
        
        self.passcodeLockWindow?.rootViewController = passcodeLockVC
    }
    
    public func dismissPasscodeLock(animated: Bool = true) {
        
        isPasscodePresented = false
        mainWindow?.windowLevel = UIWindow.Level(rawValue: 1)
        mainWindow?.makeKeyAndVisible()
        
        if animated {
        
            animatePasscodeLockDismissal()
            
        } else {
            
            self.passcodeLockWindow?.windowLevel = UIWindow.Level(rawValue: 0)
            self.passcodeLockWindow?.rootViewController = nil
            self.passcodeLockWindow = nil
        }
    }
    
    internal func animatePasscodeLockDismissal() {
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: UIView.AnimationOptions(),
            animations: { [weak self] in
                
                self?.passcodeLockWindow?.alpha = 0
            },
            completion: { [weak self] _ in
                
                self?.passcodeLockWindow?.windowLevel = UIWindow.Level(rawValue: 0)
                self?.passcodeLockWindow?.rootViewController = nil
                self?.passcodeLockWindow?.alpha = 1
                self?.passcodeLockWindow = nil
            }
        )
    }
}
