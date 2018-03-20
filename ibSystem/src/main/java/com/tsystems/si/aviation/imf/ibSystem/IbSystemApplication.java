package com.tsystems.si.aviation.imf.ibSystem;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ImportResource;

import com.tsystems.si.aviation.imf.ibSystem.camels.CamelAndActiveMQConfiguration;

@SpringBootApplication(scanBasePackages={"com.tsystems.si.aviation.imf.ibSystem.configurations"})
//@ImportResource("CamelAndActiveMQConfiguration.xml")
public class IbSystemApplication {

	public static void main(String[] args) {
		SpringApplication.run(IbSystemApplication.class, args);
	}
}
