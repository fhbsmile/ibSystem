/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.message
 * FileName  XsltUtilTest.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年7月6日 下午7:09:19
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年7月6日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.message;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
  * ClassName XsltUtilTest<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年7月6日 下午7:09:19
  *
  */

public class XsltUtilTest {
	private static final Logger logger = LoggerFactory.getLogger(XsltUtilTest.class);
	
	@Test
	public void testConvert(){
		String utcDateTime="2017-04-10T14:44:47Z";
		String localDateTime = XsltUtil.convertUTC2Time(utcDateTime);
		logger.info("localDateTime:{}",localDateTime);
	}
}
