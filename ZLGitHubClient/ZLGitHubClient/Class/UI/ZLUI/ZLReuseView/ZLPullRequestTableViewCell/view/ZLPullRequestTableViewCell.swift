//
//  ZLPullRequestTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/10.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

@objc protocol ZLPullRequestTableViewCellDelegate : NSObjectProtocol {
    func onCellClicked();
}

class ZLPullRequestTableViewCell: UITableViewCell {
    
    weak var  delegate : ZLPullRequestTableViewCellDelegate?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var assitInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.containerView.layer.cornerRadius = 8.0
        
        let gestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.onCellClicked(gestureRecognizer:)))
        self.containerView.addGestureRecognizer(gestureRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func fillWithData(data : ZLPullRequestTableViewCellData)
    {
        self.titleLabel.text = data.getTitle()
        self.assitInfoLabel.text = data.getAssistInfo() 
    }
    
    
    @objc func onCellClicked(gestureRecognizer : UITapGestureRecognizer)
    {
        if self.delegate?.responds(to: #selector(ZLPullRequestTableViewCellDelegate.onCellClicked)) ?? false
        {
            self.delegate?.onCellClicked()
        }
    }
    
}
