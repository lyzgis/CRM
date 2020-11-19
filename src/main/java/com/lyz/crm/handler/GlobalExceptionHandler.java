package com.lyz.crm.handler;

import com.lyz.crm.exception.LoginException;
import com.lyz.crm.utils.PrintJson;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
public class GlobalExceptionHandler {
    //定义方法，处理发生的异常
    /*
        处理异常的方法和控制器方法的定义一样， 可以有多个参数，可以有ModelAndView,
        String, void,对象类型的返回值

        形参：Exception，表示Controller中抛出的异常对象。
        通过形参可以获取发生的异常信息。

        @ExceptionHandler(异常的class)：表示异常的类型，当发生此类型异常时，
        由当前方法处理
     */
    //处理登录异常
    @ExceptionHandler(value = LoginException.class)
    @ResponseBody
    public String doLoginException(Exception exception) {
        String msg = exception.getMessage();
        Map<String,Object> map = new HashMap<String,Object>();
        map.put("success", false);
        map.put("msg", msg);
        String resultJson = PrintJson.printJsonObj(map);
        return resultJson;
    }

    //处理其它异常
    @ExceptionHandler
    public ModelAndView doException(Exception exception){
        ModelAndView mv = new ModelAndView();
        mv.addObject("ex",exception);
        mv.setViewName("login_error");
        return mv;
    }
}
