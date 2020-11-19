<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
    <base href="%=basePath%">
    <title>Login</title>
    <meta charset="UTF-8">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="jquery/jquery-3.5.1.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script>
        $(function () {
            //页面加载清空用户名、密码及错误提示框的内容
            $("#loginAct").val("");
            $("#loginPwd").val("");
            $("#msg").html("");

            //页面加载用户名文本框自动获得焦点
            $("#loginAct").focus();

            //捕捉登录按钮点击时间，验证登录
            $("#submitBtn").click(function () {
                //调用登录验证方法
                $("#msg").html("");
                login();
            })

            //捕捉用户按下键盘回车键，触发登录
            $(window).keydown(function (event) {
                //判断用户按下的是否为回车键
                if(event.keyCode == 13){
                    //调用登录验证方法
                    $("#msg").html("");
                    login();
                }
            })
        })

        //登录验证方法
        function login() {
            //获取用户输入的账号密码,并去除空格
            var loginAct = $.trim($("#loginAct").val());
            var loginPwd = $.trim($("#loginPwd").val());

            if(loginAct == "" || loginPwd == ""){
                $("#msg").html("用户名或密码不能为空！")

                //账号密码为空，登录失败，中止登录方法
                return false;
            }
            //向后端发起登录验证的AJAX请求
            $.ajax({
                url:"settings/user/login.do",
                data:{
                    "loginAct":loginAct,
                    "loginPwd":loginPwd
                },
                type:"post",
                dataType:"json",
                success:function (data) {
                    /*
                    * 像后端索要的数据
                    * data
                    * {"success":true/false,"msg":"异常信息"}
                    * */

                    if(data.success){
                        window.location.href = "workbench/index.jsp";
                    }else {
                        $("#msg").html(data.msg)
                    }
                }
            })
        }
    </script>
</head>
<body>
<div style="position: absolute; top: 0px; left: 0px; height:100%;width: 60%;">
    <img src="images/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM客户关系管理系统 &nbsp;<span style="font-size: 12px;">&copy;2020&nbsp;JXNU_LYZ</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>登录</h1>
        </div>
        <form action="" class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <input class="form-control" type="text" placeholder="用户名" id="loginAct" required autocomplete='用户名'>
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input class="form-control" type="password" placeholder="密码" id="loginPwd" required autocomplete='密码'>
                </div>
                <div class="checkbox"  style="position: relative;top: 30px; left: 10px;">

                    <span id="msg" style="color: red"></span>

                </div>
                <button type="button" id="submitBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
