/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.db.web
 * FileName  CamelRouteController.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年8月2日 上午11:31:40
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年8月2日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.db.web;

import java.util.ArrayList;
import java.util.List;

import org.apache.camel.CamelContext;
import org.apache.camel.Route;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
  * ClassName CamelRouteController<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年8月2日 上午11:31:40
  *
  */

public class CamelRouteController {
	private static final Logger     logger               = LoggerFactory.getLogger(CamelRouteController.class);
	@Autowired
    @Qualifier("camelContext")
    private CamelContext camelContext;

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String index(Model model) {
        return dashboard(model);
    }

    @RequestMapping(value = "/dashboard", method = RequestMethod.GET)
    public String dashboard(Model model) {


        List<Route> routes = camelContext.getRoutes();
        List<RouteStatus> routeStatuses = new ArrayList<RouteStatus>();
        for (Route route : routes) {
            RouteStatus rs = new RouteStatus();
            rs.setId(route.getId());
            rs.setServiceStatus(camelContext.getRouteStatus(route.getId()));
            routeStatuses.add(rs);
        }

        model.addAttribute("routeStatuses", routeStatuses);

        return "dashboard";
    }

    @RequestMapping(value = "/dashboard/{routeId}/start", method = RequestMethod.GET)
    public String startRoute(@PathVariable String routeId) {
        try {
            camelContext.startRoute(routeId);

            logger.info("camel context is starting route [" + routeId + "]");
        } catch (Exception e) {
            logger.error("failed to start camel context [" + camelContext + "]", e);
        }
        return "redirect:/dashboard";
    }

    @RequestMapping(value = "/dashboard/{routeId}/stop", method = RequestMethod.GET)
    public String stopRoute(@PathVariable String routeId) {
        try {
            camelContext.stopRoute(routeId);

            logger.info("camel context is stopping route [" + routeId + "]");
        } catch (Exception e) {
            logger.error("failed to stop camel context [" + camelContext + "]", e);
        }
        return "redirect:/dashboard";
    }
}
