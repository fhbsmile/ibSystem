/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.camels
 * FileName  IBRouteAdapter2Subsystem.java
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
  * ClassName IBRouteAdapter2Subsystem<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年8月10日 上午9:54:50
  *
  */

public class IBRouteAdapter2Subsystem extends RouteBuilder {
	private static final Logger     logger               = LoggerFactory.getLogger(IBRouteAdapter2Subsystem.class);
	private SubSysDynamicRouterBean subSysDynamicRouterBean;
	private ImfMessageIbProcessor imfMessageIbProcessor;
	
	/**
	  *<p> 
	  * Overriding_Method: configure<BR>
	  * Description:<BR>
	  * Overriding_Date: 2017年8月10日 上午9:54:50<BR></p>
	  * @throws Exception IBRouteAdapter2Subsystem
	  * @see org.apache.camel.builder.RouteBuilder#configure()
	  */

	@Override
	public void configure() throws Exception {

		from("jmsib:LQ.ADAPTER.IB_SS2").wireTap("jmsib:LQ.IMFLOG").bean(imfMessageIbProcessor, "ss2FilterAndProcess").dynamicRouter(method(subSysDynamicRouterBean, "routeByReceiver"));
		//from("jmsib:LQ.ADAPTER.IB_SS2").setHeader("JMSDestination", xpath("/IMFRoot/SysInfo/Receiver")).wireTap("jmsib:LQ.IMFLOG").to("jmsib:LQ.{header.JMSDestination}.OUT");
		from("jmsib:LQ.ADAPTER.IB_US").wireTap("jmsib:LQ.IMFLOG").bean(imfMessageIbProcessor, "usFilterAndProcess").dynamicRouter(method(subSysDynamicRouterBean, "routeByReceiver"));
		from("jmsib:LQ.ADAPTER.IB_SS1").wireTap("jmsib:LQ.IMFLOG").split().method(imfMessageIbProcessor, "ss1FilterAndDistrbuteProcess").wireTap("jmsib:LQ.IMFLOG").dynamicRouter(method(subSysDynamicRouterBean, "routeByReceiver"));
	}

	public SubSysDynamicRouterBean getSubSysDynamicRouterBean() {
		return subSysDynamicRouterBean;
	}

	public void setSubSysDynamicRouterBean(SubSysDynamicRouterBean subSysDynamicRouterBean) {
		this.subSysDynamicRouterBean = subSysDynamicRouterBean;
	}

	public ImfMessageIbProcessor getImfMessageIbProcessor() {
		return imfMessageIbProcessor;
	}

	public void setImfMessageIbProcessor(ImfMessageIbProcessor imfMessageIbProcessor) {
		this.imfMessageIbProcessor = imfMessageIbProcessor;
	}

}
