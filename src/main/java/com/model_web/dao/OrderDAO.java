package com.model_web.dao;

import com.model_web.model.Order;
import org.hibernate.Session;
import org.hibernate.query.Query;
import com.model_web.config.HibernateUtil;
import java.time.LocalDateTime;
import java.util.List;

public class OrderDAO extends BaseDAO<Order> {

    public OrderDAO() {
        super(Order.class);
    }

    public List<Order> findByUser(Long userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Order WHERE user.id = :userId ORDER BY orderDate DESC";
            Query<Order> query = session.createQuery(hql, Order.class);
            query.setParameter("userId", userId);
            return query.getResultList();
        }
    }

    public List<Order> findByStatus(String status) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Order WHERE status = :status ORDER BY orderDate DESC";
            Query<Order> query = session.createQuery(hql, Order.class);
            query.setParameter("status", status);
            return query.getResultList();
        }
    }

    public Order findByOrderCode(String orderCode) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Order WHERE orderCode = :orderCode";
            Query<Order> query = session.createQuery(hql, Order.class);
            query.setParameter("orderCode", orderCode);
            return query.uniqueResult();
        }
    }

    public void updateStatus(Long orderId, String status) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "UPDATE Order SET status = :status, updatedAt = CURRENT_TIMESTAMP WHERE id = :orderId";
            Query<?> query = session.createQuery(hql);
            query.setParameter("status", status);
            query.setParameter("orderId", orderId);
            session.beginTransaction();
            query.executeUpdate();
            session.getTransaction().commit();
        }
    }

    public List<Order> findOrdersBetween(LocalDateTime start, LocalDateTime end) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Order WHERE orderDate BETWEEN :start AND :end ORDER BY orderDate DESC";
            Query<Order> query = session.createQuery(hql, Order.class);
            query.setParameter("start", start);
            query.setParameter("end", end);
            return query.getResultList();
        }
    }
}