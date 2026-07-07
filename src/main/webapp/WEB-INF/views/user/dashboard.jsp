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
    <title>Tài khoản của tôi - Model Web</title>
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
                    <a class="nav-link active" href="${contextPath}/user/dashboard">
                        <i class="fas fa-dashboard"></i> Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${contextPath}/user/orders">
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
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-dashboard"></i> Dashboard</h2>
                <span class="text-muted">Xin chào, ${sessionScope.fullName}!</span>
            </div>

            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card text-white bg-primary">
                        <div class="card-body">
                            <h5 class="card-title">Tổng đơn hàng</h5>
                            <h2>${totalOrders}</h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card text-white bg-info">
                        <div class="card-body">
                            <h5 class="card-title">Họ tên</h5>
                            <h5>${sessionScope.fullName}</h5>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card text-white bg-success">
                        <div class="card-body">
                            <h5 class="card-title">Email</h5>
                            <h5>${sessionScope.user.email}</h5>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="fas fa-clock"></i> Đơn hàng gần đây</h5>
                    <a href="${contextPath}/user/orders" class="btn btn-outline-primary btn-sm">Xem tất cả</a>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${empty recentOrders}">
                            <p class="text-muted text-center py-3">Bạn chưa có đơn hàng nào.</p>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                    <tr>
                                        <th>Mã đơn</th>
                                        <th>Ngày đặt</th>
                                        <th>Tổng tiền</th>
                                        <th>Trạng thái</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${recentOrders}" var="order">
                                        <tr>
                                            <td>${order.orderCode}</td>
                                            <td>${order.orderDate.dayOfMonth}/${order.orderDate.monthValue}/${order.orderDate.year}</td>
                                            <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/></td>
                                            <td>
                                                <span class="badge bg-${order.status == 'PENDING' ? 'warning' : order.status == 'PROCESSING' ? 'info' : order.status == 'SHIPPED' ? 'primary' : order.status == 'DELIVERED' ? 'success' : 'danger'}">
                                                    ${order.status}
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
