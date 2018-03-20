/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.camels
 * FileName  ImfMessageIbProcessor.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年8月10日 上午10:04:54
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年8月10日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.camels;

import java.util.ArrayList;
import java.util.List;

import org.apache.camel.Exchange;
import org.apache.camel.Processor;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.tsystems.si.aviation.imf.ibSystem.message.MqifMessageUtil;
import com.tsystems.si.aviation.imf.ibSystem.message.XmlValidator;

/**
  * ClassName ImfMessageIbProcessor<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年8月10日 上午10:04:54
  *
  */

public class ImfMessageIbProcessor implements Processor {
	private static final Logger     logger               = LoggerFactory.getLogger(ImfMessageIbProcessor.class);
	private InterfaceHandleContainer interfaceHandleContainer;
	/**
	  *<p> 
	  * Overriding_Method: process<BR>
	  * Description:<BR>
	  * Overriding_Date: 2017年8月10日 上午10:04:54<BR></p>
	  * @param exchange
	  * @throws Exception ImfMessageIbProcessor
	  * @see org.apache.camel.Processor#process(org.apache.camel.Exchange)
	  */

	@Override
	public void process(Exchange exchange) throws Exception {
		// TODO Auto-generated method stub

	}

	
	public List<String> ss1FilterAndDistrbuteProcess(String message){
		logger.info("Received SS1 Message:{}",message);
		List<String> messageList = new ArrayList<>();
		String serviceType =StringUtils.substringBetween(message, "<ServiceType>", "</ServiceType>");
		if(serviceType.contains("FSS")){
			for(String interfaceName:interfaceHandleContainer.getSubscribedInterfaceListByServiceType("FSS")){
				//如果航班时间在范围内，则加入到列表中，并且接收者替换为当前接口名
				if(interfaceHandleContainer.isMatchInterfaceRule(interfaceName, message)){
					messageList.add(StringUtils.replace(message, "<Receiver>IB</Receiver>", "<Receiver>"+interfaceName+""));
				}
			}
		}else if(serviceType.contains("BSS")){
			for(String interfaceName:interfaceHandleContainer.getSubscribedInterfaceListByServiceType("BSS")){
				//如果数据种类在范围内，则加入到列表中，并且接收者替换为当前接口名
				if(interfaceHandleContainer.isMatchInterfaceRule(interfaceName, message)){
					messageList.add(StringUtils.replace(message, "<Receiver>IB</Receiver>", "<Receiver>"+interfaceName+""));
				}
			}
		}else if(serviceType.contains("RSS")){
			for(String interfaceName:interfaceHandleContainer.getSubscribedInterfaceListByServiceType("RSS")){
				//如果数据种类在范围内，则加入到列表中，并且接收者替换为当前接口名
				if(interfaceHandleContainer.isMatchInterfaceRule(interfaceName, message)){
					messageList.add(StringUtils.replace(message, "<Receiver>IB</Receiver>", "<Receiver>"+interfaceName+""));
				}
			}
		}
		
		
		
        return messageList;
	}
	
	public String ss2FilterAndProcess(String message){
		logger.info("Received SS2 Message:{}",message);
		String intName =StringUtils.substringBetween(message, "<Receiver>", "</Receiver>");
		if(interfaceHandleContainer.hasInterface(intName) && interfaceHandleContainer.isMatchInterfaceRule(intName, message)){
			return message;
		}
				
        return null;
	}
	
	public String usFilterAndProcess(String message){
		logger.info("Received FUS Message:{}",message);
		String serviceType =StringUtils.substringBetween(message, "<ServiceType>", "</ServiceType>");
		logger.info("ServiceType:{}",serviceType);
		if(serviceType.contains("FSS")){
				//如果航班时间在范围内，则加入到列表中，并且接收者替换为当前接口名
				if(true){

				}
		}else if(serviceType.contains("BSS")){
				//如果数据种类在范围内，则加入到列表中，并且接收者替换为当前接口名
				if(true){
;
				}
		}else if(serviceType.contains("RSS")){
				//如果数据种类在范围内，则加入到列表中，并且接收者替换为当前接口名
				if(true){

				}
		}
		
		
		
        return message;
	}


	public InterfaceHandleContainer getInterfaceHandleContainer() {
		return interfaceHandleContainer;
	}


	public void setInterfaceHandleContainer(InterfaceHandleContainer interfaceHandleContainer) {
		this.interfaceHandleContainer = interfaceHandleContainer;
	}
	
	
}
