package com.vts.rpb.cfg;

import java.util.Properties;

import javax.naming.NamingException;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.core.env.Environment;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.JpaVendorAdapter;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import com.zaxxer.hikari.HikariDataSource;

import jakarta.persistence.EntityManagerFactory;

@Configuration
@EnableJpaRepositories(basePackages = "com.vts.*",entityManagerFactoryRef = "EntityManagerMySql",transactionManagerRef = "transactionManagerMySql")
@EnableTransactionManagement
public class JpaMysqlConfiguration 
{
	@Autowired
    private Environment env;
	
	 @Primary
	 @Bean
	 public DataSource mysqlDataSource() 
	 {
        HikariDataSource dataSource = new HikariDataSource();
        dataSource.setDriverClassName(env.getProperty("app.datasource.mysql.driver-class-name"));
        dataSource.setJdbcUrl(env.getProperty("app.datasource.mysql.url"));
        dataSource.setUsername(env.getProperty("app.datasource.mysql.username"));
        dataSource.setPassword(env.getProperty("app.datasource.mysql.password"));
        return dataSource;
	 }
	 

	 @Primary
	 @Bean("EntityManagerMySql")
	 public LocalContainerEntityManagerFactoryBean entityManagerFactory() throws NamingException 
	 {
        LocalContainerEntityManagerFactoryBean factoryBean = new LocalContainerEntityManagerFactoryBean();
        factoryBean.setDataSource(mysqlDataSource());
        factoryBean.setPackagesToScan(new String[] { "com.vts.*" });
        factoryBean.setJpaVendorAdapter(jpaVendorAdapter());
        factoryBean.setJpaProperties(jpaProperties());
        return factoryBean;
	 }
	 
	   
	 @Primary
	 @Bean
	 public JpaVendorAdapter jpaVendorAdapter() 
	 {
        HibernateJpaVendorAdapter hibernateJpaVendorAdapter = new HibernateJpaVendorAdapter();
        return hibernateJpaVendorAdapter;
	 }
	 
	   
	 private Properties jpaProperties() 
	 {
        Properties properties = new Properties();
        properties.put("hibernate.dialect", "org.hibernate.dialect.MySQLDialect");
        properties.put("hibernate.hbm2ddl.auto", "validate");
        properties.put("hibernate.show_sql", "true");
        return properties;
	 }
    
    @Primary
    @Bean
    public PlatformTransactionManager transactionManagerMySql(EntityManagerFactory emf) 
    {
        JpaTransactionManager txManager = new JpaTransactionManager();
        txManager.setEntityManagerFactory(emf);
        return txManager;
    }
}
