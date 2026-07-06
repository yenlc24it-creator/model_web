package com.model_web.dao;

import com.model_web.model.Category;
import org.hibernate.Session;
import org.hibernate.query.Query;
import com.model_web.config.HibernateUtil;
import java.util.List;
import java.util.Optional;

public class CategoryDAO extends BaseDAO<Category> {

    public CategoryDAO() {
        super(Category.class);
    }

    // Find by name
    public Optional<Category> findByName(String name) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Category WHERE name = :name";
            Query<Category> query = session.createQuery(hql, Category.class);
            query.setParameter("name", name);
            return query.uniqueResultOptional();
        }
    }

    // Find by slug
    public Optional<Category> findBySlug(String slug) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Category WHERE slug = :slug";
            Query<Category> query = session.createQuery(hql, Category.class);
            query.setParameter("slug", slug);
            return query.uniqueResultOptional();
        }
    }

    // Find active categories
    public List<Category> findActiveCategories() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Category WHERE active = true ORDER BY displayOrder ASC";
            Query<Category> query = session.createQuery(hql, Category.class);
            return query.getResultList();
        }
    }

    // Find categories with products
    public List<Category> findCategoriesWithProducts() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT c FROM Category c JOIN c.products p WHERE p.active = true ORDER BY c.displayOrder ASC";
            Query<Category> query = session.createQuery(hql, Category.class);
            return query.getResultList();
        }
    }
}