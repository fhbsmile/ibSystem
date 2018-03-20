package com.tsystems.si.aviation.imf.ibSystem.configurations;

import java.util.Properties;

import javax.sql.DataSource;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.jdbc.datasource.embedded.EmbeddedDatabaseBuilder;
import org.springframework.jdbc.datasource.embedded.EmbeddedDatabaseType;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import com.alibaba.druid.pool.DruidDataSource;

@Configuration
@ComponentScan("com.tsystems.si.aviation.imf.ibSystem.db")
@EnableJpaRepositories(basePackages="com.tsystems.si.aviation.imf.ibSystem.db")
@EnableTransactionManagement
public class DBConfiguration {

	
/*	@Bean
	public DataSource dataSource() {
		EmbeddedDatabaseBuilder builder = new EmbeddedDatabaseBuilder();
		return builder.setType(EmbeddedDatabaseType.HSQL).build();
	}*/
	
/*	@Bean
    public DataSource dataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName("com.mysql.jdbc.Driver");
        dataSource.setUrl("jdbc:mysql://10.25.153.215:3306/ibSystem?useUnicode=true&characterEncoding=UTF-8&useSSL=false");// 填入你的mysql的访问url
        dataSource.setUsername("ibsystem");// mysql用户名
        dataSource.setPassword("tsystems");// mysql访问密码
      
        return dataSource;
    }*/
	
	@Bean
    public DataSource dataSource() {
        DruidDataSource dataSource = new DruidDataSource();
        dataSource.setName("ibSystem");
        dataSource.setDriverClassName("com.mysql.jdbc.Driver");
        dataSource.setUrl("jdbc:mysql://10.25.153.215:3306/ibSystem?useUnicode=true&characterEncoding=UTF-8&useSSL=false");// 填入你的mysql的访问url
        dataSource.setUsername("ibsystem");// mysql用户名
        dataSource.setPassword("tsystems");// mysql访问密码
      
        return dataSource;
    }

	@Bean
	public LocalContainerEntityManagerFactoryBean entityManagerFactory() {
			HibernateJpaVendorAdapter vendorAdapter = new HibernateJpaVendorAdapter();
			vendorAdapter.setGenerateDdl(true);
			LocalContainerEntityManagerFactoryBean factory = new LocalContainerEntityManagerFactoryBean();
			factory.setJpaProperties(hibProperties());
			factory.setJpaVendorAdapter(vendorAdapter);
			factory.setPackagesToScan("com.tsystems.si.aviation.imf.ibSystem.db.domain");
			factory.setDataSource(dataSource());
			return factory;
	}
	@Bean
	public PlatformTransactionManager transactionManager() {
			JpaTransactionManager txManager = new JpaTransactionManager();
			txManager.setEntityManagerFactory(entityManagerFactory().getObject());
			return txManager;
	}
	
    private Properties hibProperties() {
        Properties properties = new Properties();
        properties.put("hibernate.dialect", "org.hibernate.dialect.MySQL5InnoDBDialect");
        properties.put("hibernate.show_sql", true);
        properties.put("hibernate.format_sql", true);
        properties.put("hibernate.hbm2ddl.auto", "none");
       // properties.put("hibernate.show_sql", true);
        return properties;  
    }
}
