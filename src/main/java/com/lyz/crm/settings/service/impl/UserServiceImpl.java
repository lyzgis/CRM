package com.lyz.crm.settings.service.impl;

import com.lyz.crm.exception.LoginException;
import com.lyz.crm.settings.dao.UserDao;
import com.lyz.crm.settings.domain.User;
import com.lyz.crm.settings.service.UserService;
import com.lyz.crm.utils.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService{
    //引入dao对象
    @Autowired
    private UserDao userDao;

    @Override
    public User login(String loginAct,String loginPwd,String ip) {
        User user = new User();
        user.setLoginAct(loginAct);
        user.setLoginPwd(loginPwd);
        User userRes = userDao.selectUser(user);

        return userRes;
    }
}
