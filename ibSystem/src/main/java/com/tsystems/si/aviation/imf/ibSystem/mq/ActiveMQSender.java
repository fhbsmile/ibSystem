/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.mq
 * FileName  ActiveMQSender.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年7月12日 下午2:13:31
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年7月12日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.mq;

import java.util.List;

/**
  * ClassName ActiveMQSender<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年7月12日 下午2:13:31
  *
  */

public interface ActiveMQSender {
	void send(String message);
	void send(List<String> destinations,String message);
	void send(String destination,String message);
	void addDestination(String destination);
}
