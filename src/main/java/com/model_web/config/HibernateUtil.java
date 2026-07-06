package com.model_web.config;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.service.ServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import java.util.Properties;

public class HibernateUtil {

    private static final SessionFactory sessionFactory = buildSessionFactory();

    private static SessionFactory buildSessionFactory() {
        try {
            Properties properties = new Properties();
            properties.load(HibernateUtil.class.getClassLoader()
                    .getResourceAsStream("hibernate.properties"));

            // Ensure PostgreSQL driver is loaded
            Class.forName("org.postgresql.Driver");

            Configuration configuration = new Configuration();
            configuration.setProperties(properties);

            // Add annotated classes
            configuration.addAnnotatedClass(com.model_web.model.User.class);
            configuration.addAnnotatedClass(com.model_web.model.Category.class);
            configuration.addAnnotatedClass(com.model_web.model.Product.class);
            configuration.addAnnotatedClass(com.model_web.model.Order.class);
            configuration.addAnnotatedClass(com.model_web.model.OrderDetail.class);

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