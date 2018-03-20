/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.camels
 * FileName  IBRouteSubsystem.java
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
  * ClassName IBRouteSubsystem<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年8月2日 上午10:21:19
  *
  */

public class IBRouteSubsystem extends RouteBuilder {
	private static final Logger     logger               = LoggerFactory.getLogger(IBRouteSubsystem.class);
	private SysInterface sysInterface;
	private SubsystemProcessor subsystemProcessor;
	/**
	  *<p> 
	  * Overriding_Method: configure<BR>
	  * Description:<BR>
	  * Overriding_Date: 2017年8月2日 上午10:21:19<BR></p>
	  * @throws Exception IBRouteSubsystem
	  * @see org.apache.camel.builder.RouteBuilder#configure()
	  */

	@Override
	public void configure() throws Exception {
		logger.info("   Int [{}] is initializing...",sysInterface.getIntName());
		from("jmsib:"+"LQ."+sysInterface.getIntName()+".IN").routeId(sysInterface.getIntName()).process(subsystemProcessor)
	    .choice()
        .when(header("JMSDestination").contains("SS2_Adapter"))
            .to("jmsib:LQ.IB_SS2.ADAPTER")  
        .when(header("JMSDestination").contains("US_Adapter"))
            .to("jmsib:LQ.IB_US.ADAPTER")
        .otherwise()
            .to("jmsib:"+"LQ."+sysInterface.getIntName()+".OUT");

	}
	public SysInterface getSysInterface() {
		return sysInterface;
	}
	public void setSysInterface(SysInterface sysInterface) {
		//logger.info("Setting sysInterface >>>>>>Interface Name:{}",sysInterface.getIntName());
		this.sysInterface = sysInterface;
	}
	public SubsystemProcessor getSubsystemProcessor() {
		return subsystemProcessor;
	}
	public void setSubsystemProcessor(SubsystemProcessor subsystemProcessor) {
		this.subsystemProcessor = subsystemProcessor;
	}
   
}
