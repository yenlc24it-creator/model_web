package com.model_web.controller;

import com.model_web.dao.OrderDAO;
import com.model_web.dao.ProductDAO;
import com.model_web.dao.UserDAO;
import com.model_web.model.Order;
import com.model_web.model.OrderDetail;
import com.model_web.model.Product;
import com.model_web.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Optional;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {

    private OrderDAO orderDAO;
    private ProductDAO productDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        productDAO = new ProductDAO();
        userDAO = new UserDAO();
    }

    @SuppressWarnings("unchecked")
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Map<Long, Integer> cart = (Map<Long, Integer>) session.getAttribute("cart");
        User user = (User) session.getAttribute("user");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        if (user != null) {
            request.setAttribute("fullName", user.getFullName());
            request.setAttribute("email", user.getEmail());
            request.setAttribute("phone", user.getPhone());
            request.setAttribute("address", user.getAddress());
        }

        BigDecimal total = BigDecimal.ZERO;
        Map<Product, Integer> cartItems = new LinkedHashMap<>();
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

        request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);
    }

    @SuppressWarnings("unchecked")
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Map<Long, Integer> cart = (Map<Long, Integer>) session.getAttribute("cart");
        User user = (User) session.getAttribute("user");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        String customerName = request.getParameter("customerName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String note = request.getParameter("note");
        String paymentMethod = request.getParameter("paymentMethod");

        if (customerName == null || customerName.isEmpty() ||
                email == null || email.isEmpty() ||
                address == null || address.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);
            return;
        }

        Order order = new Order();
        order.setOrderCode(generateOrderCode());
        order.setCustomerName(customerName);
        order.setCustomerEmail(email);
        order.setCustomerPhone(phone);
        order.setShippingAddress(address);
        order.setNote(note);
        order.setPaymentMethod(paymentMethod != null ? paymentMethod : "COD");
        order.setStatus("PENDING");
        order.setPaymentStatus("UNPAID");
        order.setOrderDate(LocalDateTime.now());

        if (user != null) {
            order.setUser(user);
        }

        BigDecimal total = BigDecimal.ZERO;
        for (Map.Entry<Long, Integer> entry : cart.entrySet()) {
            Optional<Product> productOpt = productDAO.findById(entry.getKey());
            if (productOpt.isPresent()) {
                Product product = productOpt.get();
                int quantity = entry.getValue();
                BigDecimal price = product.getFinalPrice();

                OrderDetail detail = new OrderDetail(product, quantity, price);
                order.addOrderDetail(detail);

                total = total.add(price.multiply(BigDecimal.valueOf(quantity)));
                productDAO.reduceStock(product.getId(), quantity);
            }
        }

        order.setTotalAmount(total);
        orderDAO.save(order);

        cart.clear();
        session.setAttribute("cart", cart);

        request.setAttribute("orderCode", order.getOrderCode());
        request.setAttribute("order", order);
        request.getRequestDispatcher("/WEB-INF/views/order-confirmation.jsp").forward(request, response);
    }

    private String generateOrderCode() {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        String random = String.format("%04d", (int) (Math.random() * 10000));
        return "ORD-" + timestamp + "-" + random;
    }
}