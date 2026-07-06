<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="fragments/header.jsp" %>

<%
    pageContext.setAttribute("pageTitle", "Xác nhận đơn hàng - Model Web");
%>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-lg border-success">
                <div class="card-body text-center p-5">
                    <div class="mb-4">
                        <i class="fas fa-check-circle text-success" style="font-size: 64px;"></i>
                    </div>
                    <h2 class="text-success">Đặt hàng thành công!</h2>
                    <p class="lead">Cảm ơn bạn đã đặt hàng tại Model Web</p>

                    <div class="alert alert-info mt-4">
                        <strong>Mã đơn hàng:</strong> ${orderCode}
                    </div>

                    <div class="row mt-4 text-start">
                        <div class="col-md-6">
                            <h6>Thông tin đơn hàng</h6>
                            <p class="mb-1"><strong>Khách hàng:</strong> ${order.customerName}</p>
                            <p class="mb-1"><strong>Email:</strong> ${order.customerEmail}</p>
                            <p class="mb-1"><strong>Điện thoại:</strong> ${order.customerPhone}</p>
                        </div>
                        <div class="col-md-6">
                            <h6>Địa chỉ giao hàng</h6>
                            <p>${order.shippingAddress}</p>
                            <p class="mb-1"><strong>Phương thức:</strong> ${order.paymentMethod}</p>
                            <p class="mb-1"><strong>Trạng thái:</strong>
                                <span class="badge bg-warning">${order.status}</span>
                            </p>
                        </div>
                    </div>

                    <div class="table-responsive mt-3">
                        <table class="table table-striped">
                            <thead>
                            <tr>
                                <th>Sản phẩm</th>
                                <th>Số lượng</th>
                                <th>Đơn giá</th>
                                <th>Thành tiền</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${order.orderDetails}" var="detail">
                                <tr>
                                    <td>${detail.product.name}</td>
                                    <td>${detail.quantity}</td>
                                    <td><fmt:formatNumber value="${detail.price}" type="currency" currencySymbol="₫"/></td>
                                    <td><fmt:formatNumber value="${detail.subtotal}" type="currency" currencySymbol="₫"/></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                            <tfoot>
                            <tr>
                                <th colspan="3" class="text-end">Tổng cộng:</th>
                                <th><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/></th>
                            </tr>
                            </tfoot>
                        </table>
                    </div>

                    <div class="mt-4">
                        <a href="${contextPath}/home" class="btn btn-primary">
                            <i class="fas fa-home"></i> Về trang chủ
                        </a>
                        <a href="${contextPath}/product" class="btn btn-outline-primary ms-2">
                            <i class="fas fa-shopping-bag"></i> Tiếp tục mua sắm
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="fragments/footer.jsp" %>