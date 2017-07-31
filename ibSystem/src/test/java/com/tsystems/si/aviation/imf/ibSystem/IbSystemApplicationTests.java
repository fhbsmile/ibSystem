package com.tsystems.si.aviation.imf.ibSystem;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Configuration;
import org.springframework.test.context.junit4.SpringRunner;

import com.tsystems.si.aviation.imf.ibSystem.configurations.ActiveMQConfiguration;

@RunWith(SpringRunner.class)
@SpringBootTest
@Configuration("ActiveMQConfiguration.class")
public class IbSystemApplicationTests {

	@Test
	public void contextLoads() {
	}

}
