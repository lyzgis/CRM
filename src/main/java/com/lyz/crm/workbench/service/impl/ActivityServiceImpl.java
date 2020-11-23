package com.lyz.crm.workbench.service.impl;

import com.lyz.crm.vo.PageListVo;
import com.lyz.crm.workbench.dao.ActivityDao;
import com.lyz.crm.workbench.domain.Activity;
import com.lyz.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityDao dao;

    @Override
    public boolean saveActivity(Activity activity) {
        int nums = dao.saveActivity(activity);

        if(nums > 0){
            return true;
        }else{
            return false;
        }
    }

    @Override
    public PageListVo<Activity> pageList(Map<String,Object> map) {
        //查询所有市场活动
        List<Activity> dataList = dao.getActivityListByCondition(map);

        //统计市场活动的条数
        int total = dao.getTotalByCondition(map);

        //将查询结果放入vo
        PageListVo<Activity> vo = new PageListVo<>();
        vo.setDataList(dataList);
        vo.setTotal(total);
        return vo;
    }
}
