package com.lyz.crm.settings.web.controller;

import com.lyz.crm.exception.LoginException;
import com.lyz.crm.settings.domain.User;
import com.lyz.crm.settings.service.UserService;
import com.lyz.crm.utils.DateTimeUtil;
import com.lyz.crm.utils.MD5Util;
import com.lyz.crm.utils.PrintJson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/settings/user")
public class UserController {
    //引入Service对象
    @Autowired
    private UserService userService;

    @Autowired
    HttpServletRequest req;


    @RequestMapping(value = "login.do", method = RequestMethod.POST)
    @ResponseBody
    public String  login(String loginAct, String loginPwd) throws LoginException{
        //获取前端请求的IP
        String ip = req.getRemoteAddr();
        //System.out.println(loginAct + loginPwd + ip);

        //将密码转为MD5密文的形式
        loginPwd = MD5Util.getMD5(loginPwd);


        //调用Service方法，验证登录
        User user = userService.login(loginAct,loginPwd,ip);

        if(user == null){
            throw new LoginException(loginAct + "账户不存在，请检查后重新登录！");
        }

        //从dao层的返回结果中取出用户相关信息进行判断
        //用户信息失效时间
        String expireTime = user.getExpireTime();
        //系统当前时间
        String nowTime = DateTimeUtil.getSysTime();

        //判断用户信息是否过期
        if(expireTime.compareTo(nowTime) < 0){
            throw new LoginException(loginAct + "账户已经过期，请联系相关管理员！");
        }

        //判断用户锁定状态
        if("0".equals(user.getLockState())){
            throw new LoginException(user.getLoginAct() + "账户处于锁定状态，请联系相关管理员！");
        }
        //判断用户IP地址
        //判断ip地址是否合法
        String allowIps = user.getAllowIps();
        if(!allowIps.contains(ip)){
            throw new LoginException("登录IP地址受限，请联系相关管理员！");
        }

        //程序执行到此处，说明没有异常抛出
        //用户登录成功，将登录信息放入Session作用域之中
        req.getSession().setAttribute("user", user);

        //向前端返回验证结果
        String resultJson = PrintJson.printJsonFlag(true);
        return resultJson;
    }

}
