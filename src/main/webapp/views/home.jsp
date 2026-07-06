<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - Model Web</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .hero-banner {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 80px 0;
            color: white;
            border-radius: 0;
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
        .product-price {
            color: #e74c3c;
            font-weight: bold;
            font-size: 1.2rem;
        }
        .product-sale-price {
            color: #999;
            text-decoration: line-through;
            font-size: 0.9rem;
            margin-left: 10px;
        }
        .sale-tag {
            position: absolute;
            top: 10px;
            right: 10px;
            background: #e74c3c;
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            z-index: 10;
        }
        .footer {
            background: #2c3e50;
            color: white;
            padding: 40px 0 20px;
            margin-top: 50px;
        }
        .footer a {
            color: #ecf0f1;
            text-decoration: none;
        }
        .footer a:hover {
            color: #3498db;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
            <i class="fas fa-store"></i> Model Web
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/home">
                        <i class="fas fa-home"></i> Trang chủ
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/product">
                        <i class="fas fa-box"></i> Sản phẩm
                    </a>
                </li>
            </ul>

            <!-- Search Form -->
            <form class="d-flex me-3" action="${pageContext.request.contextPath}/home" method="get">
                <input class="form-control form-control-sm me-2" type="search" name="keyword"
                       placeholder="Tìm kiếm..." aria-label="Search">
                <button class="btn btn-outline-light btn-sm" type="submit">
                    <i class="fas fa-search"></i>
                </button>
            </form>

            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/cart">
                        <i class="fas fa-shopping-cart"></i> Giỏ hàng
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/login">
                        <i class="fas fa-user"></i> Đăng nhập
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Hero Banner -->
<div class="hero-banner">
    <div class="container text-center">
        <h1 class="display-4 fw-bold">Chào mừng đến với Model Web</h1>
        <p class="lead">Nền tảng thương mại điện tử chuyên nghiệp, dễ dàng tùy chỉnh</p>
        <div class="mt-4">
            <a href="${pageContext.request.contextPath}/product" class="btn btn-light btn-lg">
                <i class="fas fa-shopping-bag"></i> Mua sắm ngay
            </a>
        </div>
    </div>
</div>

<div class="container">
    <!-- Category Filter -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex flex-wrap gap-2">
                <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-primary ${empty param.category ? 'active' : ''}">
                    Tất cả
                </a>
                <c:forEach items="${categories}" var="cat">
                    <a href="${pageContext.request.contextPath}/home?category=${cat.id}"
                       class="btn btn-outline-primary ${param.category == cat.id ? 'active' : ''}">
                            ${cat.name}
                    </a>
                </c:forEach>
            </div>
        </div>
    </div>

    <!-- Products Grid -->
    <div class="row">
        <c:choose>
            <c:when test="${empty products}">
                <div class="col-12 text-center py-5">
                    <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                    <h4>Không tìm thấy sản phẩm</h4>
                    <p class="text-muted">Vui lòng thử lại với từ khóa khác</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach items="${products}" var="product">
                    <div class="col-md-3 col-sm-6">
                        <div class="card product-card h-100">
                            <div class="position-relative">
                                <a href="${pageContext.request.contextPath}/product/${product.slug}">
                                    <img src="${product.imageUrl != null ? product.imageUrl : 'https://via.placeholder.com/300x300'}"
                                         class="card-img-top" alt="${product.name}"
                                         style="height: 200px; object-fit: cover;">
                                </a>
                                <c:if test="${product.salePrice != null && product.salePrice > 0 && product.salePrice < product.price}">
                                        <span class="sale-tag">
                                            <i class="fas fa-tag"></i> Giảm giá
                                        </span>
                                </c:if>
                            </div>
                            <div class="card-body">
                                <h6 class="card-title">
                                    <a href="${pageContext.request.contextPath}/product/${product.slug}" class="text-decoration-none text-dark">
                                            ${product.name}
                                    </a>
                                </h6>
                                <p class="card-text">
                                        <span class="product-price">
                                            <fmt:formatNumber value="${product.salePrice != null && product.salePrice > 0 ? product.salePrice : product.price}" type="currency" currencySymbol="₫"/>
                                        </span>
                                    <c:if test="${product.salePrice != null && product.salePrice > 0 && product.salePrice < product.price}">
                                            <span class="product-sale-price">
                                                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫"/>
                                            </span>
                                    </c:if>
                                </p>
                                <form action="${pageContext.request.contextPath}/cart" method="post">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="productId" value="${product.id}">
                                    <input type="hidden" name="quantity" value="1">
                                    <button type="submit" class="btn btn-primary btn-sm w-100">
                                        <i class="fas fa-cart-plus"></i> Thêm vào giỏ
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Pagination -->
    <c:if test="${totalPages > 1}">
        <nav aria-label="Page navigation" class="mt-4">
            <ul class="pagination justify-content-center">
                <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage - 1}&size=${pageSize}&category=${param.category}&keyword=${param.keyword}">
                        <i class="fas fa-chevron-left"></i>
                    </a>
                </li>
                <c:forEach begin="0" end="${totalPages - 1}" var="i">
                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                        <a class="page-link" href="?page=${i}&size=${pageSize}&category=${param.category}&keyword=${param.keyword}">
                                ${i + 1}
                        </a>
                    </li>
                </c:forEach>
                <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage + 1}&size=${pageSize}&category=${param.category}&keyword=${param.keyword}">
                        <i class="fas fa-chevron-right"></i>
                    </a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>

<!-- Footer -->
<footer class="footer">
    <div class="container">
        <div class="row">
            <div class="col-md-4">
                <h5><i class="fas fa-store"></i> Model Web</h5>
                <p>Nền tảng thương mại điện tử chuyên nghiệp, dễ dàng tùy chỉnh cho mọi nhu cầu kinh doanh.</p>
            </div>
            <div class="col-md-4">
                <h5>Liên kết</h5>
                <ul class="list-unstyled">
                    <li><a href="${pageContext.request.contextPath}/home"><i class="fas fa-chevron-right"></i> Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/product"><i class="fas fa-chevron-right"></i> Sản phẩm</a></li>
                </ul>
            </div>
            <div class="col-md-4">
                <h5>Kết nối</h5>
                <ul class="list-unstyled">
                    <li><a href="#"><i class="fab fa-facebook"></i> Facebook</a></li>
                    <li><a href="#"><i class="fab fa-youtube"></i> YouTube</a></li>
                </ul>
            </div>
        </div>
        <hr style="border-color: rgba(255,255,255,0.1);">
        <div class="text-center">
            <p class="mb-0">&copy; 2026 Model Web. All rights reserved.</p>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>