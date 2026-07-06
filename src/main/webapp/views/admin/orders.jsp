<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    String contextPath = request.getContextPath();
    request.setAttribute("contextPath", contextPath);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đơn hàng - Model Web</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-md-2 admin-sidebar">
            <h5 class="text-white text-center py-3">
                <i class="fas fa-store"></i> Model Web
            </h5>
            <hr style="border-color: rgba(255,255,255,0.1);">
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link" href="${contextPath}/admin">
                        <i class="fas fa-dashboard"></i> Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${contextPath}/admin/products">
                        <i class="fas fa-box"></i> Sản phẩm
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${contextPath}/admin/categories">
                        <i class="fas fa-tags"></i> Danh mục
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="${contextPath}/admin/orders">
                        <i class="fas fa-shopping-cart"></i> Đơn hàng
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${contextPath}/admin/users">
                        <i class="fas fa-users"></i> Người dùng
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${contextPath}/logout">
                        <i class="fas fa-sign-out-alt text-danger"></i> Đăng xuất
                    </a>
                </li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="col-md-10 p-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-shopping-cart"></i> Quản lý đơn hàng</h2>
            </div>

            <!-- Filter by status -->
            <div class="mb-3">
                <div class="btn-group">
                    <a href="${contextPath}/admin/orders" class="btn btn-outline-primary ${empty param.status ? 'active' : ''}">Tất cả</a>
                    <a href="${contextPath}/admin/orders?status=PENDING" class="btn btn-outline-warning ${param.status == 'PENDING' ? 'active' : ''}">Chờ xử lý</a>
                    <a href="${contextPath}/admin/orders?status=PROCESSING" class="btn btn-outline-info ${param.status == 'PROCESSING' ? 'active' : ''}">Đang xử lý</a>
                    <a href="${contextPath}/admin/orders?status=SHIPPED" class="btn btn-outline-primary ${param.status == 'SHIPPED' ? 'active' : ''}">Đang giao</a>
                    <a href="${contextPath}/admin/orders?status=DELIVERED" class="btn btn-outline-success ${param.status == 'DELIVERED' ? 'active' : ''}">Đã giao</a>
                    <a href="${contextPath}/admin/orders?status=CANCELLED" class="btn btn-outline-danger ${param.status == 'CANCELLED' ? 'active' : ''}">Đã hủy</a>
                </div>
            </div>

            <div class="card">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                            <tr>
                                <th>Mã đơn</th>
                                <th>Khách hàng</th>
                                <th>Ngày đặt</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${orders}" var="order">
                                <tr>
                                    <td>${order.orderCode}</td>
                                    <td>${order.customerName}</td>
                                    <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/></td>
                                    <td>
                                                <span class="badge bg-${order.status == 'PENDING' ? 'warning' :
                                                                    order.status == 'PROCESSING' ? 'info' :
                                                                    order.status == 'SHIPPED' ? 'primary' :
                                                                    order.status == 'DELIVERED' ? 'success' : 'danger'}">
                                                        ${order.status}
                                                </span>
                                    </td>
                                    <td>
                                        <div class="btn-group btn-group-sm">
                                            <button class="btn btn-info" onclick="viewOrder(${order.id})">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="btn btn-success" onclick="updateStatus(${order.id}, 'PROCESSING')">
                                                <i class="fas fa-check"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>