<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String contextPath = request.getContextPath();
    request.setAttribute("contextPath", contextPath);
    Integer statusCode = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
    if (statusCode == null) {
        statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
    }
    if (statusCode == null) {
        statusCode = 500;
    }
    request.setAttribute("statusCode", statusCode);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lỗi - Model Web</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body>
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6 text-center">
            <div class="card shadow">
                <div class="card-body p-5">
                    <c:choose>
                        <c:when test="${statusCode == 404}">
                            <i class="fas fa-map-signs text-warning" style="font-size: 64px;"></i>
                            <h1 class="display-1 text-muted">404</h1>
                            <h2 class="mt-3">Trang không tìm thấy</h2>
                            <p class="text-muted">Trang bạn đang tìm kiếm không tồn tại hoặc đã bị di chuyển.</p>
                        </c:when>
                        <c:when test="${statusCode == 403}">
                            <i class="fas fa-lock text-danger" style="font-size: 64px;"></i>
                            <h1 class="display-1 text-muted">403</h1>
                            <h2 class="mt-3">Truy cập bị từ chối</h2>
                            <p class="text-muted">Bạn không có quyền truy cập trang này.</p>
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-exclamation-triangle text-danger" style="font-size: 64px;"></i>
                            <h1 class="display-1 text-muted">${statusCode}</h1>
                            <h2 class="mt-3">Đã có lỗi xảy ra!</h2>
                            <p class="text-muted">${error != null ? error : 'Vui lòng thử lại sau.'}</p>
                        </c:otherwise>
                    </c:choose>
                    <a href="${contextPath}/home" class="btn btn-primary mt-3">
                        <i class="fas fa-home"></i> Về trang chủ
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
