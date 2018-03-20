/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.camels
 * FileName  SubSysDynamicRouterBean.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年8月10日 上午10:24:00
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年8月10日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.camels;

import org.apache.camel.Exchange;
import org.apache.camel.Header;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
  * ClassName SubSysDynamicRouterBean<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年8月10日 上午10:24:00
  *
  */

public class SubSysDynamicRouterBean {
	private static final Logger     logger               = LoggerFactory.getLogger(SubSysDynamicRouterBean.class);
	public String routeByReceiver(String body, @Header(Exchange.SLIP_ENDPOINT) String previous) {
		logger.info(">>>>>>>>>>>>>>Previous:{}",previous);
		logger.info(">>>>>>>>>>>>>>    body:{}",body);
		if(StringUtils.isBlank(body)){
			return null;
		}else{
			 if (previous == null) {
		        	String serviceType = StringUtils.substringBetween(body, "<ServiceType>", "</ServiceType>");
		    		String receiver = StringUtils.substringBetween(body, "<Receiver>", "</Receiver>");
		            return "jmsib:LQ."+receiver+".OUT";
		        } else {
		            // no more, so return null to indicate end of dynamic router
		            return null;
		        }
		}

		
    }
}
