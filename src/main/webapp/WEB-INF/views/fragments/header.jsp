<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    String contextPath = request.getContextPath();
    request.setAttribute("contextPath", contextPath);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Model Web</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .navbar-brand { font-weight: bold; font-size: 1.5rem; }
        .hero-banner {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 80px 0;
            color: white;
            margin-bottom: 30px;
        }
        .product-card {
            transition: transform 0.3s;
            margin-bottom: 20px;
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }
        .product-price { color: #e74c3c; font-weight: bold; font-size: 1.2rem; }
        .product-sale-price { color: #999; text-decoration: line-through; font-size: 0.9rem; margin-left: 10px; }
        .sale-tag {
            position: absolute; top: 10px; right: 10px;
            background: #e74c3c; color: white;
            padding: 5px 12px; border-radius: 20px;
            font-size: 12px; font-weight: bold;
        }
        .footer {
            background: #2c3e50; color: white;
            padding: 40px 0 20px; margin-top: 50px;
        }
        .footer a { color: #ecf0f1; text-decoration: none; }
        .footer a:hover { color: #3498db; }
        .cart-badge {
            position: absolute; top: -5px; right: -5px;
            background: #e74c3c; color: white;
            border-radius: 50%; padding: 2px 6px;
            font-size: 10px;
        }
        .nav-link { position: relative; }
    </style>
</head>
<body>
<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="${contextPath}/home">
            <i class="fas fa-store"></i> Model Web
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.servletPath == '/views/home.jsp' ? 'active' : ''}"
                       href="${contextPath}/home">
                        <i class="fas fa-home"></i> Trang chủ
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${contextPath}/product">
                        <i class="fas fa-box"></i> Sản phẩm
                    </a>
                </li>
                <c:if test="${not empty sessionScope.user && sessionScope.role == 'ADMIN'}">
                    <li class="nav-item">
                        <a class="nav-link" href="${contextPath}/admin">
                            <i class="fas fa-user-shield"></i> Quản trị
                        </a>
                    </li>
                </c:if>
            </ul>

            <form class="d-flex me-3" action="${contextPath}/home" method="get">
                <input class="form-control form-control-sm me-2" type="search" name="keyword" placeholder="Tìm kiếm...">
                <button class="btn btn-outline-light btn-sm" type="submit">
                    <i class="fas fa-search"></i>
                </button>
            </form>

            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link position-relative" href="${contextPath}/cart">
                        <i class="fas fa-shopping-cart"></i> Giỏ hàng
                        <c:if test="${not empty sessionScope.cart}">
                            <span class="cart-badge">${sessionScope.cart.size()}</span>
                        </c:if>
                    </a>
                </li>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
                               data-bs-toggle="dropdown">
                                <i class="fas fa-user"></i> ${sessionScope.fullName}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="${contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a></li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link" href="${contextPath}/login">
                                <i class="fas fa-sign-in-alt"></i> Đăng nhập
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${contextPath}/register">
                                <i class="fas fa-user-plus"></i> Đăng ký
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>