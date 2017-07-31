/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.mq
 * FileName  ActiveMQAdapterSender.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年7月5日 下午3:11:34
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年7月5日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.mq;

import java.util.ArrayList;
import java.util.List;

import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.Session;
import javax.jms.TextMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jms.core.JmsTemplate;
import org.springframework.jms.core.MessageCreator;

/**
  * ClassName ActiveMQAdapterSender<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年7月5日 下午3:11:34
  *
  */

public class ActiveMQAdapterSender implements ActiveMQSender {
	private static final Logger     logger               = LoggerFactory.getLogger(ActiveMQAdapterSender.class);
	
	private JmsTemplate jmsTemplate;
    private List<String> destinations = new ArrayList<String>();
    
    public void send(String message){
    	   logger.info("Send message :{}",new Object[]{message});
         for(String destination:this.destinations){
        	 logger.info("Send message to :{}",new Object[]{destination});
             jmsTemplate.send(destination,(Session session) -> session.createTextMessage(message));
             logger.info("Send message Finish.");
         }
       
    }

	/**
	  *<p> 
	  * Overriding_Method: addDestination<BR>
	  * Description:<BR>
	  * Overriding_Date: 2017年7月12日 下午3:02:27<BR></p>
	  * @param destination ActiveMQSender
	  * @see com.tsystems.si.aviation.imf.ibSystem.mq.ActiveMQSender#addDestination(java.lang.String)
	  */
	
	
	@Override
	public void addDestination(String destination) {
		this.destinations.add(destination);
		
	}

	/**
	  *<p> 
	  * Overriding_Method: send<BR>
	  * Description:<BR>
	  * Overriding_Date: 2017年7月12日 下午3:06:13<BR></p>
	  * @param destinations
	  * @param message ActiveMQSender
	  * @see com.tsystems.si.aviation.imf.ibSystem.mq.ActiveMQSender#send(java.util.List, java.lang.String)
	  */
	
	
	@Override
	public void send(List<String> destinations, String message) {
		logger.info("Send message :{}",new Object[]{message});
        for(String destination:destinations){
       	 logger.info("Send message to :{}",new Object[]{destination});
            jmsTemplate.send(destination,(Session session) -> session.createTextMessage(message));
            logger.info("Send message Finish.");
        }
		
	}

	/**
	  *<p> 
	  * Overriding_Method: send<BR>
	  * Description:<BR>
	  * Overriding_Date: 2017年7月12日 下午3:09:15<BR></p>
	  * @param destination
	  * @param message ActiveMQSender
	  * @see com.tsystems.si.aviation.imf.ibSystem.mq.ActiveMQSender#send(java.lang.String, java.lang.String)
	  */
	
	
	@Override
	public void send(String destination, String message) {
       	 logger.info("Send message to :{}",new Object[]{destination});
       	 logger.info("message:\n{}",new Object[]{message});
            jmsTemplate.send(destination,(Session session) -> session.createTextMessage(message));
            logger.info("Send message Finish.");
        }

	public JmsTemplate getJmsTemplate() {
		return jmsTemplate;
	}

	public void setJmsTemplate(JmsTemplate jmsTemplate) {
		this.jmsTemplate = jmsTemplate;
	}

	public List<String> getDestinations() {
		return destinations;
	}

	public void setDestinations(List<String> destinations) {
		this.destinations = destinations;
	}
		
	}
	
	

