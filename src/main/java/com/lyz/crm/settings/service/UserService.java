package com.lyz.crm.settings.service;

import com.lyz.crm.settings.domain.User;

public interface UserService {
    //查询数据库中是否存在用户记录
    User login(String loginAct,String loginPwd,String id);

}
