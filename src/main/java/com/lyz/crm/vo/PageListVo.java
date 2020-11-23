package com.lyz.crm.vo;

import java.util.List;

public class PageListVo<T> {
    //查询记录的总条数
    private int total;

    //json数组，使用泛型
    private List<T> dataList;

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public List<T> getDataList() {
        return dataList;
    }

    public void setDataList(List<T> dataList) {
        this.dataList = dataList;
    }
}
