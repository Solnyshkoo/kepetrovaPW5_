//
//  File.swift
//  kepetrovaPW5_
//
//  Created by Ksenia Petrova on 17.11.2021.
//

import Foundation
import UIKit
class ArticleCell: UITableViewCell {
    override func prepareForReuse() {
        for subview in subviews {
            if subview is UIImageView {
                subview.removeFromSuperview()
            }
        }
    }
    
    var text: UILabel = {
        let control = UILabel()
        control.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        control.textAlignment = .center
        control.textColor = UIColor.black
        control.text = "30"
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    func addView(){
        addSubview(text)
        text.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        text.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        
    }
}
