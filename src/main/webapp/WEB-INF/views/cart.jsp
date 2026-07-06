<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="fragments/header.jsp" %>

<%
    pageContext.setAttribute("pageTitle", "Giỏ hàng - Model Web");
%>

<div class="container py-4">
    <h2 class="mb-4"><i class="fas fa-shopping-cart"></i> Giỏ hàng của bạn</h2>

    <c:choose>
        <c:when test="${empty cartItems}">
            <div class="text-center py-5">
                <i class="fas fa-empty-set fa-4x text-muted mb-3"></i>
                <h4>Giỏ hàng trống</h4>
                <p class="text-muted">Hãy thêm sản phẩm vào giỏ hàng để tiếp tục mua sắm</p>
                <a href="${contextPath}/home" class="btn btn-primary">
                    <i class="fas fa-shopping-bag"></i> Mua sắm ngay
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row">
                <div class="col-lg-8">
                    <div class="card shadow-sm">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                    <tr>
                                        <th>Sản phẩm</th>
                                        <th>Đơn giá</th>
                                        <th>Số lượng</th>
                                        <th>Thành tiền</th>
                                        <th></th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${cartItems}" var="entry">
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <img src="${entry.key.imageUrl != null ? entry.key.imageUrl : 'https://via.placeholder.com/50x50'}"
                                                         alt="${entry.key.name}" style="width: 50px; height: 50px; object-fit: cover;"
                                                         class="me-2">
                                                    <div>
                                                        <div class="fw-bold">${entry.key.name}</div>
                                                        <small class="text-muted">${entry.key.category.name}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <fmt:formatNumber value="${entry.key.finalPrice}" type="currency" currencySymbol="₫"/>
                                            </td>
                                            <td>
                                                <form action="${contextPath}/cart" method="post" class="d-flex align-items-center">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="productId" value="${entry.key.id}">
                                                    <input type="number" name="quantity" value="${entry.value}"
                                                           min="1" max="99" class="form-control form-control-sm"
                                                           style="width: 70px;" onchange="this.form.submit()">
                                                </form>
                                            </td>
                                            <td>
                                                <fmt:formatNumber value="${entry.key.finalPrice * entry.value}" type="currency" currencySymbol="₫"/>
                                            </td>
                                            <td>
                                                <form action="${contextPath}/cart" method="post">
                                                    <input type="hidden" name="action" value="remove">
                                                    <input type="hidden" name="productId" value="${entry.key.id}">
                                                    <button type="submit" class="btn btn-danger btn-sm">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <div class="mt-3">
                                <form action="${contextPath}/cart" method="post">
                                    <input type="hidden" name="action" value="clear">
                                    <button type="submit" class="btn btn-outline-danger btn-sm">
                                        <i class="fas fa-times"></i> Xóa tất cả
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card shadow-sm">
                        <div class="card-body">
                            <h5 class="card-title">Tổng đơn hàng</h5>
                            <hr>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Tạm tính:</span>
                                <span class="fw-bold"><fmt:formatNumber value="${total}" type="currency" currencySymbol="₫"/></span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Phí vận chuyển:</span>
                                <span class="text-success">Miễn phí</span>
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between mb-3">
                                <h5>Tổng cộng:</h5>
                                <h5 class="text-danger"><fmt:formatNumber value="${total}" type="currency" currencySymbol="₫"/></h5>
                            </div>
                            <a href="${contextPath}/checkout" class="btn btn-success w-100">
                                <i class="fas fa-credit-card"></i> Tiến hành thanh toán
                            </a>
                            <a href="${contextPath}/home" class="btn btn-outline-primary w-100 mt-2">
                                <i class="fas fa-arrow-left"></i> Tiếp tục mua sắm
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="fragments/footer.jsp" %>