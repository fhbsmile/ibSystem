/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.configurations
 * FileName  ActiveMQConfiguration.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年7月22日 下午3:01:30
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年7月22日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.configurations;

import static org.apache.camel.component.jms.JmsComponent.jmsComponentClientAcknowledge;

import org.apache.activemq.ActiveMQConnectionFactory;
import org.apache.camel.CamelContext;
import org.apache.camel.impl.DefaultCamelContext;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.ImportResource;
import org.springframework.context.annotation.Primary;
import org.springframework.jms.connection.CachingConnectionFactory;

import com.tsystems.si.aviation.imf.ibSystem.camels.MqifMessageProcessor;
import com.tsystems.si.aviation.imf.ibSystem.message.AdapterXmlTransformer;
import com.tsystems.si.aviation.imf.ibSystem.message.XmlTransformer;

/**
  * ClassName ActiveMQConfiguration<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年7月22日 下午3:01:30
  *
  */
@Configuration
@ComponentScan("com.tsystems.si.aviation.imf.ibSystem.camel")
public class ActiveMQConfiguration {
      
	@Bean
	@Qualifier("cachingConnectionFactoryAODB")
	public CachingConnectionFactory cachingConnectionFactoryAODB(){
		 CachingConnectionFactory cachingConnectionFactoryAODB = new CachingConnectionFactory(new ActiveMQConnectionFactory("HNA_AODB","HNA0A1O2D9B0945","failover://(tcp://10.25.153.215:61616)?initialReconnectDelay=100"));
	     cachingConnectionFactoryAODB.setSessionCacheSize(100);
	     return cachingConnectionFactoryAODB;
	}
	
	@Bean
	@Qualifier("cachingConnectionFactoryIB")
	@Primary
	public CachingConnectionFactory cachingConnectionFactoryIB(){
		 CachingConnectionFactory cachingConnectionFactoryIB = new CachingConnectionFactory(new ActiveMQConnectionFactory("HNA_AODB","HNA0A1O2D9B0945","failover://(tcp://10.25.67.38:61616)?initialReconnectDelay=100"));
	     cachingConnectionFactoryIB.setSessionCacheSize(100);
	     return cachingConnectionFactoryIB;
	}
	@Bean
	@Qualifier("camelContext")
	public CamelContext  camelContext(){
		CamelContext  camelContext = new DefaultCamelContext();
		camelContext.addComponent("jmsaodb", jmsComponentClientAcknowledge(cachingConnectionFactoryAODB()));
		camelContext.addComponent("jmsib", jmsComponentClientAcknowledge(cachingConnectionFactoryIB()));

		return camelContext;
	}
	
	@Bean
	@Qualifier("mqifXmlTransformer")
	public XmlTransformer  mqifXmlTransformer(){
		AdapterXmlTransformer mqifXmlTransformer = new AdapterXmlTransformer();
		mqifXmlTransformer.setXslPath("CGK_aodb_2_imf.xsl");
		mqifXmlTransformer.initialize();
		return mqifXmlTransformer;
	}
	@Bean
	@Qualifier("mqifXmlDepatureTransformer")
	public XmlTransformer  mqifXmlDepatureTransformer(){
		AdapterXmlTransformer mqifXmlDepatureTransformer = new AdapterXmlTransformer();
		mqifXmlDepatureTransformer.setXslPath("CGK_aodb_2_imf_departure.xsl");
		mqifXmlDepatureTransformer.initialize();
		return mqifXmlDepatureTransformer;
	}
	
	@Bean
	@Qualifier("mqifMessageProcessor")
	public MqifMessageProcessor  mqifMessageProcessor(){
		MqifMessageProcessor mqifMessageProcessor = new MqifMessageProcessor();
		mqifMessageProcessor.setXmlTransformer(mqifXmlTransformer());
    	mqifMessageProcessor.setXmlDepatureTransformer(mqifXmlDepatureTransformer());
		return mqifMessageProcessor;
	}
	
	@Bean
	@Qualifier("imfXmlTransformer")
	public XmlTransformer  imfXmlTransformer(){
		AdapterXmlTransformer imfXmlTransformer = new AdapterXmlTransformer();
		imfXmlTransformer.setXslPath("CGK_imf_2_aodb.xsl");
		imfXmlTransformer.initialize();
		return imfXmlTransformer;
	}
}
