/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.db.web
 * FileName  RouteStatus.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年8月2日 上午11:34:07
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年8月2日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.db.web;

import org.apache.camel.ServiceStatus;

/**
  * ClassName RouteStatus<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年8月2日 上午11:34:07
  *
  */

public class RouteStatus {
    private String id;
    
    private ServiceStatus serviceStatus;
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public ServiceStatus getServiceStatus() {
        return serviceStatus;
    }

    public void setServiceStatus(ServiceStatus serviceStatus) {
        this.serviceStatus = serviceStatus;
    }
}
