<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="fragments/header.jsp" %>

<%
    pageContext.setAttribute("pageTitle", "Đăng nhập - Model Web");
    pageContext.setAttribute("pageDescription", "Đăng nhập vào tài khoản Model Web để mua sắm");
%>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow">
                <div class="card-body p-5">
                    <h3 class="text-center mb-4">
                        <i class="fas fa-sign-in-alt text-primary"></i> Đăng nhập
                    </h3>

                    <form action="${contextPath}/login" method="post">
                        <input type="hidden" name="redirect" value="${param.redirect}">

                        <div class="mb-3">
                            <label for="username" class="form-label">Tên đăng nhập</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                                <input type="text" class="form-control" id="username" name="username"
                                       placeholder="Nhập tên đăng nhập" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="password" class="form-label">Mật khẩu</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                <input type="password" class="form-control" id="password" name="password"
                                       placeholder="Nhập mật khẩu" required>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-sign-in-alt"></i> Đăng nhập
                        </button>
                    </form>

                    <div class="text-center mt-3">
                        <p class="mb-0">Chưa có tài khoản?
                            <a href="${contextPath}/register" class="text-primary">Đăng ký ngay</a>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="fragments/footer.jsp" %>