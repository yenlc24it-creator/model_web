<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="fragments/header.jsp" %>

<%
    pageContext.setAttribute("pageTitle", product.name + " - Model Web");
    pageContext.setAttribute("pageDescription", product.description != null ? product.description.substring(0, Math.min(150, product.description.length())) : "Chi tiết sản phẩm");
%>

<div class="container py-4">
    <div class="row">
        <!-- Product Images -->
        <div class="col-md-6">
            <div class="card shadow-sm">
                <img src="${product.imageUrl != null ? product.imageUrl : 'https://via.placeholder.com/600x600'}"
                     class="card-img-top" alt="${product.name}" style="height: 500px; object-fit: cover;">
            </div>
        </div>

        <!-- Product Info -->
        <div class="col-md-6">
            <div class="card shadow-sm">
                <div class="card-body">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${contextPath}/home">Trang chủ</a></li>
                            <li class="breadcrumb-item"><a href="${contextPath}/product">Sản phẩm</a></li>
                            <li class="breadcrumb-item active">${product.category.name}</li>
                        </ol>
                    </nav>

                    <h2 class="card-title">${product.name}</h2>

                    <div class="mb-3">
                        <span class="text-muted">
                            <i class="fas fa-eye"></i> ${product.views} lượt xem
                        </span>
                        <c:if test="${product.onSale}">
                            <span class="badge bg-danger ms-2">
                                <i class="fas fa-tag"></i> Giảm giá
                            </span>
                        </c:if>
                    </div>

                    <div class="mb-3">
                        <c:if test="${product.onSale}">
                            <span class="product-sale-price fs-5">
                                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫"/>
                            </span>
                        </c:if>
                        <span class="product-price fs-3 text-danger">
                            <fmt:formatNumber value="${product.finalPrice}" type="currency" currencySymbol="₫"/>
                        </span>
                    </div>

                    <div class="mb-3">
                        <span class="badge bg-${product.stock > 0 ? 'success' : 'danger'}">
                            ${product.stock > 0 ? 'Còn hàng' : 'Hết hàng'}
                        </span>
                        <span class="text-muted ms-2">Số lượng: ${product.stock}</span>
                    </div>

                    <div class="mb-3">
                        <p class="card-text">${product.description}</p>
                    </div>

                    <c:if test="${product.stock > 0}">
                        <form action="${contextPath}/cart" method="post" class="row g-3 align-items-end">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="${product.id}">

                            <div class="col-auto">
                                <label for="quantity" class="form-label">Số lượng</label>
                                <input type="number" class="form-control" id="quantity" name="quantity"
                                       value="1" min="1" max="${product.stock}" style="width: 100px;">
                            </div>
                            <div class="col-auto">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fas fa-cart-plus"></i> Thêm vào giỏ
                                </button>
                            </div>
                        </form>
                    </c:if>

                    <div class="mt-3">
                        <a href="${contextPath}/home" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left"></i> Tiếp tục mua sắm
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Related Products -->
    <c:if test="${not empty relatedProducts}">
        <div class="mt-5">
            <h4 class="mb-3">Sản phẩm liên quan</h4>
            <div class="row">
                <c:forEach items="${relatedProducts}" var="related">
                    <div class="col-md-3 col-sm-6">
                        <div class="card product-card h-100">
                            <a href="${contextPath}/product/${related.slug}">
                                <img src="${related.imageUrl != null ? related.imageUrl : 'https://via.placeholder.com/300x300'}"
                                     class="card-img-top" alt="${related.name}" style="height: 200px; object-fit: cover;">
                            </a>
                            <div class="card-body">
                                <h6 class="card-title">
                                    <a href="${contextPath}/product/${related.slug}" class="text-decoration-none text-dark">
                                            ${related.name}
                                    </a>
                                </h6>
                                <p class="card-text">
                                    <span class="product-price">
                                        <fmt:formatNumber value="${related.finalPrice}" type="currency" currencySymbol="₫"/>
                                    </span>
                                </p>
                                <form action="${contextPath}/cart" method="post">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="productId" value="${related.id}">
                                    <input type="hidden" name="quantity" value="1">
                                    <button type="submit" class="btn btn-primary btn-sm w-100">
                                        <i class="fas fa-cart-plus"></i> Thêm vào giỏ
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>
</div>

<%@ include file="fragments/footer.jsp" %>