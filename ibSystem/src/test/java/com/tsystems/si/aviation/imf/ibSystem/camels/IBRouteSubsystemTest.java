/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.camels
 * FileName  IBRouteSubsystemTest.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年8月2日 下午1:53:13
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年8月2日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.camels;

import static org.apache.camel.component.jms.JmsComponent.jmsComponentClientAcknowledge;

import org.apache.activemq.ActiveMQConnectionFactory;
import org.apache.camel.CamelContext;
import org.apache.camel.test.junit4.CamelTestSupport;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jms.connection.CachingConnectionFactory;

import com.tsystems.si.aviation.imf.ibSystem.db.domain.SysInterface;

/**
  * ClassName IBRouteSubsystemTest<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年8月2日 下午1:53:13
  *
  */

public class IBRouteSubsystemTest extends CamelTestSupport {
	private static final Logger     logger               = LoggerFactory.getLogger(IBRouteSubsystemTest.class);
	protected CamelContext createCamelContext() throws Exception {
	CamelContext camelContext = super.createCamelContext();
    

    CachingConnectionFactory cachingConnectionFactoryIB = new CachingConnectionFactory(new ActiveMQConnectionFactory("HNA_AODB","HNA0A1O2D9B0945","failover://(tcp://10.25.67.38:61616)?initialReconnectDelay=100"));
    cachingConnectionFactoryIB.setSessionCacheSize(100);

    camelContext.addComponent("jmsib", jmsComponentClientAcknowledge(cachingConnectionFactoryIB));
    return camelContext;
    
	}
    
    
    @Test
    public void testInitSubRoute() throws Exception {
    	logger.info("Test start....");
    	
    	SysInterface sysInterface = new SysInterface();
    	sysInterface.setIntName("BOLO");
    	IBRouteSubsystem iBRouteSubsystem = new IBRouteSubsystem();
    	iBRouteSubsystem.setSysInterface(sysInterface);
    	this.context().addRoutes(iBRouteSubsystem);
    	
    }
}
