package com.model_web.config;

import com.model_web.model.*;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.service.ServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import java.util.Properties;

public class HibernateUtil {

    private static final SessionFactory sessionFactory = buildSessionFactory();

    private static SessionFactory buildSessionFactory() {
        try {
            System.out.println("🔧 Initializing Hibernate...");
            System.out.println("📡 Using Supabase Transaction Pooler");

            Properties properties = new Properties();

            // Sử dụng Transaction Pooler của Supabase
            properties.setProperty("hibernate.dialect", "org.hibernate.dialect.PostgreSQLDialect");
            properties.setProperty("hibernate.connection.driver_class", "org.postgresql.Driver");
            properties.setProperty("hibernate.connection.url",
                    "jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:6543/postgres");
            properties.setProperty("hibernate.connection.username", "postgres.cahykacskytpfqpshcvi");
            properties.setProperty("hibernate.connection.password", "Lychanhyen1");
            properties.setProperty("hibernate.hbm2ddl.auto", "update");
            properties.setProperty("hibernate.show_sql", "true");
            properties.setProperty("hibernate.format_sql", "true");
            properties.setProperty("hibernate.current_session_context_class", "thread");
            properties.setProperty("hibernate.default_schema", "public");
            properties.setProperty("hibernate.hikari.minimumIdle", "5");
            properties.setProperty("hibernate.hikari.maximumPoolSize", "10");
            properties.setProperty("hibernate.hikari.idleTimeout", "300000");
            properties.setProperty("hibernate.hikari.connectionTimeout", "30000");

            try {
                Class.forName("org.postgresql.Driver");
                System.out.println("✅ PostgreSQL Driver loaded");
            } catch (ClassNotFoundException e) {
                System.err.println("❌ PostgreSQL Driver not found!");
                throw e;
            }

            Configuration configuration = new Configuration();
            configuration.setProperties(properties);

            configuration.addAnnotatedClass(User.class);
            configuration.addAnnotatedClass(Category.class);
            configuration.addAnnotatedClass(Product.class);
            configuration.addAnnotatedClass(Order.class);
            configuration.addAnnotatedClass(OrderDetail.class);

            ServiceRegistry serviceRegistry = new StandardServiceRegistryBuilder()
                    .applySettings(configuration.getProperties())
                    .build();

            SessionFactory factory = configuration.buildSessionFactory(serviceRegistry);

            // Test connection
            factory.openSession().close();
            System.out.println("✅ Connected to Supabase successfully!");

            return factory;

        } catch (Exception e) {
            System.err.println("❌ Initial SessionFactory creation failed: " + e.getMessage());
            e.printStackTrace();
            throw new ExceptionInInitializerError(e);
        }
    }

    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }

    public static void shutdown() {
        if (sessionFactory != null) {
            sessionFactory.close();
            System.out.println("✅ SessionFactory closed");
        }
    }
}