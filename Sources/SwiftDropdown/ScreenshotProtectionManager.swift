//
//  ScreenshotProtectionManager.swift
//  SwiftDropdown
//
//  Created by Prraneth on 31/10/26.
//


import UIKit
// final
public protocol ScreenshotProtectionManagerProtocol: AnyObject {
    var protectedWindow: UIWindow? { get }
    var secureTextField: UITextField? { get }
    
    func enableProtection(for window: UIWindow)
    func disableProtection()
}

public class ScreenshotProtectionManager: ScreenshotProtectionManagerProtocol {
    weak public var protectedWindow: UIWindow?
    public var secureTextField: UITextField?
    
    public init(protectedWindow: UIWindow? = nil, secureTextField: UITextField? = nil) {
        self.protectedWindow = protectedWindow
        self.secureTextField = secureTextField
    }
    
    public func enableProtection(for window: UIWindow) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            guard secureTextField == nil else { return }
            
            let field = UITextField()
            field.isSecureTextEntry = true
            
            // Create protection view with image - matching original implementation
            let protectionView = UIView(frame: CGRect(x: 0, y: 0, width: field.frame.size.width, height: field.frame.size.height))
            
            if let image = UIImage(named: "Screen_Shot_Prevented") {
                let imageView = UIImageView(image: image)
                imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                protectionView.addSubview(imageView)
            } else {
                // Fallback if image doesn't exist
                protectionView.backgroundColor = .white
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
                label.text = "Screen capture restricted"
                label.textAlignment = .center
                label.font = .systemFont(ofSize: 24, weight: .bold)
                label.textColor = .darkGray
                protectionView.addSubview(label)
            }
            
            field.leftView = protectionView
            field.leftViewMode = .always
            
            // Add field to window first (matching original)
            window.addSubview(field)
            
            // Store references
            self.protectedWindow = window
            self.secureTextField = field
            
            // The magic layer manipulation - EXACTLY matching original working code
            // Original code: window.layer.superlayer?.addSublayer(field.layer)
            // Original code: field.layer.sublayers?.last?.addSublayer(window.layer)
            window.layer.superlayer?.addSublayer(field.layer)
            field.layer.sublayers?.last?.addSublayer(window.layer)
            
            print("🔒 Screenshot protection enabled")
        }
    }
    
    public func disableProtection() {
        DispatchQueue.main.async { [weak self] in
            guard let self,
                  let field = secureTextField,
                  let window = protectedWindow else { return }
            
            // Step 1: Restore window.layer to original position
            if let superLayer = field.layer.superlayer {
                superLayer.addSublayer(window.layer)
            }
            
            // Step 2: Remove secure field layer
            field.layer.removeFromSuperlayer()
            
            // Step 3: Remove field from view hierarchy
            field.removeFromSuperview()
            
            // Step 4: Cleanup
            self.secureTextField = nil
            self.protectedWindow = nil
            
            print("🔓 Screenshot protection disabled")
        }
    }
}
