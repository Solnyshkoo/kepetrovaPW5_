//
//  File.swift
//  kepetrovaPW5_
//
//  Created by Ksenia Petrova on 17.11.2021.
//

import UIKit
class ArticleCell: UITableViewCell {
    override func prepareForReuse() {
        for subview in subviews {
            if subview is UIImageView {
                subview.removeFromSuperview()
            }
        }
    }
   
    let img : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = 15
        imgView.clipsToBounds = true
        return imgView
    }()
    
    let text: UILabel = {
        let control = UILabel()
        control.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        control.textAlignment = .center
        control.textColor = UIColor.black
        control.translatesAutoresizingMaskIntoConstraints = false
        control.numberOfLines = 4;
        return control
    }()
    
    let descr: UILabel = {
        let control = UILabel()
        control.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        control.textAlignment = .center
        control.textColor = UIColor.black
        control.translatesAutoresizingMaskIntoConstraints = false
        control.numberOfLines = 3;
        return control
    }()
    
    func addView(){
        addSubview(text)
        addSubview(descr)
        addSubview(img)
        
        text.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        text.topAnchor.constraint(equalTo: topAnchor).isActive = true
        text.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        
        img.topAnchor.constraint(equalTo: self.text.bottomAnchor).isActive = true
        img.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        img.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        img.widthAnchor.constraint(equalToConstant: 250).isActive = true
        img.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        
        descr.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        descr.topAnchor.constraint(equalTo: self.img.bottomAnchor, constant: 3).isActive = true
        descr.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    }
}
