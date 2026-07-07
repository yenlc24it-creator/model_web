<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<!-- Banner Slider -->
<div id="bannerSlider" class="carousel slide mb-4" data-bs-ride="carousel">
    <div class="carousel-indicators">
        <button type="button" data-bs-target="#bannerSlider" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#bannerSlider" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#bannerSlider" data-bs-slide-to="2"></button>
    </div>
    <div class="carousel-inner rounded">
        <div class="carousel-item active">
            <img src="https://picsum.photos/1200/400?random=1" class="d-block w-100" alt="Banner 1" style="height:400px; object-fit:cover;">
            <div class="carousel-caption d-none d-md-block" style="background: rgba(0,0,0,0.5); padding:20px; border-radius:10px;">
                <h3>Chào mừng đến với Model Web</h3>
                <p>Nền tảng thương mại điện tử chuyên nghiệp</p>
                <a href="${contextPath}/product" class="btn btn-primary">Mua sắm ngay</a>
            </div>
        </div>
        <div class="carousel-item">
            <img src="https://picsum.photos/1200/400?random=2" class="d-block w-100" alt="Banner 2" style="height:400px; object-fit:cover;">
            <div class="carousel-caption d-none d-md-block" style="background: rgba(0,0,0,0.5); padding:20px; border-radius:10px;">
                <h3>Ưu đãi đặc biệt</h3>
                <p>Giảm giá lên đến 50%</p>
                <a href="${contextPath}/product" class="btn btn-warning">Xem ngay</a>
            </div>
        </div>
        <div class="carousel-item">
            <img src="https://picsum.photos/1200/400?random=3" class="d-block w-100" alt="Banner 3" style="height:400px; object-fit:cover;">
            <div class="carousel-caption d-none d-md-block" style="background: rgba(0,0,0,0.5); padding:20px; border-radius:10px;">
                <h3>Sản phẩm mới</h3>
                <p>Cập nhật liên tục</p>
                <a href="${contextPath}/product" class="btn btn-info">Khám phá</a>
            </div>
        </div>
    </div>
    <button class="carousel-control-prev" type="button" data-bs-target="#bannerSlider" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#bannerSlider" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
    </button>
</div>

<div class="container">
    <!-- Category Filter -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex flex-wrap gap-2">
                <a href="${contextPath}/home" class="btn btn-outline-primary ${empty param.category ? 'active' : ''}">Tất cả</a>
                <c:forEach items="${categories}" var="cat">
                    <a href="${contextPath}/home?category=${cat.id}" class="btn btn-outline-primary ${param.category == cat.id ? 'active' : ''}">${cat.name}</a>
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
                                <a href="${contextPath}/product/${product.slug}">
                                    <img src="${product.imageUrl != null ? product.imageUrl : 'https://via.placeholder.com/300x300'}"
                                         class="card-img-top" alt="${product.name}" style="height: 200px; object-fit: cover;">
                                </a>
                                <c:if test="${product.salePrice != null && product.salePrice > 0 && product.salePrice < product.price}">
                                    <span class="sale-tag"><i class="fas fa-tag"></i> Giảm giá</span>
                                </c:if>
                            </div>
                            <div class="card-body">
                                <h6 class="card-title">
                                    <a href="${contextPath}/product/${product.slug}" class="text-decoration-none text-dark">${product.name}</a>
                                </h6>
                                <p class="card-text">
                                    <span class="product-price"><fmt:formatNumber value="${product.finalPrice}" type="currency" currencySymbol="₫"/></span>
                                    <c:if test="${product.salePrice != null && product.salePrice > 0 && product.salePrice < product.price}">
                                        <span class="product-sale-price"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫"/></span>
                                    </c:if>
                                </p>
                                <form action="${contextPath}/cart" method="post">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="productId" value="${product.id}">
                                    <input type="hidden" name="quantity" value="1">
                                    <button type="submit" class="btn btn-primary btn-sm w-100"><i class="fas fa-cart-plus"></i> Thêm vào giỏ</button>
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

<jsp:include page="/WEB-INF/views/fragments/footer.jsp" />