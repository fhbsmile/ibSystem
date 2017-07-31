package com.tsystems.si.aviation.imf.ibSystem;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ImportResource;

@SpringBootApplication
//@ImportResource("ActiveMQConfiguration.xml")
public class IbSystemApplication {

	public static void main(String[] args) {
		SpringApplication.run(IbSystemApplication.class, args);
	}
}
