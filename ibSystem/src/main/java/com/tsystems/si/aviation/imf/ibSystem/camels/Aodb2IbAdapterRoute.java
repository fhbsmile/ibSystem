/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.camels
 * FileName  Aodb2IbAdapterRoute.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年7月27日 下午1:54:49
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年7月27日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.camels;

import org.apache.camel.builder.RouteBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.tsystems.si.aviation.imf.ibSystem.message.MqifMessageUtil;


/**
  * ClassName Aodb2IbAdapterRoute<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年7月27日 下午1:54:49
  *
  */
@Component
public class Aodb2IbAdapterRoute extends RouteBuilder {
	@Autowired
	private MqifMessageAdapterProcessor mqifMessageAdapterProcessor;
	/**
	  *<p> 
	  * Overriding_Method: configure<BR>
	  * Description:<BR>
	  * Overriding_Date: 2017年7月27日 下午1:54:49<BR></p>
	  * @throws Exception Aodb2IbAdapterRoute
	  * @see org.apache.camel.builder.RouteBuilder#configure()
	  */

	@Override
	public void configure() throws Exception {
		//FSS2 to adapter
		from("jmsaodb:AQ.AODB.IB_FSS2").routeId("AODB.Adapter.FSS2").wireTap("jmsib:AQ.ADAPTOR.lOG").split().method(mqifMessageAdapterProcessor, "processMqif")
	    .process(mqifMessageAdapterProcessor)
	    .choice()
        .when(header("JMSDestination").contains("SS1"))
            .to("jmsib:AQ.ADAPTOR.IB_SS1")  
        .when(header("JMSDestination").contains("SS2"))
            .to("jmsib:AQ.ADAPTOR.IB_SS2")
        .when(header("JMSDestination").contains("US"))
            .to("jmsib:AQ.ADAPTOR.IB_US");
		
		from("jmsaodb:AQ.AODB.IB_BSS2").routeId("AODB.Adapter.BSS2").wireTap("jmsib:AQ.ADAPTOR.lOG").split().method(mqifMessageAdapterProcessor, "processMqif")
	    .process(mqifMessageAdapterProcessor)
	    .choice()
        .when(header("JMSDestination").contains("SS1"))
            .to("jmsib:AQ.ADAPTOR.IB_SS1")  
        .when(header("JMSDestination").contains("SS2"))
            .to("jmsib:AQ.ADAPTOR.IB_SS2")
        .when(header("JMSDestination").contains("US"))
            .to("jmsib:AQ.ADAPTOR.IB_US");
		
		from("jmsaodb:AQ.AODB.IB_RSS2").routeId("AODB.Adapter.RSS2").wireTap("jmsib:AQ.ADAPTOR.lOG").split().method(mqifMessageAdapterProcessor, "processMqif")
	    .process(mqifMessageAdapterProcessor)
	    .choice()
        .when(header("JMSDestination").contains("SS1"))
            .to("jmsib:AQ.ADAPTOR.IB_SS1")  
        .when(header("JMSDestination").contains("SS2"))
            .to("jmsib:AQ.ADAPTOR.IB_SS2")
        .when(header("JMSDestination").contains("US"))
            .to("jmsib:AQ.ADAPTOR.IB_US");
		
		from("jmsaodb:AQ.AODB.IB_US").routeId("AODB.Adapter.US").wireTap("jmsib:AQ.ADAPTOR.lOG").split().method(mqifMessageAdapterProcessor, "processMqif")
	    .process(mqifMessageAdapterProcessor)
	    .choice()
        .when(header("JMSDestination").contains("SS1"))
            .to("jmsib:AQ.ADAPTOR.IB_SS1")  
        .when(header("JMSDestination").contains("SS2"))
            .to("jmsib:AQ.ADAPTOR.IB_SS2")
        .when(header("JMSDestination").contains("US"))
            .to("jmsib:AQ.ADAPTOR.IB_US");
		
		from("jmsaodb:AQ.AODB.IB_SS1BOLO").routeId("AODB.Adapter.SS1").wireTap("jmsib:AQ.ADAPTOR.lOG").split().method(mqifMessageAdapterProcessor, "processMqif")
	    .process(mqifMessageAdapterProcessor)
	    .choice()
        .when(header("JMSDestination").contains("SS1"))
            .to("jmsib:AQ.ADAPTOR.IB_SS1")  
        .when(header("JMSDestination").contains("SS2"))
            .to("jmsib:AQ.ADAPTOR.IB_SS2")
        .when(header("JMSDestination").contains("US"))
            .to("jmsib:AQ.ADAPTOR.IB_US");
		
		//SS1 Subscribe
		from("quartz2://SS1?cron=0/2+17+*+*+*+?").setBody().method(MqifMessageUtil.class, "buildSS1Subscribe").to("mock:end");
	}
	public MqifMessageAdapterProcessor getMqifProcessor() {
		return mqifMessageAdapterProcessor;
	}
	public void setMqifProcessor(MqifMessageAdapterProcessor mqifMessageAdapterProcessor) {
		this.mqifMessageAdapterProcessor = mqifMessageAdapterProcessor;
	}
  
}
