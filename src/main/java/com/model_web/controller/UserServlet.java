package com.model_web.controller;

import com.model_web.dao.OrderDAO;
import com.model_web.dao.UserDAO;
import com.model_web.model.Order;
import com.model_web.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "UserServlet", urlPatterns = {"/user", "/user/*"})
public class UserServlet extends HttpServlet {

    private UserDAO userDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + request.getRequestURI());
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/dashboard")) {
            showDashboard(request, response);
        } else {
            switch (pathInfo) {
                case "/orders":
                    showOrders(request, response);
                    break;
                case "/profile":
                    showProfile(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            response.sendRedirect(request.getContextPath() + "/user/dashboard");
            return;
        }

        switch (pathInfo) {
            case "/profile/update":
                updateProfile(request, response);
                break;
            case "/password/change":
                changePassword(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        List<Order> recentOrders = orderDAO.findByUser(user.getId());
        if (recentOrders.size() > 5) {
            recentOrders = recentOrders.subList(0, 5);
        }

        long totalOrders = orderDAO.findByUser(user.getId()).size();

        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("totalOrders", totalOrders);
        request.getRequestDispatcher("/WEB-INF/views/user/dashboard.jsp").forward(request, response);
    }

    private void showOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        List<Order> orders = orderDAO.findByUser(user.getId());

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/WEB-INF/views/user/orders.jsp").forward(request, response);
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User sessionUser = (User) session.getAttribute("user");

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        if (fullName == null || fullName.isEmpty()) {
            request.setAttribute("error", "Họ tên không được để trống!");
            request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
            return;
        }

        User user = userDAO.findById(sessionUser.getId()).orElse(null);
        if (user == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        user.setFullName(fullName);
        user.setPhone(phone);
        user.setAddress(address);
        userDAO.update(user);

        session.setAttribute("user", user);
        session.setAttribute("fullName", user.getFullName());

        request.setAttribute("success", "Cập nhật thông tin thành công!");
        request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User sessionUser = (User) session.getAttribute("user");

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (oldPassword == null || oldPassword.isEmpty() ||
                newPassword == null || newPassword.isEmpty() ||
                confirmPassword == null || confirmPassword.isEmpty()) {
            request.setAttribute("pwError", "Vui lòng nhập đầy đủ thông tin!");
            request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("pwError", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("pwError", "Mật khẩu phải có ít nhất 6 ký tự!");
            request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
            return;
        }

        User user = userDAO.findById(sessionUser.getId()).orElse(null);
        if (user == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        if (!user.getPassword().equals(oldPassword)) {
            request.setAttribute("pwError", "Mật khẩu cũ không đúng!");
            request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
            return;
        }

        user.setPassword(newPassword);
        userDAO.update(user);

        request.setAttribute("pwSuccess", "Đổi mật khẩu thành công!");
        request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
    }
}
