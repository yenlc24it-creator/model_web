<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="fragments/header.jsp" %>

<%
    pageContext.setAttribute("pageTitle", "Sản phẩm - Model Web");
%>

<div class="container py-4">
    <h2 class="mb-4"><i class="fas fa-box"></i> Tất cả sản phẩm</h2>

    <!-- Category Filter -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex flex-wrap gap-2">
                <a href="${contextPath}/product" class="btn btn-outline-primary ${empty param.category ? 'active' : ''}">
                    Tất cả
                </a>
                <c:forEach items="${categories}" var="cat">
                    <a href="${contextPath}/product?category=${cat.id}"
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
                                <c:if test="${product.onSale}">
                                    <span class="sale-tag">
                                        <i class="fas fa-tag"></i> Giảm giá
                                    </span>
                                </c:if>
                            </div>
                            <div class="card-body">
                                <h6 class="card-title">
                                    <a href="${contextPath}/product/${product.slug}" class="text-decoration-none text-dark">
                                            ${product.name}
                                    </a>
                                </h6>
                                <p class="card-text">
                                    <span class="product-price">
                                        <fmt:formatNumber value="${product.finalPrice}" type="currency" currencySymbol="₫"/>
                                    </span>
                                    <c:if test="${product.onSale}">
                                        <span class="product-sale-price">
                                            <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫"/>
                                        </span>
                                    </c:if>
                                </p>
                                <form action="${contextPath}/cart" method="post">
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
</div>

<%@ include file="fragments/footer.jsp" %>