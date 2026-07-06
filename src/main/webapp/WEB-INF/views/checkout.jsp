<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="fragments/header.jsp" %>

<%
  pageContext.setAttribute("pageTitle", "Thanh toán - Model Web");
%>

<div class="container py-4">
  <h2 class="mb-4"><i class="fas fa-credit-card"></i> Thanh toán</h2>

  <div class="row">
    <div class="col-lg-8">
      <div class="card shadow-sm">
        <div class="card-body">
          <h5 class="card-title">Thông tin giao hàng</h5>
          <form action="${contextPath}/checkout" method="post">
            <div class="mb-3">
              <label for="customerName" class="form-label">Họ và tên *</label>
              <input type="text" class="form-control" id="customerName" name="customerName"
                     value="${fullName}" required>
            </div>

            <div class="mb-3">
              <label for="email" class="form-label">Email *</label>
              <input type="email" class="form-control" id="email" name="email"
                     value="${email}" required>
            </div>

            <div class="mb-3">
              <label for="phone" class="form-label">Số điện thoại</label>
              <input type="tel" class="form-control" id="phone" name="phone"
                     value="${phone}">
            </div>

            <div class="mb-3">
              <label for="address" class="form-label">Địa chỉ giao hàng *</label>
              <textarea class="form-control" id="address" name="address" rows="3" required>${address}</textarea>
            </div>

            <div class="mb-3">
              <label for="note" class="form-label">Ghi chú</label>
              <textarea class="form-control" id="note" name="note" rows="2"></textarea>
            </div>

            <div class="mb-3">
              <label class="form-label">Phương thức thanh toán</label>
              <div class="form-check">
                <input class="form-check-input" type="radio" name="paymentMethod"
                       id="cod" value="COD" checked>
                <label class="form-check-label" for="cod">
                  <i class="fas fa-money-bill-wave"></i> Thanh toán khi nhận hàng (COD)
                </label>
              </div>
              <div class="form-check">
                <input class="form-check-input" type="radio" name="paymentMethod"
                       id="banking" value="BANKING">
                <label class="form-check-label" for="banking">
                  <i class="fas fa-university"></i> Chuyển khoản ngân hàng
                </label>
              </div>
            </div>

            <button type="submit" class="btn btn-success w-100">
              <i class="fas fa-check"></i> Đặt hàng
            </button>
          </form>
        </div>
      </div>
    </div>

    <div class="col-lg-4">
      <div class="card shadow-sm">
        <div class="card-body">
          <h5 class="card-title">Tổng đơn hàng</h5>
          <hr>
          <c:set var="subtotal" value="0" />
          <c:forEach items="${sessionScope.cart}" var="entry">
            <c:set var="subtotal" value="${subtotal + (entry.value)}" />
          </c:forEach>

          <div class="d-flex justify-content-between mb-2">
            <span>Số lượng sản phẩm:</span>
            <span>${sessionScope.cart.size()}</span>
          </div>

          <div class="d-flex justify-content-between mb-2">
            <span>Phí vận chuyển:</span>
            <span class="text-success">Miễn phí</span>
          </div>

          <hr>
          <div class="d-flex justify-content-between mb-3">
            <h5>Tổng cộng:</h5>
            <h5 class="text-danger">
              <fmt:formatNumber value="${total}" type="currency" currencySymbol="₫"/>
            </h5>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<%@ include file="fragments/footer.jsp" %>