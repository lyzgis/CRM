package com.lyz.crm.workbench.service.impl;

import com.lyz.crm.vo.PageListVo;
import com.lyz.crm.workbench.dao.ActivityDao;
import com.lyz.crm.workbench.dao.ActivityRemarkDao;
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

    @Autowired
    private ActivityRemarkDao remarkDao;


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

    //删除市场活动
    @Override
    public boolean delete(String[] ids) {
        boolean flag = true;

        //查询需要删除的市场活动备注信息
        int count1 = remarkDao.getCountByAids(ids);

        //删除市场活动的备注信息（实际删除的数量）（activity表的外键约束）
        int count2 = remarkDao.deleteCountByAids(ids);
        if(count1 != count2){
            flag = false;
        }
        //删除市场活动
        int count3 = dao.delete(ids);
        if(count3 != ids.length){
            flag = false;
        }

        return flag;
    }

    //查询单条市场活动记录
    @Override
    public Activity getActivity(String id) {

        //调用dao层的方法获取市场活动
        Activity activity = dao.getActivityById(id);

        return activity;
    }

    //更新市场活动
    @Override
    public boolean updateActivity(Activity activity) {
        //调用dao层方法添加更新
        boolean flag = true;
        int nums =  dao.update(activity);
        if(nums !=1 ){
            flag = false;
        }
        return flag;
    }
}
