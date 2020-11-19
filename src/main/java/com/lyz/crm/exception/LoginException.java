package com.lyz.crm.exception;

/**
 * 登录异常，提示用户登录的相关错误信息
 */
public class LoginException extends RuntimeException{
    public LoginException() {
        super();
    }

    public LoginException(String message) {
        super(message);
    }
}
