//
//  PlaceholderView.swift
//  PlaceholderView
//
//  Created by Hong Zhang on 2019/5/20.
//  Copyright © 2019 Muqiu. All rights reserved.
//

import UIKit

fileprivate let kCurrentBundle = Bundle.init(for: PlaceholderView.classForCoder())

fileprivate func currentBundleImage(imageName : String) -> UIImage {
    return UIImage.init(named: imageName, in: kCurrentBundle, compatibleWith: nil)!
}

enum PlaceholderViewMode {
    case `default`,image,text,custom
}
@objcMembers
class PlaceholderView: UIView {
   
    weak var parentView : UIView!

    var customView : UIView?
    
    var offset : CGFloat?
    
    var widthRatio : CGFloat = 0.3
    
    var mode : PlaceholderViewMode = .default
    
    var placeholder : String = "暂无数据"
    
    var placeholderImage : UIImage = currentBundleImage(imageName: "public_nodata_placeholder")
    
    lazy var imageView : UIImageView = {
        let iv = UIImageView()
        
        return iv
    }()
    
    lazy var textLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .red
        
        self.frame = CGRect.init(x: 100, y: 100, width: 100, height: 100)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func show() {
        parentView.addSubview(self)
    }
    func dismiss()  {
        self.removeFromSuperview()
    }
    
    
    func setupUI()  {
        
        
        if customView != nil {
            let height : CGFloat = (self.customView != nil) ? self.customView!.bounds.size.height : 100;
            
            if offset == nil {
                offset = (self.parentView.bounds.size.height - height)/3
            }
            
            let size = CGSize.init(width: self.parentView.bounds.size.width * widthRatio, height: height)
            
            self.frame = CGRect.init(origin: CGPoint.init(x: (self.parentView.bounds.size.width - size.width)/2, y: offset!), size: size)

            self.addSubview(self.customView!)
            self.customView?.frame = CGRect.init(x: (self.bounds.size.width - self.customView!.bounds.size.width)/2, y: 0, width: self.customView!.bounds.size.width, height: self.customView!.bounds.size.height)
            
        }else{
            
            if self.mode != .text {
                let imageRation = Float((self.placeholderImage.size.width))/Float((self.placeholderImage.size.height));
                
                self.imageView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.width/CGFloat(imageRation))
                
                self.addSubview(self.imageView)
                
                self.imageView.image = placeholderImage
            }
            
            if self.mode != .image {
                var textY : CGFloat = 0
                if self.mode == .default{
                    textY = self.imageView.frame.size.height + 10
                }
                self.textLabel.text = placeholder
                self.textLabel.frame = CGRect.init(x: 0, y: textY, width: self.bounds.size.width, height: 10)
                self.textLabel.sizeToFit()
                self.textLabel.frame = CGRect.init(x: 0, y: textY, width: self.bounds.size.width, height: self.textLabel.bounds.size.height)
                self.addSubview(self.textLabel)
            }
            
            setContenFrame()
        }

    }
    
   
    
    func setContenFrame() {
        
        var height : CGFloat = (self.customView != nil) ? self.customView!.bounds.size.height : 100;

        let size = self.bounds.size;
        
        if self.mode == .default{
            height = self.textLabel.frame.origin.y + self.textLabel.bounds.size.height
        }else if self.mode == .image {
            height = self.imageView.bounds.size.height
        }else if self.mode == .text {
            height = self.textLabel.bounds.size.height
        }
      
        if offset == nil {
            offset = (self.parentView.bounds.size.height - height)/3
        }
        
        self.frame = CGRect.init(x: (self.parentView.bounds.size.width - size.width)/2, y: offset!, width: size.width, height: height)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()

    }
}
