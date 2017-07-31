/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.adapter
 * FileName  AdapterInterfaceProcesser.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年7月12日 下午1:32:49
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年7月12日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.adapter;

/**
  * ClassName AdapterInterfaceProcesser<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年7月12日 下午1:32:49
  *
  */

public class AdapterInterfaceProcesser implements InterfaceProcesser {
    private String adapterInterfaceProcesserName;
	private MessageProcesser messageProcesser;
	//private ActiveMQSender activeMQSender;
	/**
	  *<p> 
	  * Overriding_Method: initialize<BR>
	  * Description:<BR>
	  * Overriding_Date: 2017年7月12日 下午1:32:49<BR></p> AdapterInterfaceProcesser
	  * @see com.tsystems.si.aviation.imf.ibSystem.adapter.InterfaceProcesser#initialize()
	  */

	@Override
	public void initialize() {
		// TODO Auto-generated method stub

	}

	/**
	  *<p> 
	  * Overriding_Method: handleMessage<BR>
	  * Description:<BR>
	  * Overriding_Date: 2017年7月12日 下午1:32:49<BR></p> AdapterInterfaceProcesser
	  * @see com.tsystems.si.aviation.imf.ibSystem.adapter.InterfaceProcesser#handleMessage()
	  */

	@Override
	public void handleMessage(String message) {
		messageProcesser.process(message);
	}

	public MessageProcesser getMessageProcesser() {
		return messageProcesser;
	}

	public void setMessageProcesser(MessageProcesser messageProcesser) {
		this.messageProcesser = messageProcesser;
	}

	public String getAdapterInterfaceProcesserName() {
		return adapterInterfaceProcesserName;
	}

	public void setAdapterInterfaceProcesserName(String adapterInterfaceProcesserName) {
		this.adapterInterfaceProcesserName = adapterInterfaceProcesserName;
	}

}
