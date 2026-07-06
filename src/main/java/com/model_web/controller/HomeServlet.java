package com.model_web.controller;

import com.model_web.dao.CategoryDAO;
import com.model_web.dao.ProductDAO;
import com.model_web.model.Category;
import com.model_web.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home", "/"})
public class HomeServlet extends HttpServlet {

    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get parameters
        String category = request.getParameter("category");
        String keyword = request.getParameter("keyword");
        String pageStr = request.getParameter("page");
        String sizeStr = request.getParameter("size");

        int page = pageStr != null ? Integer.parseInt(pageStr) : 0;
        int size = sizeStr != null ? Integer.parseInt(sizeStr) : 12;

        // Get categories for menu
        List<Category> categories = categoryDAO.findActiveCategories();
        request.setAttribute("categories", categories);

        // Get products
        List<Product> products;
        long totalProducts;

        if (category != null && !category.isEmpty()) {
            // Filter by category
            Long categoryId = Long.parseLong(category);
            products = productDAO.findByCategory(categoryId);
            totalProducts = products.size();
        } else if (keyword != null && !keyword.isEmpty()) {
            // Search
            products = productDAO.search(keyword);
            totalProducts = products.size();
        } else {
            // Get all products with pagination
            products = productDAO.findAll(page, size);
            totalProducts = productDAO.count();
        }

        // Set attributes
        request.setAttribute("products", products);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", size);
        request.setAttribute("totalPages", (int) Math.ceil((double) totalProducts / size));

        // Forward to home page
        request.getRequestDispatcher("/views/home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}