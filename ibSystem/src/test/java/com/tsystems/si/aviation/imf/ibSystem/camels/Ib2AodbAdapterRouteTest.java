/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.camels
 * FileName  Ib2AodbAdapterRouteTest.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年8月1日 上午9:58:43
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年8月1日       方红波          1.0             1.0
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

import com.tsystems.si.aviation.imf.ibSystem.message.AdapterXmlTransformer;

/**
  * ClassName Ib2AodbAdapterRouteTest<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年8月1日 上午9:58:43
  *
  */

public class Ib2AodbAdapterRouteTest extends CamelTestSupport {
	private static final Logger     logger               = LoggerFactory.getLogger(Ib2AodbAdapterRouteTest.class);
	
    protected CamelContext createCamelContext() throws Exception {
        CamelContext camelContext = super.createCamelContext();
        
        CachingConnectionFactory cachingConnectionFactoryAODB = new CachingConnectionFactory(new ActiveMQConnectionFactory("HNA_AODB","HNA0A1O2D9B0945","failover://(tcp://10.25.153.215:61616)?initialReconnectDelay=100"));
        cachingConnectionFactoryAODB.setSessionCacheSize(100);
        CachingConnectionFactory cachingConnectionFactoryIB = new CachingConnectionFactory(new ActiveMQConnectionFactory("HNA_AODB","HNA0A1O2D9B0945","failover://(tcp://10.25.67.38:61616)?initialReconnectDelay=100"));
        cachingConnectionFactoryAODB.setSessionCacheSize(100);
        camelContext.addComponent("jmsaodb", jmsComponentClientAcknowledge(cachingConnectionFactoryAODB));
        camelContext.addComponent("jmsib", jmsComponentClientAcknowledge(cachingConnectionFactoryIB));
    	xmlTransformer.setXslPath("CGK_imf_2_aodb.xsl");
    	xmlTransformer.initialize();

    	imfMessageAdapterProcessor.setXmlTransformer(xmlTransformer);
        return camelContext;
       
    }
	public AdapterXmlTransformer xmlTransformer = new AdapterXmlTransformer();
	ImfMessageAdapterProcessor imfMessageAdapterProcessor = new ImfMessageAdapterProcessor();
	
    protected RouteBuilder createRouteBuilder() throws Exception {
        return new RouteBuilder() {
            //AQ.ADAPTOR.IB_SS1
            @Override
            public void configure() throws Exception {
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
    	Thread.sleep(1000);
    }  
}
