/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.message
 * FileName  Imf2AodbSs2CategoryMapping.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年8月1日 下午2:31:22
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年8月1日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.message;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;

/**
  * ClassName Imf2AodbSs2CategoryMapping<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年8月1日 下午2:31:22
  *
  */

public class Imf2AodbSs2CategoryMapping {
	private static Map<String, String> ss2Category = new HashMap<String, String>();
    static {
        ss2Category.put("Aircraft", "ref_aircraft");
        ss2Category.put("AircraftType", "ref_aircrafttype");
        ss2Category.put("Terminal", "ref_terminal");
        ss2Category.put("Runway", "ref_runway");
        ss2Category.put("Stand", "ref_stand");
        ss2Category.put("CheckInDesk", "ref_counter");
        ss2Category.put("BaggageMakeup", "ref_departurebelt");
        ss2Category.put("Gate", "ref_gate");
        ss2Category.put("BaggageReclaim", "ref_baggagebelt");
        ss2Category.put("Handler", "ref_handlingagent");
        ss2Category.put("Airport", "ref_airport");
        ss2Category.put("PassengerClass", "ref_passengerclass");
        ss2Category.put("FlightOperationCode", "ref_remark");
        ss2Category.put("Country", "ref_country");
        ss2Category.put("FlightServiceType", "ref_servicetypecode");
        ss2Category.put("DelayCode", "ref_delayreason");
        ss2Category.put("Airline", "ref_airline");

        ss2Category.put("Closing", "rm_closing");
        ss2Category.put("CommonCheckInDesk", "pl_desk");
    }

    public static List<String> getSs2Category(String imfMessage, String servicetype) {
        String category = null;

        if (servicetype.equalsIgnoreCase("BSS2")) {
            category = StringUtils.substringBetween(imfMessage, "<BasicDataCategory>", "</BasicDataCategory>");
        }

        else if (servicetype.equalsIgnoreCase("RSS2")) {
            category = StringUtils.substringBetween(imfMessage, "<ResourceCategory>", "</ResourceCategory>");
        }

        List<String> xss2Category = new ArrayList<String>();
        if (StringUtils.isNotEmpty(category)) {
            for (String datatype : StringUtils.split(StringUtils.deleteWhitespace(category), ",")) {
                String aodb_datatype = ss2Category.get(datatype);
                if (StringUtils.isNotEmpty(aodb_datatype)) {
                    xss2Category.add(aodb_datatype);
                }
            }
        }

        return xss2Category;
    }
}
