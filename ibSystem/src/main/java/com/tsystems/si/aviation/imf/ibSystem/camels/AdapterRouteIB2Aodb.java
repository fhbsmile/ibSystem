/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.camels
 * FileName  AdapterRouteIB2Aodb.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年8月1日 上午9:57:11
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年8月1日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.camels;

import org.apache.camel.builder.RouteBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
  * ClassName AdapterRouteIB2Aodb<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年8月1日 上午9:57:11
  *
  */
//@Component
public class AdapterRouteIB2Aodb extends RouteBuilder {
	private static final Logger     logger               = LoggerFactory.getLogger(AdapterRouteIB2Aodb.class);
	
	@Autowired
	private ImfMessageAdapterProcessor imfMessageAdapterProcessor;
	/**
	  *<p> 
	  * Overriding_Method: configure<BR>
	  * Description:<BR>
	  * Overriding_Date: 2017年8月1日 上午9:57:11<BR></p>
	  * @throws Exception AdapterRouteIB2Aodb
	  * @see org.apache.camel.builder.RouteBuilder#configure()
	  */

	@Override
	public void configure() throws Exception {
		// TODO Auto-generated method stub
		from("jmsib:LQ.IB_SS2.ADAPTER").wireTap("jmsib:LQ.IMFLOG").split().method(imfMessageAdapterProcessor, "processImf")
	    .process(imfMessageAdapterProcessor)
	    .choice()
        .when(header("JMSDestination").contains("BSS2"))
             .to("jmsaodb:AQ.IB_BSS2.AODB")  
        .when(header("JMSDestination").contains("FSS2"))
             .to("jmsaodb:AQ.IB_FSS2.AODB")
        .when(header("JMSDestination").contains("RSS2"))
             .to("jmsaodb:AQ.IB_RSS2.AODB")  
        .when(header("JMSDestination").contains("US"))
             .to("jmsaodb:AQ.IB_US.AODB")  
        .otherwise()
             .to("jmsaodb:AQ.AODB.ERROR");
	}
	public ImfMessageAdapterProcessor getImfMessageProcessor() {
		return imfMessageAdapterProcessor;
	}
	public void setImfMessageProcessor(ImfMessageAdapterProcessor imfMessageAdapterProcessor) {
		this.imfMessageAdapterProcessor = imfMessageAdapterProcessor;
	}

	
	
	
}
