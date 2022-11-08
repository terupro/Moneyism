//
//  Extensions.swift
//  Moneyism (iOS)
//
//  Created by Teruya Hasegawa on 22/05/22.
//

import SwiftUI

extension Date {
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
}

extension ObservableObject{
    // MARK: Alert TF
    func alertTF(title: String,message: String,hintText: String,primaryTitle: String,secondaryTitle: String,primaryAction: @escaping (String)->(),secondaryAction: @escaping ()->()){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = hintText
        }
        
        alert.addAction(.init(title: secondaryTitle, style: .cancel, handler: { _ in
            secondaryAction()
        }))
        
        alert.addAction(.init(title: primaryTitle, style: .default, handler: { _ in
            if let text = alert.textFields?[0].text{
                primaryAction(text)
            }
            else{
                primaryAction("")
            }
        }))
        
        // MARK: Presenting Alert
        rootController().present(alert, animated: true, completion: nil)
    }
    
    // MARK: Root View Controller
    func rootController()->UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else{
            return .init()
        }
        
        return root
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
