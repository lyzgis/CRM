package com.lyz.crm.settings.dao;

import com.lyz.crm.settings.domain.User;

import java.util.List;

public interface UserDao {
    //查询数据库中是否存在用户记录
    User selectUser(User user);

    //查询数据库中所有的用户信息
    List<User> getUserList();
}
