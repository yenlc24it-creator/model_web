package com.model_web.controller;

import com.model_web.dao.ProductDAO;
import com.model_web.model.Product;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart", "/cart/*"})
public class CartServlet extends HttpServlet {

    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    @SuppressWarnings("unchecked")
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Map<Long, Integer> cart = (Map<Long, Integer>) session.getAttribute("cart");

        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute("cart", cart);
        }

        BigDecimal total = BigDecimal.ZERO;
        Map<Product, Integer> cartItems = new HashMap<>();

        for (Map.Entry<Long, Integer> entry : cart.entrySet()) {
            Optional<Product> productOpt = productDAO.findById(entry.getKey());
            if (productOpt.isPresent()) {
                Product product = productOpt.get();
                cartItems.put(product, entry.getValue());
                total = total.add(product.getFinalPrice().multiply(BigDecimal.valueOf(entry.getValue())));
            }
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("total", total);
        request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
    }

    @SuppressWarnings("unchecked")
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Map<Long, Integer> cart = (Map<Long, Integer>) session.getAttribute("cart");

        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute("cart", cart);
        }

        switch (action) {
            case "add":
                addToCart(request, cart);
                break;
            case "update":
                updateCart(request, cart);
                break;
            case "remove":
                removeFromCart(request, cart);
                break;
            case "clear":
                cart.clear();
                break;
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void addToCart(HttpServletRequest request, Map<Long, Integer> cart) {
        Long productId = Long.parseLong(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        if (!productDAO.hasStock(productId, quantity)) {
            request.setAttribute("error", "Sản phẩm không đủ số lượng trong kho!");
            return;
        }

        cart.put(productId, cart.getOrDefault(productId, 0) + quantity);
    }

    private void updateCart(HttpServletRequest request, Map<Long, Integer> cart) {
        Long productId = Long.parseLong(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        if (quantity <= 0) {
            cart.remove(productId);
        } else {
            if (!productDAO.hasStock(productId, quantity)) {
                request.setAttribute("error", "Sản phẩm không đủ số lượng trong kho!");
                return;
            }
            cart.put(productId, quantity);
        }
    }

    private void removeFromCart(HttpServletRequest request, Map<Long, Integer> cart) {
        Long productId = Long.parseLong(request.getParameter("productId"));
        cart.remove(productId);
    }
}