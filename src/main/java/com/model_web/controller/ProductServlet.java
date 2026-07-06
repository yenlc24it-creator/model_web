package com.model_web.controller;

import com.model_web.dao.ProductDAO;
import com.model_web.dao.CategoryDAO;
import com.model_web.model.Product;
import com.model_web.model.Category;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "ProductServlet", urlPatterns = {"/product", "/product/*"})
public class ProductServlet extends HttpServlet {

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

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            showProductList(request, response);
        } else {
            String slug = pathInfo.substring(1);
            showProductDetail(request, response, slug);
        }
    }

    private void showProductList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String categoryId = request.getParameter("category");
        String keyword = request.getParameter("keyword");

        List<Product> products;

        if (categoryId != null && !categoryId.isEmpty()) {
            products = productDAO.findByCategory(Long.parseLong(categoryId));
        } else if (keyword != null && !keyword.isEmpty()) {
            products = productDAO.search(keyword);
        } else {
            products = productDAO.findActiveProducts();
        }

        List<Category> categories = categoryDAO.findActiveCategories();

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/WEB-INF/views/products.jsp").forward(request, response);
    }

    private void showProductDetail(HttpServletRequest request, HttpServletResponse response, String slug)
            throws ServletException, IOException {

        Optional<Product> productOpt = productDAO.findBySlug(slug);

        if (productOpt.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
            return;
        }

        Product product = productOpt.get();
        productDAO.incrementViewCount(product.getId());

        List<Product> relatedProducts = productDAO.findByCategory(product.getCategory().getId());
        relatedProducts.removeIf(p -> p.getId().equals(product.getId()));
        if (relatedProducts.size() > 4) {
            relatedProducts = relatedProducts.subList(0, 4);
        }

        List<Category> categories = categoryDAO.findActiveCategories();

        request.setAttribute("product", product);
        request.setAttribute("relatedProducts", relatedProducts);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/WEB-INF/views/detail.jsp").forward(request, response);
    }
}