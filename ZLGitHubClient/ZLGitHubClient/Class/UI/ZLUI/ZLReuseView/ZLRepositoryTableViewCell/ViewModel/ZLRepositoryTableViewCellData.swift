//
//  ZLRepositoryTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/12/10.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

@objcMembers class ZLRepositoryTableViewCellData: ZLGithubItemTableViewCellData {
    
    var data : ZLGithubRepositoryModel
    let needPullData : Bool
    private var _cellHeight : CGFloat?
    weak var cell : ZLRepositoryTableViewCell?
    
    init(data : ZLGithubRepositoryModel, needPullData : Bool){
        self.needPullData = needPullData;
        self.data = data;
        super.init()
        if self.needPullData == true {
            self.getRepoInfoFromServer()
        }
    }
    
    convenience init(data : ZLGithubRepositoryModel){
        self.init(data: data, needPullData: false)
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        guard let cell : ZLRepositoryTableViewCell = targetView as? ZLRepositoryTableViewCell else{
            return
        }
        
        cell.fillWithData(data: self)
        cell.delegate = self
        self.cell = cell
    }
    
    override func getCellHeight() -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    override func getCellReuseIdentifier() -> String {
        return "ZLRepositoryTableViewCell"
    }
    
    
    func getRepoInfoFromServer() {
        weak var weakSelf = self
        ZLRepoServiceModel.shared().getRepoInfo(withFullName: self.data.full_name, serialNumber: NSString.generateSerialNumber(), completeHandle: {(resultModel : ZLOperationResultModel) in
            if resultModel.result == true {
                guard  let model : ZLGithubRepositoryModel = resultModel.data as? ZLGithubRepositoryModel  else {
                    return
                }
                weakSelf?._cellHeight = nil
                weakSelf?.data = model
                let delegate = weakSelf?.cell?.delegate
                if ((delegate?.isEqual(weakSelf)) != false) {
                    weakSelf?.cell?.fillWithData(data: weakSelf!)
                }
            }
        })
    }
    
    
}


extension ZLRepositoryTableViewCellData
{
    func getOwnerAvatarURL() -> String?
    {
        return self.data.owner.avatar_url
    }
    
    func getRepoFullName() -> String?
    {
        return self.data.full_name
    }
    
    func getRepoName() -> String?
    {
        return self.data.name
    }
    
    func getOwnerName() -> String?
    {
        return self.data.owner.loginName
    }
    
    func getRepoMainLanguage() -> String?
    {
        return self.data.language
    }
    
    func getRepoDesc() -> String?
    {
        return self.data.desc_Repo
    }
    
    func isPriva() -> Bool
    {
        return self.data.isPriva
    }
    
    func starNum() -> Int
    {
        return Int(self.data.stargazers_count)
    }
    
    func forkNum() -> Int
    {
        return Int(self.data.forks)
    }
}


extension ZLRepositoryTableViewCellData : ZLRepositoryTableViewCellDelegate
{
    func onRepoAvaterClicked() {
        let userInfoVC = ZLUserInfoController.init(loginName: self.data.owner.loginName, type: self.data.owner.type)
        userInfoVC.hidesBottomBarWhenPushed = true
        self.viewController?.navigationController?.pushViewController(userInfoVC, animated: true)
    }
        
    func onRepoContainerViewClicked()
    {
        let repoInfoVC = ZLRepoInfoController.init(repoInfoModel: self.data)
        repoInfoVC.hidesBottomBarWhenPushed = true
        self.viewController?.navigationController?.pushViewController(repoInfoVC, animated: true)
    }
}
