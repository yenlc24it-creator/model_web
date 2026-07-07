package com.model_web.controller;

import com.model_web.dao.UserDAO;
import com.model_web.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Optional;

@WebServlet(name = "AuthServlet", urlPatterns = {"/auth", "/login", "/register", "/logout"})
public class AuthServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/login":
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
                break;
            case "/register":
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                break;
            case "/logout":
                logout(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/login":
                login(request, response);
                break;
            case "/register":
                register(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String redirect = request.getParameter("redirect");

        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }

        Optional<User> userOpt = userDAO.findByUsername(username);

        if (userOpt.isEmpty() || !userOpt.get().getPassword().equals(password)) {
            request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }

        User user = userOpt.get();

        if (!user.isActive()) {
            request.setAttribute("error", "Tài khoản đã bị khóa!");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        session.setAttribute("userId", user.getId());
        session.setAttribute("username", user.getUsername());
        session.setAttribute("fullName", user.getFullName());
        session.setAttribute("role", user.getRole());

        session.setAttribute("loginSuccess", "Đăng nhập thành công, xin chào " + user.getFullName() + "!");

        if (redirect != null && !redirect.isEmpty()) {
            response.sendRedirect(redirect);
        } else if ("ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin");
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    private void register(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        if (username == null || username.isEmpty() || email == null || email.isEmpty() ||
                password == null || password.isEmpty() || confirmPassword == null || confirmPassword.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin bắt buộc!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.existsByUsername(username)) {
            request.setAttribute("error", "Tên đăng nhập đã tồn tại!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.existsByEmail(email)) {
            request.setAttribute("error", "Email đã được sử dụng!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(password);
        user.setFullName(fullName);
        user.setPhone(phone);
        user.setAddress(address);
        user.setRole("USER");
        user.setActive(true);
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());

        userDAO.save(user);

        request.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/home");
    }
}