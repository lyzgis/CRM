package com.lyz.crm.workbench.web.controller;

import com.lyz.crm.settings.domain.User;
import com.lyz.crm.settings.service.UserService;
import com.lyz.crm.utils.DateTimeUtil;
import com.lyz.crm.utils.PrintJson;
import com.lyz.crm.utils.UUIDUtil;
import com.lyz.crm.workbench.domain.Activity;
import com.lyz.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("/workbench/activity")
public class ActivityController {

    //引入市场活动service对象
    @Autowired
    private ActivityService activityService;

    //引入用户操作service对象
    @Autowired
    private UserService userService;

    @Autowired
    HttpServletRequest req;

    //获取用户列表的方法
    @RequestMapping("/getUser.do")
    @ResponseBody
    public String getUser(){

        //调用userService获取所有用户信息
        List<User> userList = userService.getUserList();

        //将集合通过工具类转为json
        String resultJson = PrintJson.printJsonObj(userList);

        return resultJson;
    }

    //获取用户列表的方法
    @RequestMapping("/save.do")
    @ResponseBody
    public String saveActivity(Activity activity){
        //生成用户随机UUID
        String id = UUIDUtil.getUUID();
        activity.setId(id);

        //获取系统当前时间，写入activity
        String createTime = DateTimeUtil.getSysTime();
        activity.setCreateTime(createTime);

        //获取创建人
        String createBy = ((User) req.getSession().getAttribute("user")).getName();
        activity.setCreateBy(createBy);


        //调用activityService获取所有用户信息
        boolean flag = activityService.saveActivity(activity);

        //向前端返回添加结果
        String resultJson = PrintJson.printJsonFlag(flag);
        return resultJson;
    }

}
