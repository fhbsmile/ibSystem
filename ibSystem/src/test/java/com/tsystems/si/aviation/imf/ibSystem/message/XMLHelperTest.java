/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.message
 * FileName  XMLHelperTest.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年8月2日 上午10:04:29
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年8月2日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.message;

import java.io.File;
import java.io.IOException;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.dom4j.DocumentException;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
  * ClassName XMLHelperTest<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年8月2日 上午10:04:29
  *
  */

public class XMLHelperTest {
	private static final Logger     logger               = LoggerFactory.getLogger(XMLHelperTest.class);
	
	@Test
	public void testParseValue(){
		File imf_BSS2_DataSet_IB_request_file = new File("file/imf/imf_BSS2_DataSet_IB_request.xml");
		try {
			String imf_BSS2_DataSet_IB_request = FileUtils.readFileToString(imf_BSS2_DataSet_IB_request_file, "utf-8");
			String value = XMLHelper.parseValue(imf_BSS2_DataSet_IB_request, "IMFRoot/Data/PrimaryKey/BasicDataKey/BasicDataCategory");
		    logger.info("Value:{}",value);
		} catch (IOException | DocumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	@Test
	public void testSetValue(){
		File imf_BSS2_DataSet_IB_request_file = new File("file/imf/imf_BSS2_DataSet_IB_request.xml");
		try {
			String imf_BSS2_DataSet_IB_request = FileUtils.readFileToString(imf_BSS2_DataSet_IB_request_file, "utf-8");
			String value = XMLHelper.setValue(imf_BSS2_DataSet_IB_request, "IMFRoot/Data/PrimaryKey/BasicDataKey/BasicDataCategory","HELLo");
		    logger.info("Value:{}",value);
		} catch (IOException | DocumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	@Test
	public void testSetValue2(){
		File imf_BSS2_DataSet_IB_request_file = new File("file/imf/imf_BSS2_DataSet_request2.xml");
		try {
			String imf_BSS2_DataSet_IB_request = FileUtils.readFileToString(imf_BSS2_DataSet_IB_request_file, "utf-8");
			String value = XMLHelper.setValue(imf_BSS2_DataSet_IB_request, "IMFRoot/Data/PrimaryKey/BasicDataKey/BasicDataCategory","HELLo");
		    logger.info("Value:{}",value);
		} catch (IOException | DocumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	@Test
	public void testSetValue3(){
		File imf_operation_template_file = new File("file/imf/imf_operation_template.xml");
		try {
			String imf_operation_template = FileUtils.readFileToString(imf_operation_template_file, "utf-8");
			String value = XMLHelper.setValue(imf_operation_template, "IMFRoot/Operation/Subscription","Accept");
		    logger.info("Value:{}",value);
		    String afterRm = RemoveEmptyTransformer.xmlFilter(value);
		    logger.info("afterRm:{}",afterRm);
		} catch (IOException | DocumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	
	@Test
	public void testSetValue4(){
		File imf_operation_template_file = new File("file/imf/imf_operation_template.xml");
		try {
			String imf_operation_template = FileUtils.readFileToString(imf_operation_template_file, "utf-8");
			String value = imf_operation_template;
		    logger.info("Value:{}",value);
		    //String afterRm =StringUtils.replacePattern(value, ">(@.*@)<", "");
		    String afterRm =value.replaceAll(">(@.*@)<", "><") ;
		    logger.info("afterRm:{}",afterRm);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
