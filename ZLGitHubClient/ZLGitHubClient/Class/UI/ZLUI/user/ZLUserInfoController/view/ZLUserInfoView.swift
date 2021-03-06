//
//  ZLUserInfoView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/11.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLUserInfoView: ZLBaseView {
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    
    @IBOutlet weak var repositoryNum: UILabel!
    @IBOutlet weak var gistNumLabel: UILabel!
    @IBOutlet weak var followersNumLabel: UILabel!
    @IBOutlet weak var followingNumLabel: UILabel!
    
    @IBOutlet weak var repositoriesButton: UIButton!
    @IBOutlet weak var gistsButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var addrLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var blogLabel: UILabel!
    
    @IBOutlet weak var companyInfoLabel: UILabel!
    @IBOutlet weak var addressInfoLabel: UILabel!
    @IBOutlet weak var emailInfoLabel: UILabel!
    @IBOutlet weak var blogInfoLabel: UILabel!
    
    @IBOutlet weak var followButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.headImageView.layer.cornerRadius = 30.0;
        self.justUpdate();
        
    }
    
    func justUpdate()
    {
        self.repositoriesButton.setTitle(ZLLocalizedString(string: "repositories",comment: "仓库"), for: .normal);
        self.gistsButton.setTitle(ZLLocalizedString(string: "gists",comment: "代码片段"), for: .normal);
        self.followersButton.setTitle(ZLLocalizedString(string: "followers",comment: "粉丝"), for: .normal);
        self.followingButton.setTitle(ZLLocalizedString(string: "following",comment: "关注"), for: .normal);
        self.companyLabel.text = ZLLocalizedString(string:"company", comment: "公司")
        self.addrLabel.text = ZLLocalizedString(string:"location", comment: "地址")
        self.emailLabel.text = ZLLocalizedString(string:"email", comment: "邮箱")
        self.blogLabel.text = ZLLocalizedString(string:"blog", comment: "博客")
        
        self.followButton.setTitle(ZLLocalizedString(string: "Follow", comment: ""), for: .normal)
        self.followButton.setTitle(ZLLocalizedString(string: "Unfollow", comment: "Unfollow"), for: .selected)
        
        
    }

}
