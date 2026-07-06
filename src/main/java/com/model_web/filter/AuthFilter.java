package com.model_web.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

// Xóa dòng @WebFilter - Đã cấu hình trong web.xml
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo filter
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        // Kiểm tra đã đăng nhập chưa
        if (session == null || session.getAttribute("user") == null) {
            String loginURL = req.getContextPath() + "/login";
            res.sendRedirect(loginURL + "?redirect=" + req.getRequestURI());
            return;
        }

        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {
        // Hủy filter
    }
}