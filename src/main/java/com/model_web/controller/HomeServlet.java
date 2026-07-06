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
            String pageStr = request.getParameter("page");
            String sizeStr = request.getParameter("size");

            int page = pageStr != null ? Integer.parseInt(pageStr) : 0;
            int size = sizeStr != null ? Integer.parseInt(sizeStr) : 12;

            List<Category> categories = categoryDAO.findActiveCategories();
            request.setAttribute("categories", categories);

            List<Product> products;
            long totalProducts;

            if (category != null && !category.isEmpty()) {
                products = productDAO.findByCategory(Long.parseLong(category));
                totalProducts = products.size();
            } else if (keyword != null && !keyword.isEmpty()) {
                products = productDAO.search(keyword);
                totalProducts = products.size();
            } else {
                products = productDAO.findAll(page, size);
                totalProducts = productDAO.count();
            }

            request.setAttribute("products", products);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", size);
            request.setAttribute("totalPages", (int) Math.ceil((double) totalProducts / size));

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