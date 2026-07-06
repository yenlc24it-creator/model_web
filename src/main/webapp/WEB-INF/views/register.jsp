<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="fragments/header.jsp" %>

<%
    pageContext.setAttribute("pageTitle", "Đăng ký - Model Web");
    pageContext.setAttribute("pageDescription", "Đăng ký tài khoản Model Web để mua sắm");
%>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow">
                <div class="card-body p-5">
                    <h3 class="text-center mb-4">
                        <i class="fas fa-user-plus text-success"></i> Đăng ký tài khoản
                    </h3>

                    <form action="${contextPath}/register" method="post">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="username" class="form-label">Tên đăng nhập *</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-user"></i></span>
                                        <input type="text" class="form-control" id="username" name="username"
                                               placeholder="Nhập tên đăng nhập" required>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email *</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                        <input type="email" class="form-control" id="email" name="email"
                                               placeholder="Nhập email" required>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="password" class="form-label">Mật khẩu *</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                        <input type="password" class="form-control" id="password" name="password"
                                               placeholder="Ít nhất 6 ký tự" required>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="confirmPassword" class="form-label">Xác nhận mật khẩu *</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-check"></i></span>
                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                                               placeholder="Nhập lại mật khẩu" required>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="fullName" class="form-label">Họ và tên</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-id-card"></i></span>
                                <input type="text" class="form-control" id="fullName" name="fullName"
                                       placeholder="Nhập họ và tên">
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="phone" class="form-label">Số điện thoại</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-phone"></i></span>
                                        <input type="tel" class="form-control" id="phone" name="phone"
                                               placeholder="Nhập số điện thoại">
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="address" class="form-label">Địa chỉ</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-home"></i></span>
                                        <input type="text" class="form-control" id="address" name="address"
                                               placeholder="Nhập địa chỉ">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-success w-100">
                            <i class="fas fa-user-plus"></i> Đăng ký
                        </button>
                    </form>

                    <div class="text-center mt-3">
                        <p class="mb-0">Đã có tài khoản?
                            <a href="${contextPath}/login" class="text-primary">Đăng nhập ngay</a>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="fragments/footer.jsp" %>