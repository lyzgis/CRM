package com.lyz.crm.workbench.dao;

import com.lyz.crm.workbench.domain.Activity;

public interface ActivityDao {

    //向数据库添加市场活动的方法
    int saveActivity(Activity activity);
}
