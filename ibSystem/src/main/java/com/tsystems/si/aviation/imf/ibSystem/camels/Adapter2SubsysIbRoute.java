/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.camels
 * FileName  Adapter2SubsysIbRoute.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年8月10日 上午9:54:50
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年8月10日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.camels;

import org.apache.camel.builder.RouteBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
  * ClassName Adapter2SubsysIbRoute<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年8月10日 上午9:54:50
  *
  */

public class Adapter2SubsysIbRoute extends RouteBuilder {
	private static final Logger     logger               = LoggerFactory.getLogger(Adapter2SubsysIbRoute.class);
	/**
	  *<p> 
	  * Overriding_Method: configure<BR>
	  * Description:<BR>
	  * Overriding_Date: 2017年8月10日 上午9:54:50<BR></p>
	  * @throws Exception Adapter2SubsysIbRoute
	  * @see org.apache.camel.builder.RouteBuilder#configure()
	  */

	@Override
	public void configure() throws Exception {
		// TODO Auto-generated method stub
		from("jmsib:LQ.ADAPTER.IB_SS2").wireTap("jmsib:LQ.IMFLOG").dynamicRouter(method(SubSysDynamicRouterBean.class, "routeByReceiver"));
	}

}
