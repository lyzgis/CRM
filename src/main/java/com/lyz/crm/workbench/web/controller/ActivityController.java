package com.lyz.crm.workbench.web.controller;

import com.lyz.crm.settings.domain.User;
import com.lyz.crm.settings.service.UserService;
import com.lyz.crm.utils.DateTimeUtil;
import com.lyz.crm.utils.PrintJson;
import com.lyz.crm.utils.UUIDUtil;
import com.lyz.crm.vo.PageListVo;
import com.lyz.crm.workbench.domain.Activity;
import com.lyz.crm.workbench.service.ActivityService;
import org.mybatis.spring.mapper.MapperScannerConfigurer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    //添加市场活动
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

    @RequestMapping("/pageList.do")
    @ResponseBody
    public String pageList(Integer pageNo,Integer pageSize){
        //因为条件查询的条件可能为空，所以不适用activity对象接收参数
        String name = req.getParameter("name");
        String owner = req.getParameter("owner");
        String startDate = req.getParameter("startDate");
        String endDate = req.getParameter("endDate");
        //计算分页跳过的数据条数
        int skipCount = (pageNo - 1)*pageSize;

        //将参数放入Map集合中
        Map<String,Object> map = new HashMap<String,Object>();
        map.put("name", name);
        map.put("owner", owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);


        //将前端的参数传递给service方法
        PageListVo<Activity> vo = activityService.pageList(map);

        //将查询结果转为json，传到前端
        String result = PrintJson.printJsonObj(vo);
        return result;
    }

    //删除市场活动的方法
    @RequestMapping("/delete.do")
    @ResponseBody
    public String deleteActivity(){
        //
        String ids[] = req.getParameterValues("id");

        boolean flag = activityService.delete(ids);

        String result = PrintJson.printJsonFlag(flag);

        return result;
    }

    //获取用户列表和单条市场活动信息
    @RequestMapping("/getUserAndActivity.do")
    @ResponseBody
    public String getUserAndActivity(String id){

        //获取用户列表
        List<User> uList = userService.getUserList();

        //获取单条市场活动记录
        Activity activity = activityService.getActivity(id);

        Map<Object,Object> map = new HashMap<>();
        map.put("uList",uList);
        map.put("a",activity);

        //将结果转为json返回前端
        String result = PrintJson.printJsonObj(map);
        return result;
    }

    //更新市场活动
    @RequestMapping("/update.do")
    @ResponseBody
    public String updateActivity(Activity activity){

        //获取修改时间，写入activity
        String editTime = DateTimeUtil.getSysTime();

        //获取修改人
        String editBy = ((User) req.getSession().getAttribute("user")).getName();

        activity.setEditTime(editTime);
        activity.setEditBy(editBy);

        //调用activityService获取所有用户信息
        boolean flag = activityService.updateActivity(activity);

        //向前端返回添加结果
        String resultJson = PrintJson.printJsonFlag(flag);
        return resultJson;
    }
}
