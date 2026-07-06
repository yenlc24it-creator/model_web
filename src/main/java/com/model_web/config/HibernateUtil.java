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

            // Load properties from file
            Properties properties = new Properties();
            try {
                properties.load(HibernateUtil.class.getClassLoader()
                        .getResourceAsStream("hibernate.properties"));
                System.out.println("✅ hibernate.properties loaded successfully");
            } catch (Exception e) {
                System.err.println("❌ Failed to load hibernate.properties: " + e.getMessage());
                // Fallback: set properties directly
                properties.setProperty("hibernate.dialect", "org.hibernate.dialect.PostgreSQLDialect");
                properties.setProperty("hibernate.connection.driver_class", "org.postgresql.Driver");
                properties.setProperty("hibernate.connection.url",
                        "jdbc:postgresql://db.cahykacskytpfqpshcvi.supabase.co:5432/postgres");
                properties.setProperty("hibernate.connection.username", "postgres");
                properties.setProperty("hibernate.connection.password", "Lychanhyen1");
                properties.setProperty("hibernate.hbm2ddl.auto", "update");
                properties.setProperty("hibernate.show_sql", "true");
                System.out.println("✅ Using fallback properties");
            }

            // Load PostgreSQL driver
            try {
                Class.forName("org.postgresql.Driver");
                System.out.println("✅ PostgreSQL Driver loaded");
            } catch (ClassNotFoundException e) {
                System.err.println("❌ PostgreSQL Driver not found!");
                throw e;
            }

            Configuration configuration = new Configuration();
            configuration.setProperties(properties);

            // Add annotated classes
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