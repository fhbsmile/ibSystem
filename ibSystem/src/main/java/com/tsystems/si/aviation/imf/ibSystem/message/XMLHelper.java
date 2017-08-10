package com.tsystems.si.aviation.imf.ibSystem.message;

import java.util.List;

/*
 * Copyright 2014 T-systems.com All right reserved. This software is the
 * confidential and proprietary information of T-systems.com ("Confidential
 * Information"). You shall not disclose such Confidential Information and shall
 * use it only in accordance with the terms of the license agreement you entered
 * into with T-systems.com.
 */


import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.Node;

/**
 * class XMLHelper.java's description on implement: TODO description on implement 
 *
 * @author zzhao 2014-4-25 下午10:09:10
 */
public class XMLHelper {

	public static String parseValue(String input, String xpath) throws DocumentException{
		Document doc = DocumentHelper.parseText(input);
		Node node = doc.selectSingleNode(xpath);
		if(node==null){
			return null;
		}
		return node.getText().trim();
	}
	
	public static String setValue(String input, String xpath, String newValue) throws DocumentException{
		Document doc = DocumentHelper.parseText(input);
		Node node = doc.selectSingleNode(xpath);
		if(node==null){
			return null;
		}
		node.setText(newValue);
		return doc.asXML();
	}
	
}