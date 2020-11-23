package com.lyz.crm.workbench.service;

import com.lyz.crm.vo.PageListVo;
import com.lyz.crm.workbench.domain.Activity;

import java.util.Map;

public interface ActivityService {
    //添加市场活动的方法
    boolean saveActivity(Activity activity);

    //查询市场活动的方法
    PageListVo<Activity> pageList(Map<String,Object> map);
}
