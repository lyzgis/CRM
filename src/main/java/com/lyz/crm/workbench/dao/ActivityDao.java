package com.lyz.crm.workbench.dao;

import com.lyz.crm.workbench.domain.Activity;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ActivityDao {

    //向数据库添加市场活动的方法
    int saveActivity(Activity activity);

    //查询市场活动的方法
    List<Activity> getActivityListByCondition(Map<String,Object> map);

    //统计市场活动总条数的方法
    int getTotalByCondition(Map<String,Object> map);

    //删除市场活动信息
    int delete(String[] ids);

    //通过Id查询市场活动
    Activity getActivityById(String id);

    //更新市场活动
    int update(Activity activity);
}
