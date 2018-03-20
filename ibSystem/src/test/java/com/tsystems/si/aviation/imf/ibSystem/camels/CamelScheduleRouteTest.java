/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.camels
 * FileName  AdapterRouteAodb2IBTest.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年7月27日 下午2:11:32
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年7月27日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.camels;

import static org.apache.camel.component.jms.JmsComponent.jmsComponentClientAcknowledge;

import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.jms.ConnectionFactory;

import org.apache.activemq.ActiveMQConnectionFactory;
import org.apache.camel.CamelContext;
import org.apache.camel.Route;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.test.junit4.CamelTestSupport;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jms.connection.CachingConnectionFactory;

import com.tsystems.si.aviation.imf.ibSystem.message.AdapterXmlTransformer;
import com.tsystems.si.aviation.imf.ibSystem.message.MqifMessageUtil;



/**
  * ClassName AdapterRouteAodb2IBTest<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年7月27日 下午2:11:32
  *
  */

public class CamelScheduleRouteTest extends CamelTestSupport {
	private static final Logger     logger               = LoggerFactory.getLogger(CamelScheduleRouteTest.class);
    protected CamelContext createCamelContext() throws Exception {
        CamelContext camelContext = super.createCamelContext();
        
        return camelContext;
       
    }
    
    protected RouteBuilder createRouteBuilder() throws Exception {
        return new RouteBuilder() {
            @Override
            public void configure() throws Exception {
            	from("quartz2://SS1?cron=0/2+17+*+*+*+?").routeId("QUARTZ").setBody().method(MqifMessageUtil.class, "buildSS1Subscribe").to("mock:end");
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
    	Thread.sleep(10000);
/*    	 getMockEndpoint("mock:end").expectedMessageCount(1);

         assertMockEndpointsSatisfied();*/
    }   

}
