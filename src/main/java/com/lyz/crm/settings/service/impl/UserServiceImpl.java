package com.lyz.crm.settings.service.impl;

import com.lyz.crm.settings.dao.UserDao;
import com.lyz.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {
    //引入dao对象
    @Autowired
    private UserDao userDao;
}
