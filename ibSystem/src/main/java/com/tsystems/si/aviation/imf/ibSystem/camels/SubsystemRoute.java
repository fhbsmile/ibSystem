/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.camels
 * FileName  SubsystemRoute.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年8月2日 上午10:21:19
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年8月2日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.camels;

import org.apache.camel.builder.RouteBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.tsystems.si.aviation.imf.ibSystem.db.domain.SysInterface;

/**
  * ClassName SubsystemRoute<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年8月2日 上午10:21:19
  *
  */

public class SubsystemRoute extends RouteBuilder {
	private static final Logger     logger               = LoggerFactory.getLogger(SubsystemRoute.class);
	private SysInterface sysInterface;
	/**
	  *<p> 
	  * Overriding_Method: configure<BR>
	  * Description:<BR>
	  * Overriding_Date: 2017年8月2日 上午10:21:19<BR></p>
	  * @throws Exception SubsystemRoute
	  * @see org.apache.camel.builder.RouteBuilder#configure()
	  */

	@Override
	public void configure() throws Exception {
		logger.info("initialization>>>>>Interface Name:{}",sysInterface.getIntName());
		from("jmsib:"+"LQ"+sysInterface.getIntName()).routeId(sysInterface.getIntName()).to("jmsib:AQ.ADAPTOR.TEST").setGroup("IB");

	}
	public SysInterface getSysInterface() {
		return sysInterface;
	}
	public void setSysInterface(SysInterface sysInterface) {
		logger.info("Setting sysInterface >>>>>>Interface Name:{}",sysInterface.getIntName());
		this.sysInterface = sysInterface;
	}
   
}
