/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.message
 * FileName  XmlValidator.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年7月6日 下午2:48:12
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年7月6日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.message;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;

import javax.xml.XMLConstants;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.xml.sax.SAXException;

/**
  * ClassName XmlValidator<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年7月6日 下午2:48:12
  *
  */

public class XmlValidator {
	private static final Logger     logger               = LoggerFactory.getLogger(XmlValidator.class);
	public static Schema schema;
	static Validator validator ;
	static String schemaPath = "OverView.xsd";
	
	static{
/*		Resource resource =   new ClassPathResource(schemaPath);
		InputStream xslStream=null;
		try {
			xslStream = resource.getInputStream();
		} catch (IOException e) {
			
			logger.error(e.getMessage(), e);
			logger.error("System exit!");
			System.exit(0);
		}
		try {
			String sch = IOUtils.toString(xslStream, "utf-8");
		} catch (IOException e) {
			logger.error(e.getMessage(), e);
			logger.error("System exit!");
			System.exit(0);
		}*/
		SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
		try {
			schema = factory.newSchema(new StreamSource(new StringReader(IOUtils.toString(new ClassPathResource(schemaPath).getInputStream(), "utf-8"))));
			logger.info("schema:{}",schema);
		} catch (SAXException | IOException e) {
			// TODO Auto-generated catch block
			logger.error(e.getMessage(),e);
		}
		validator = schema.newValidator();
	}
	
	public static boolean validate(String xml){
		
/*		SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
		try {
			schema = factory.newSchema(new StreamSource(IOUtils.toString(new ClassPathResource(schemaPath).getInputStream(), "utf-8")));
			logger.info("schema:{}",schema);
		} catch (SAXException | IOException e) {
			// TODO Auto-generated catch block
			logger.error(e.getMessage(),e);
		}
		validator = schema.newValidator();*/
        try {
        	validator.validate(new StreamSource(new StringReader(xml)));
		} catch (SAXException | IOException e) {
			// TODO Auto-generated catch block
			logger.error(e.getMessage(),e);
			return false;
		}
		
		
		return true;
	}
}
