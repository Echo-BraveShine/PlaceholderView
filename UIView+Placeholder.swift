//
//  UIView + Extension.swift
//  PlaceholderView
//
//  Created by Hong Zhang on 2019/5/20.
//  Copyright © 2019 Muqiu. All rights reserved.
//

import UIKit

extension UIView {
    fileprivate struct RuntimePlaceholderKey {
        static let KPlaceholderView = UnsafeRawPointer.init(bitPattern: "KPlaceholderView".hashValue)
    }
    
    @objc var placeholderView: PlaceholderView? {
        set {
            newValue?.parentView = self
            
            objc_setAssociatedObject(self, UIView.RuntimePlaceholderKey.KPlaceholderView!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            var value =  objc_getAssociatedObject(self, UIView.RuntimePlaceholderKey.KPlaceholderView!)
            
            if value == nil {
                value = PlaceholderView()
                self.placeholderView = (value as! PlaceholderView)
            }
            
            return (value as! PlaceholderView)
        }
    }
}

extension UIScrollView {
    fileprivate struct RuntimePlaceholderKey {
        static let KShowPlaceholderView = UnsafeRawPointer.init(bitPattern: "KShowPlaceholderView".hashValue)
    }
    
    var showPlaceholderView: Bool {
        set {
            if newValue == false {
                self.placeholderView?.dismiss()
            }

            objc_setAssociatedObject(self, UIScrollView.RuntimePlaceholderKey.KShowPlaceholderView!, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        
        get {
            let value  =  objc_getAssociatedObject(self, UIScrollView.RuntimePlaceholderKey.KShowPlaceholderView!)
            
            if value == nil {
                return false
            }else{
                return (value as! Bool)
            }
        }
    }
}

extension UIScrollView {
    
    /// 调整contenSize 保证PlaceholderView能够完全展示
    fileprivate func setScrollViewContensize()  {
        
        if self.showPlaceholderView == false {
            return
        }
        
        if self.contentSize.height < self.placeholderView!.frame.size.height + self.placeholderView!.frame.origin.y{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self.contentSize = CGSize.init(width: self.contentSize.width, height: self.placeholderView!.frame.size.height + self.placeholderView!.frame.origin.y + 20)
                
            }
            
        }
        
    }
}

extension UITableView {

    static func exchangeMethod() {
        method_exchangeImplementations(class_getInstanceMethod(self.classForCoder(), #selector(reloadData))!, class_getInstanceMethod(self.classForCoder(), #selector(dd_reloadData))!)
    }

    @objc func dd_reloadData() {
        self.dd_reloadData()

        if self.showPlaceholderView == true && self.mj_totalDataCount() == 0 {
            self.placeholderView?.show()
            setScrollViewContensize()
        }else{
            self.placeholderView?.dismiss()
        }

    }
}
extension UICollectionView {

    static func exchangeMethod() {

        method_exchangeImplementations(class_getInstanceMethod(self.classForCoder(), #selector(reloadData))!, class_getInstanceMethod(self.classForCoder(), #selector(dd_reloadData))!)
    }

    @objc func dd_reloadData() {
        self.dd_reloadData()

        if self.showPlaceholderView == true && self.mj_totalDataCount() == 0 {
            self.placeholderView?.show()
            setScrollViewContensize()
        }else{
            self.placeholderView?.dismiss()
        }
    }
}
