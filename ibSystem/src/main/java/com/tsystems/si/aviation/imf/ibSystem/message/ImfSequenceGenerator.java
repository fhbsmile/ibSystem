package com.tsystems.si.aviation.imf.ibSystem.message;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Random;
import java.util.concurrent.atomic.AtomicInteger;

import org.apache.commons.lang3.StringUtils;

/**
 * A tool to generate an automatic increased number
 * 
 * @version 2.0.1
 * @author cchen2 2012-10-30 11:49:32 AM
 */
public class ImfSequenceGenerator {

    private AtomicInteger    i         = new AtomicInteger(1);

    private static final int MAX_VALUE = 9999999;

    /**
     * Generate an automatic increased number, notice that it is a synchronized method
     */
    public String generateNextNumber() {
        if (i.get() > MAX_VALUE) {
            i.set(1);
        }

        if (true) {
            String ip = "";
            try {
                ip = InetAddress.getLocalHost().getHostAddress();
            } catch (UnknownHostException e) {
            }

            return StringUtils.substringAfterLast(ip, ".") + Math.abs(new Random().nextInt(1000));
        }else {
            return i.incrementAndGet() + "";
        }
    }
}
