/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.mq
 * FileName  ActiveMQAdapterSimpleListener.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年7月4日 下午8:37:42
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年7月4日       Wangxin          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.mq;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.tsystems.si.aviation.imf.ibSystem.adapter.MessageProcesser;

/**
  * ClassName ActiveMQAdapterSimpleListener<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年7月4日 下午8:37:42
  *
  */

public class ActiveMQAdapterSimpleListener {
	private static final Logger     logger               = LoggerFactory.getLogger(ActiveMQAdapterSimpleListener.class);
	
	public MessageProcesser messageProcesser;
	
	public void handleMessage(String message) {
		
	}
}
