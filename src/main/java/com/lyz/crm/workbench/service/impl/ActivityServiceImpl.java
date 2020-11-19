package com.lyz.crm.workbench.service.impl;

import com.lyz.crm.workbench.dao.ActivityDao;
import com.lyz.crm.workbench.domain.Activity;
import com.lyz.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
}
