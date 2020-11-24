package com.lyz.crm.workbench.dao;

public interface ActivityRemarkDao {

    //查询和被删除市场活动相关的备注信息
    int getCountByAids(String[] ids);

    //删除相关的备注记录
    int deleteCountByAids(String[] ids);
}
