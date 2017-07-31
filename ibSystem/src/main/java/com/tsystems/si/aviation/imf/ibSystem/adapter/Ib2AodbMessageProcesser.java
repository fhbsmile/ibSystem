/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.adapter
 * FileName  Ib2AodbMessageProcesser.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年7月12日 下午3:28:50
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年7月12日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.adapter;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.tsystems.si.aviation.imf.ibSystem.db.domain.LogImfMessage;
import com.tsystems.si.aviation.imf.ibSystem.db.domain.LogMqifMessage;
import com.tsystems.si.aviation.imf.ibSystem.message.ImfMessageUtil;
import com.tsystems.si.aviation.imf.ibSystem.message.MqifMessageUtil;
import com.tsystems.si.aviation.imf.ibSystem.message.XmlTransformer;
import com.tsystems.si.aviation.imf.ibSystem.message.XmlValidator;
import com.tsystems.si.aviation.imf.ibSystem.mq.ActiveMQSender;

/**
  * ClassName Ib2AodbMessageProcesser<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年7月12日 下午3:28:50
  *
  */

public class Ib2AodbMessageProcesser implements MessageProcesser {
	private static final Logger     logger               = LoggerFactory.getLogger(Ib2AodbMessageProcesser.class);
	private XmlTransformer xmlTransformer;
	private ActiveMQSender activeMQSender;
	private boolean validateIMFMessageindcator;
	/**
	  *<p> 
	  * Overriding_Method: process<BR>
	  * Description:<BR>
	  * Overriding_Date: 2017年7月12日 下午3:28:51<BR></p>
	  * @param message
	  * @return Ib2AodbMessageProcesser
	  * @see com.tsystems.si.aviation.imf.ibSystem.adapter.MessageProcesser#process(java.lang.String)
	  */

	@Override
	public String process(String message) {
		boolean validate =true;
		if(validateIMFMessageindcator){
			validate = XmlValidator.validate(message);
		}
        if(validate){
        	String mqifStyleMessage =	xmlTransformer.transform(message);
        	LogImfMessage logImfMessage = ImfMessageUtil.parseImfXmlMessage(message);
        	List<String> requests = MqifMessageUtil.splitXssRequest(mqifStyleMessage, logImfMessage.getImfServiceType(), message);
        	for(String request: requests){
                LogMqifMessage logMqifMessage = MqifMessageUtil.parseMqifXmlMessage(request);
                String destination = MqifMessageUtil.getDestinationByMqifMessage(logMqifMessage);
                activeMQSender.send(destination, request); 
        	}
  
         
        }
        
        return null;
	}

	/**
	  *<p> 
	  * Overriding_Method: initialize<BR>
	  * Description:<BR>
	  * Overriding_Date: 2017年7月12日 下午3:28:51<BR></p> Ib2AodbMessageProcesser
	  * @see com.tsystems.si.aviation.imf.ibSystem.adapter.MessageProcesser#initialize()
	  */

	@Override
	public void initialize() {
		// TODO Auto-generated method stub

	}

}
