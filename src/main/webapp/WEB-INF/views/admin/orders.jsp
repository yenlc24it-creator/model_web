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
    <title>Quản lý đơn hàng - Model Web</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body>
<div class="container-fluid">
    <div class="row">
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

        <div class="col-md-10 p-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-shopping-cart"></i> Quản lý đơn hàng</h2>
            </div>

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
                                    <td>${order.orderDate.dayOfMonth}/${order.orderDate.monthValue}/${order.orderDate.year} ${order.orderDate.hour}:${order.orderDate.minute}</td>
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
                                            <button class="btn btn-info" onclick="viewOrder(${order.id}, ${order.orderDetails != null ? order.orderDetails.size() : 0})">
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

<!-- Order Detail Modal -->
<div class="modal fade" id="orderDetailModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Chi tiết đơn hàng #${orderDetail.orderCode}</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" onclick="window.location.href='${contextPath}/admin/orders'"></button>
            </div>
            <div class="modal-body">
                <c:if test="${not empty orderDetail}">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <h6>Thông tin khách hàng</h6>
                            <p><strong>Họ tên:</strong> ${orderDetail.customerName}</p>
                            <p><strong>Email:</strong> ${orderDetail.customerEmail}</p>
                            <p><strong>SĐT:</strong> ${orderDetail.customerPhone}</p>
                            <p><strong>Địa chỉ:</strong> ${orderDetail.shippingAddress}</p>
                        </div>
                        <div class="col-md-6">
                            <h6>Thông tin đơn hàng</h6>
                            <p><strong>Ngày đặt:</strong> ${orderDetail.orderDate.dayOfMonth}/${orderDetail.orderDate.monthValue}/${orderDetail.orderDate.year} ${orderDetail.orderDate.hour}:${orderDetail.orderDate.minute}</p>
                            <p><strong>Trạng thái:</strong> ${orderDetail.status}</p>
                            <p><strong>Thanh toán:</strong> ${orderDetail.paymentMethod} - ${orderDetail.paymentStatus}</p>
                            <p><strong>Ghi chú:</strong> ${orderDetail.note}</p>
                        </div>
                    </div>
                    <h6>Sản phẩm</h6>
                    <table class="table table-sm">
                        <thead>
                            <tr>
                                <th>Sản phẩm</th>
                                <th>Số lượng</th>
                                <th>Đơn giá</th>
                                <th>Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${orderDetail.orderDetails}" var="detail">
                                <tr>
                                    <td>${detail.product.name}</td>
                                    <td>${detail.quantity}</td>
                                    <td><fmt:formatNumber value="${detail.price}" type="currency" currencySymbol="₫"/></td>
                                    <td><fmt:formatNumber value="${detail.price * detail.quantity}" type="currency" currencySymbol="₫"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot>
                            <tr>
                                <th colspan="3" class="text-end">Tổng cộng:</th>
                                <th><fmt:formatNumber value="${orderDetail.totalAmount}" type="currency" currencySymbol="₫"/></th>
                            </tr>
                        </tfoot>
                    </table>
                </c:if>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="window.location.href='${contextPath}/admin/orders'">Đóng</button>
            </div>
        </div>
    </div>
</div>

<!-- Update Status Modal -->
<div class="modal fade" id="updateStatusModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${contextPath}/admin/order/update-status" method="post">
                <input type="hidden" name="orderId" id="status-orderId">
                <div class="modal-header">
                    <h5 class="modal-title">Cập nhật trạng thái đơn hàng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Trạng thái</label>
                        <select name="status" class="form-control">
                            <option value="PENDING">Chờ xử lý</option>
                            <option value="PROCESSING">Đang xử lý</option>
                            <option value="SHIPPED">Đang giao</option>
                            <option value="DELIVERED">Đã giao</option>
                            <option value="CANCELLED">Đã hủy</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Cập nhật</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function viewOrder(id) {
        window.location.href = '${contextPath}/admin/orders?detail=' + id;
    }

    function updateStatus(id, status) {
        document.getElementById('status-orderId').value = id;
        var select = document.querySelector('#updateStatusModal select[name="status"]');
        if (select) select.value = status;
        new bootstrap.Modal(document.getElementById('updateStatusModal')).show();
    }
</script>

<c:if test="${not empty orderDetail}">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            new bootstrap.Modal(document.getElementById('orderDetailModal')).show();
        });
    </script>
</c:if>
</body>
</html>
