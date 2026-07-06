package com.model_web.dao;

import com.model_web.model.Product;
import org.hibernate.Session;
import org.hibernate.query.Query;
import com.model_web.config.HibernateUtil;
import java.math.BigDecimal;
import java.util.List;  // ← THÊM DÒNG NÀY
import java.util.Optional;

public class ProductDAO extends BaseDAO<Product> {

    public ProductDAO() {
        super(Product.class);
    }

    // Find by slug
    public Optional<Product> findBySlug(String slug) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Product WHERE slug = :slug";
            Query<Product> query = session.createQuery(hql, Product.class);
            query.setParameter("slug", slug);
            return query.uniqueResultOptional();
        }
    }

    // Find active products
    public List<Product> findActiveProducts() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Product WHERE active = true ORDER BY createdAt DESC";
            Query<Product> query = session.createQuery(hql, Product.class);
            return query.getResultList();
        }
    }

    // Find by category
    public List<Product> findByCategory(Long categoryId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Product WHERE category.id = :categoryId AND active = true";
            Query<Product> query = session.createQuery(hql, Product.class);
            query.setParameter("categoryId", categoryId);
            return query.getResultList();
        }
    }

    // Find products on sale
    public List<Product> findProductsOnSale() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Product WHERE active = true AND salePrice IS NOT NULL AND salePrice > 0 AND salePrice < price";
            Query<Product> query = session.createQuery(hql, Product.class);
            return query.getResultList();
        }
    }

    // Search products
    public List<Product> search(String keyword) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Product WHERE active = true AND (LOWER(name) LIKE :keyword OR LOWER(description) LIKE :keyword)";
            Query<Product> query = session.createQuery(hql, Product.class);
            query.setParameter("keyword", "%" + keyword.toLowerCase() + "%");
            return query.getResultList();
        }
    }

    // Find products with price range
    public List<Product> findByPriceRange(BigDecimal minPrice, BigDecimal maxPrice) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Product WHERE active = true AND price BETWEEN :minPrice AND :maxPrice";
            Query<Product> query = session.createQuery(hql, Product.class);
            query.setParameter("minPrice", minPrice);
            query.setParameter("maxPrice", maxPrice);
            return query.getResultList();
        }
    }

    // Get newest products
    public List<Product> findNewestProducts(int limit) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Product WHERE active = true ORDER BY createdAt DESC";
            Query<Product> query = session.createQuery(hql, Product.class);
            query.setMaxResults(limit);
            return query.getResultList();
        }
    }

    // Get best selling products
    public List<Product> findBestSellingProducts(int limit) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT p FROM Product p JOIN p.orderDetails od GROUP BY p ORDER BY SUM(od.quantity) DESC";
            Query<Product> query = session.createQuery(hql, Product.class);
            query.setMaxResults(limit);
            return query.getResultList();
        }
    }

    // Update view count
    public void incrementViewCount(Long productId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "UPDATE Product SET views = views + 1 WHERE id = :productId";
            Query<?> query = session.createQuery(hql);
            query.setParameter("productId", productId);
            session.beginTransaction();
            query.executeUpdate();
            session.getTransaction().commit();
        }
    }

    // Check stock
    public boolean hasStock(Long productId, int quantity) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT stock FROM Product WHERE id = :productId";
            Query<Integer> query = session.createQuery(hql, Integer.class);
            query.setParameter("productId", productId);
            Integer stock = query.getSingleResult();
            return stock != null && stock >= quantity;
        }
    }

    // Reduce stock
    public void reduceStock(Long productId, int quantity) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "UPDATE Product SET stock = stock - :quantity WHERE id = :productId AND stock >= :quantity";
            Query<?> query = session.createQuery(hql);
            query.setParameter("quantity", quantity);
            query.setParameter("productId", productId);
            session.beginTransaction();
            int updated = query.executeUpdate();
            session.getTransaction().commit();
            if (updated == 0) {
                throw new RuntimeException("Not enough stock for product id: " + productId);
            }
        }
    }
}