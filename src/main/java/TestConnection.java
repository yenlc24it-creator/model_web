package com.model_web.test;

import com.model_web.config.HibernateUtil;
import org.hibernate.Session;
import java.sql.Connection;
import java.sql.DatabaseMetaData;

public class TestConnection {
    public static void main(String[] args) {
        try {
            System.out.println("Testing Supabase connection...");

            // Test Hibernate connection
            Session session = HibernateUtil.getSessionFactory().openSession();

            // Get connection metadata
            Connection conn = session.doReturningWork(connection -> connection);
            DatabaseMetaData metaData = conn.getMetaData();

            System.out.println("✅ Connected successfully!");
            System.out.println("   Database: " + metaData.getDatabaseProductName());
            System.out.println("   Version: " + metaData.getDatabaseProductVersion());
            System.out.println("   URL: " + metaData.getURL());

            session.close();

        } catch (Exception e) {
            System.err.println("❌ Connection failed!");
            System.err.println("   Error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            HibernateUtil.shutdown();
        }
    }
}