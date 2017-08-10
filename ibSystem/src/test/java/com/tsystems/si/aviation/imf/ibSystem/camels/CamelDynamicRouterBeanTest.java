/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.camels
 * FileName  CamelDynamicRouterBeanTest.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年8月10日 下午3:57:42
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年8月10日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.camels;

import static org.apache.camel.component.jms.JmsComponent.jmsComponentClientAcknowledge;

import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.activemq.ActiveMQConnectionFactory;
import org.apache.camel.CamelContext;
import org.apache.camel.Route;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.test.junit4.CamelTestSupport;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jms.connection.CachingConnectionFactory;





/**
  * ClassName CamelDynamicRouterBeanTest<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年8月10日 下午3:57:42
  *
  */

public class CamelDynamicRouterBeanTest extends CamelTestSupport {
	private static final Logger     logger               = LoggerFactory.getLogger(CamelDynamicRouterBeanTest.class);
    protected CamelContext createCamelContext() throws Exception {
        CamelContext camelContext = super.createCamelContext();
        CachingConnectionFactory cachingConnectionFactoryIB = new CachingConnectionFactory(new ActiveMQConnectionFactory("HNA_AODB","HNA0A1O2D9B0945","failover://(tcp://10.25.67.38:61616)?initialReconnectDelay=100"));
        cachingConnectionFactoryIB.setSessionCacheSize(100);

        camelContext.addComponent("jmsib", jmsComponentClientAcknowledge(cachingConnectionFactoryIB));
        return camelContext;
       
    }
    
    protected RouteBuilder createRouteBuilder() throws Exception {
        return new RouteBuilder() {
            @Override
            public void configure() throws Exception {
            	from("jmsib:AQ.AA.IN").routeId("QUARTZ").dynamicRouter(method(SubSysDynamicRouterBean.class, "routeByReceiver"));
            }
        };
    }

    @Test
    public void testClientGetsReply() throws Exception {
    	logger.info("Test start....");
    	List<Route> lr = this.context().getRoutes();
        for(Route r:lr){
        	logger.info("Route ID:{},Description:{},uptime:{}",new Object[]{r.getId(),r.getDescription(),r.getUptime()});
    		Map<String, Object> map = r.getProperties();
   		 for (Entry<String, Object> entry : map.entrySet()) {
   			 logger.info("key:{}, value:{}",new Object[]{entry.getKey(),entry.getValue()});
   			  }
        }
    	Thread.sleep(30000);
/*    	 getMockEndpoint("mock:end").expectedMessageCount(1);

         assertMockEndpointsSatisfied();*/
    }   
}
