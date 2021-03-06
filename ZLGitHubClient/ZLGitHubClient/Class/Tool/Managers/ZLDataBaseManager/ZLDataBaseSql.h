//
//  ZLDataBaseSql.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/17.
//  Copyright © 2019 ZM. All rights reserved.
//

#ifndef ZLDataBaseSql_h
#define ZLDataBaseSql_h

#define ZLDBVersion 1
#define ZLDBHomePath  [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DB"]

#pragma mark - create sql
#define dbVersionTableCreate @"create table dbversion(version int default 0)"
#define githubUserTableCreate @"create table githubUser(id_User char(10) unique, node_id char(25), loginName varchar(50), name varchar(50), company varchar(50), blog varchar(50), location varchar(50), email varchar(30), bio text, html_url varchar(50), avatar_url varchar(70), public_repos int default 0,public_gists int default 0, followers int default 0, following int default 0,created_at char(20),updated_at char(20))"



#pragma mark - query sql
#define dbVersionQuery @"select version from dbversion"
#define githubUserQueryByLoginName @"select * from githubUser where loginName = ?"
#define githubUserQueryById @"select * from githubUser where id_User = ?"

#pragma mark - update sql

#define dbversionInsert @"insert into dbversion (version) values(?)"
#define dbversionUpdate @"update dbversion set version = ? where rowid = 1"

#define githubUserInsert @"insert into githubUser (id_User,node_id,loginName,name,company,blog,location,email,bio,html_url,avatar_url,public_repos,public_gists,followers,following,created_at,updated_at) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
#define githubUserUpdate @"update githubUser set node_id = ?,loginName = ?,name = ?,company= ?,blog = ?,location = ?,email = ?, bio = ?, html_url = ?,avatar_url = ?,public_repos = ?,public_gists = ?,followers = ?, following = ?, created_at = ?,updated_at = ? where id_User = ?"


#endif /* ZLDataBaseSql_h */
