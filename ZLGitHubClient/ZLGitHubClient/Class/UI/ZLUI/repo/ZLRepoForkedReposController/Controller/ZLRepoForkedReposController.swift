//
//  ZLRepoForkedReposController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/24.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoForkedReposController: ZLBaseViewController {
    
    var repoFullName : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ZLLocalizedString(string: "fork", comment: "")
        
        let itemListView = ZLGithubItemListView.init()
        itemListView.setTableViewHeader()
        self.contentView.addSubview(itemListView)
        itemListView.snp.makeConstraints ({ (make) in
            make.edges.equalToSuperview()
        })
        
        self.viewModel = ZLRepoForkedReposViewModel.init(viewController: self)
        viewModel.bindModel(repoFullName, andView: itemListView)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}