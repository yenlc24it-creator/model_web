<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String contextPath = request.getContextPath();
    request.setAttribute("contextPath", contextPath);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn hàng của tôi - Model Web</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2 admin-sidebar" style="background: #2c3e50; min-height: 100vh;">
            <h5 class="text-white text-center py-3">
                <i class="fas fa-user-circle"></i> ${sessionScope.fullName}
            </h5>
            <hr style="border-color: rgba(255,255,255,0.1);">
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link" href="${contextPath}/user/dashboard">
                        <i class="fas fa-dashboard"></i> Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="${contextPath}/user/orders">
                        <i class="fas fa-shopping-cart"></i> Đơn hàng
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${contextPath}/user/profile">
                        <i class="fas fa-user-cog"></i> Thông tin tài khoản
                    </a>
                </li>
                <li class="nav-item mt-3">
                    <a class="nav-link text-danger" href="${contextPath}/logout">
                        <i class="fas fa-sign-out-alt"></i> Đăng xuất
                    </a>
                </li>
            </ul>
        </div>

        <div class="col-md-10 p-4">
            <h2 class="mb-4"><i class="fas fa-shopping-cart"></i> Đơn hàng của tôi</h2>

            <c:choose>
                <c:when test="${empty orders}">
                    <div class="text-center py-5">
                        <i class="fas fa-box-open fa-4x text-muted mb-3"></i>
                        <h4>Bạn chưa có đơn hàng nào</h4>
                        <a href="${contextPath}/home" class="btn btn-primary mt-3">
                            <i class="fas fa-shopping-bag"></i> Mua sắm ngay
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                    <tr>
                                        <th>Mã đơn</th>
                                        <th>Ngày đặt</th>
                                        <th>Sản phẩm</th>
                                        <th>Tổng tiền</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${orders}" var="order">
                                        <tr>
                                            <td>${order.orderCode}</td>
                                            <td>${order.orderDate.dayOfMonth}/${order.orderDate.monthValue}/${order.orderDate.year}</td>
                                            <td>
                                                <c:forEach items="${order.orderDetails}" var="detail" varStatus="loop">
                                                    ${detail.product.name}<c:if test="${!loop.last}">, </c:if>
                                                </c:forEach>
                                            </td>
                                            <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/></td>
                                            <td>
                                                <span class="badge bg-${order.status == 'PENDING' ? 'warning' : order.status == 'PROCESSING' ? 'info' : order.status == 'SHIPPED' ? 'primary' : order.status == 'DELIVERED' ? 'success' : 'danger'}">
                                                    ${order.status == 'PENDING' ? 'Chờ xử lý' : order.status == 'PROCESSING' ? 'Đang xử lý' : order.status == 'SHIPPED' ? 'Đang giao' : order.status == 'DELIVERED' ? 'Đã giao' : 'Đã hủy'}
                                                </span>
                                            </td>
                                            <td>
                                                <a href="${contextPath}/user/orders?detail=${order.id}" class="btn btn-sm btn-info">
                                                    <i class="fas fa-eye"></i> Chi tiết
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
