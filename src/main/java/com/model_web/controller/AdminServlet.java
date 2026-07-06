package com.model_web.controller;

import com.model_web.dao.*;
import com.model_web.model.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "AdminServlet", urlPatterns = {"/admin", "/admin/*"})
public class AdminServlet extends HttpServlet {

    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;
    private OrderDAO orderDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
        orderDAO = new OrderDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            showDashboard(request, response);
        } else {
            switch (pathInfo) {
                case "/products":
                    showProducts(request, response);
                    break;
                case "/categories":
                    showCategories(request, response);
                    break;
                case "/orders":
                    showOrders(request, response);
                    break;
                case "/users":
                    showUsers(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        if (pathInfo == null) {
            response.sendRedirect(request.getContextPath() + "/admin");
            return;
        }

        switch (pathInfo) {
            case "/product/add":
                addProduct(request, response);
                break;
            case "/product/update":
                updateProduct(request, response);
                break;
            case "/product/delete":
                deleteProduct(request, response);
                break;
            case "/category/add":
                addCategory(request, response);
                break;
            case "/category/update":
                updateCategory(request, response);
                break;
            case "/category/delete":
                deleteCategory(request, response);
                break;
            case "/order/update-status":
                updateOrderStatus(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        long totalProducts = productDAO.count();
        long totalUsers = userDAO.count();
        List<Order> allOrders = orderDAO.findAll();
        long totalOrders = allOrders.size();

        BigDecimal totalRevenue = allOrders.stream()
                .filter(o -> "DELIVERED".equals(o.getStatus()))
                .map(Order::getTotalAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        List<Order> recentOrders = allOrders.stream()
                .limit(10)
                .collect(java.util.stream.Collectors.toList());

        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("recentOrders", recentOrders);

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }

    private void showProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Product> products = productDAO.findAll();
        request.setAttribute("products", products);
        request.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(request, response);
    }

    private void showCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Category> categories = categoryDAO.findAll();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/WEB-INF/views/admin/categories.jsp").forward(request, response);
    }

    private void showOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String status = request.getParameter("status");
        List<Order> orders;

        if (status != null && !status.isEmpty()) {
            orders = orderDAO.findByStatus(status);
        } else {
            orders = orderDAO.findAll();
        }

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/WEB-INF/views/admin/orders.jsp").forward(request, response);
    }

    private void showUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<User> users = userDAO.findAll();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String name = request.getParameter("name");
        String slug = request.getParameter("slug");
        String description = request.getParameter("description");
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        String salePriceStr = request.getParameter("salePrice");
        int stock = Integer.parseInt(request.getParameter("stock"));
        Long categoryId = Long.parseLong(request.getParameter("categoryId"));
        String imageUrl = request.getParameter("imageUrl");

        Product product = new Product();
        product.setName(name);
        product.setSlug(slug);
        product.setDescription(description);
        product.setPrice(price);

        if (salePriceStr != null && !salePriceStr.isEmpty()) {
            product.setSalePrice(new BigDecimal(salePriceStr));
        }

        product.setStock(stock);
        product.setImageUrl(imageUrl);
        product.setActive(true);

        Category category = categoryDAO.findById(categoryId).orElse(null);
        product.setCategory(category);

        productDAO.save(product);

        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Long id = Long.parseLong(request.getParameter("id"));
        String name = request.getParameter("name");
        String slug = request.getParameter("slug");
        String description = request.getParameter("description");
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        String salePriceStr = request.getParameter("salePrice");
        int stock = Integer.parseInt(request.getParameter("stock"));
        Long categoryId = Long.parseLong(request.getParameter("categoryId"));
        String imageUrl = request.getParameter("imageUrl");
        boolean active = Boolean.parseBoolean(request.getParameter("active"));

        Product product = productDAO.findById(id).orElse(null);
        if (product == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        product.setName(name);
        product.setSlug(slug);
        product.setDescription(description);
        product.setPrice(price);

        if (salePriceStr != null && !salePriceStr.isEmpty()) {
            product.setSalePrice(new BigDecimal(salePriceStr));
        } else {
            product.setSalePrice(null);
        }

        product.setStock(stock);
        product.setImageUrl(imageUrl);
        product.setActive(active);
        product.setUpdatedAt(LocalDateTime.now());

        Category category = categoryDAO.findById(categoryId).orElse(null);
        product.setCategory(category);

        productDAO.update(product);

        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Long id = Long.parseLong(request.getParameter("id"));
        productDAO.deleteById(id);
        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String name = request.getParameter("name");
        String slug = request.getParameter("slug");
        String description = request.getParameter("description");

        Category category = new Category();
        category.setName(name);
        category.setSlug(slug);
        category.setDescription(description);
        category.setActive(true);

        categoryDAO.save(category);

        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Long id = Long.parseLong(request.getParameter("id"));
        String name = request.getParameter("name");
        String slug = request.getParameter("slug");
        String description = request.getParameter("description");
        boolean active = Boolean.parseBoolean(request.getParameter("active"));

        Category category = categoryDAO.findById(id).orElse(null);
        if (category == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        category.setName(name);
        category.setSlug(slug);
        category.setDescription(description);
        category.setActive(active);

        categoryDAO.update(category);

        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Long id = Long.parseLong(request.getParameter("id"));
        categoryDAO.deleteById(id);
        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }

    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Long orderId = Long.parseLong(request.getParameter("orderId"));
        String status = request.getParameter("status");

        orderDAO.updateStatus(orderId, status);
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}