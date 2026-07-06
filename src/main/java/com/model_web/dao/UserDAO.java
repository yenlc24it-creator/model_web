package com.model_web.dao;

import com.model_web.model.User;
import org.hibernate.Session;
import org.hibernate.query.Query;
import com.model_web.config.HibernateUtil;
import java.util.List;
import java.util.Optional;

public class UserDAO extends BaseDAO<User> {

    public UserDAO() {
        super(User.class);
    }

    public Optional<User> findByUsername(String username) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM User WHERE username = :username";
            Query<User> query = session.createQuery(hql, User.class);
            query.setParameter("username", username);
            return query.uniqueResultOptional();
        }
    }

    public Optional<User> findByEmail(String email) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM User WHERE email = :email";
            Query<User> query = session.createQuery(hql, User.class);
            query.setParameter("email", email);
            return query.uniqueResultOptional();
        }
    }

    public boolean existsByUsername(String username) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT COUNT(*) FROM User WHERE username = :username";
            Query<Long> query = session.createQuery(hql, Long.class);
            query.setParameter("username", username);
            return query.getSingleResult() > 0;
        }
    }

    public boolean existsByEmail(String email) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT COUNT(*) FROM User WHERE email = :email";
            Query<Long> query = session.createQuery(hql, Long.class);
            query.setParameter("email", email);
            return query.getSingleResult() > 0;
        }
    }

    public List<User> findActiveUsers() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM User WHERE active = true";
            Query<User> query = session.createQuery(hql, User.class);
            return query.getResultList();
        }
    }

    public List<User> findByRole(String role) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM User WHERE role = :role";
            Query<User> query = session.createQuery(hql, User.class);
            query.setParameter("role", role);
            return query.getResultList();
        }
    }
}