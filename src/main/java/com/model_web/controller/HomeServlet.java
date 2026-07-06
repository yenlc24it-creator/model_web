package com.model_web.controller;

import com.model_web.dao.CategoryDAO;
import com.model_web.dao.ProductDAO;
import com.model_web.model.Category;
import com.model_web.model.Product;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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

        try {
            String category = request.getParameter("category");
            String keyword = request.getParameter("keyword");

            // Get categories for menu
            List<Category> categories = categoryDAO.findActiveCategories();
            request.setAttribute("categories", categories);

            // Get products
            List<Product> products;

            if (category != null && !category.isEmpty()) {
                products = productDAO.findByCategory(Long.parseLong(category));
            } else if (keyword != null && !keyword.isEmpty()) {
                products = productDAO.search(keyword);
            } else {
                products = productDAO.findActiveProducts();
            }

            request.setAttribute("products", products);

            // Forward to home page
            request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}