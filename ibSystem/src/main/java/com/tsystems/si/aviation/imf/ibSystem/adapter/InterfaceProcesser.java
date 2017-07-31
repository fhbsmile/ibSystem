/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.adapter
 * FileName  InterfaceProcesser.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年7月12日 上午10:59:36
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年7月12日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.adapter;

/**
  * ClassName InterfaceProcesser<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年7月12日 上午10:59:36
  *
  */

public interface InterfaceProcesser {
	void initialize();
	void handleMessage(String message);
}
