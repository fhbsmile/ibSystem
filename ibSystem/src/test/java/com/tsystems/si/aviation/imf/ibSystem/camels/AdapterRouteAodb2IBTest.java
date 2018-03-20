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



/**
  * ClassName AdapterRouteAodb2IBTest<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年7月27日 下午2:11:32
  *
  */

public class AdapterRouteAodb2IBTest extends CamelTestSupport {
	private static final Logger     logger               = LoggerFactory.getLogger(AdapterRouteAodb2IBTest.class);
    protected CamelContext createCamelContext() throws Exception {
        CamelContext camelContext = super.createCamelContext();
        
        CachingConnectionFactory cachingConnectionFactoryAODB = new CachingConnectionFactory(new ActiveMQConnectionFactory("HNA_AODB","HNA0A1O2D9B0945","failover://(tcp://10.25.153.215:61616)?initialReconnectDelay=100"));
        cachingConnectionFactoryAODB.setSessionCacheSize(100);
        CachingConnectionFactory cachingConnectionFactoryIB = new CachingConnectionFactory(new ActiveMQConnectionFactory("HNA_AODB","HNA0A1O2D9B0945","failover://(tcp://10.25.67.38:61616)?initialReconnectDelay=100"));
        cachingConnectionFactoryAODB.setSessionCacheSize(100);
        camelContext.addComponent("jmsaodb", jmsComponentClientAcknowledge(cachingConnectionFactoryAODB));
        camelContext.addComponent("jmsib", jmsComponentClientAcknowledge(cachingConnectionFactoryIB));
    	xmlTransformer.setXslPath("CGK_aodb_2_imf.xsl");
    	xmlTransformer.initialize();
    	xmlDepatureTransformer.setXslPath("CGK_aodb_2_imf_departure.xsl");
    	xmlDepatureTransformer.initialize();
    	mqifMessageAdapterProcessor.setXmlTransformer(xmlTransformer);
    	mqifMessageAdapterProcessor.setXmlDepatureTransformer(xmlDepatureTransformer);
        return camelContext;
       
    }
	public AdapterXmlTransformer xmlTransformer = new AdapterXmlTransformer();
	public AdapterXmlTransformer xmlDepatureTransformer = new AdapterXmlTransformer();

    MqifMessageAdapterProcessor mqifMessageAdapterProcessor = new MqifMessageAdapterProcessor();
    protected RouteBuilder createRouteBuilder() throws Exception {
        return new RouteBuilder() {
            //AQ.ADAPTOR.IB_SS1
            @Override
            public void configure() throws Exception {
            	from("jmsaodb:AQ.AODB.IB_SS1BOLO").wireTap("jmsib:AQ.AODBLOG").split().method(mqifMessageAdapterProcessor, "processMqif")
            	    .process(mqifMessageAdapterProcessor)
            	    .choice()
                    .when(header("JMSDestination").contains("SS1"))
                        .to("jmsib:AQ.ADAPTOR.IB_SS1")  
                    .when(header("JMSDestination").contains("SS2"))
                        .to("jmsib:AQ.ADAPTOR.IB_SS2");    
            	    
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
