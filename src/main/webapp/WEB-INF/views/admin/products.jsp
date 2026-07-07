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
    <title>Quản lý sản phẩm - Model Web</title>
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
                    <a class="nav-link active" href="${contextPath}/admin/products">
                        <i class="fas fa-box"></i> Sản phẩm
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${contextPath}/admin/categories">
                        <i class="fas fa-tags"></i> Danh mục
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${contextPath}/admin/orders">
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
                <h2><i class="fas fa-box"></i> Quản lý sản phẩm</h2>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addProductModal">
                    <i class="fas fa-plus"></i> Thêm sản phẩm
                </button>
            </div>

            <div class="card">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Hình ảnh</th>
                                <th>Tên sản phẩm</th>
                                <th>Danh mục</th>
                                <th>Giá</th>
                                <th>Tồn kho</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${products}" var="product">
                                <tr>
                                    <td>${product.id}</td>
                                    <td>
                                        <img src="${product.imageUrl != null ? product.imageUrl : 'https://via.placeholder.com/50x50'}"
                                             style="width: 50px; height: 50px; object-fit: cover;">
                                    </td>
                                    <td>${product.name}</td>
                                    <td>${product.category.name}</td>
                                    <td><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫"/></td>
                                    <td>${product.stock}</td>
                                    <td>
                                        <span class="badge bg-${product.active ? 'success' : 'danger'}">
                                            ${product.active ? 'Hoạt động' : 'Ẩn'}
                                        </span>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-warning" onclick="editProduct(${product.id}, '${product.name}', '${product.slug}', '${product.description}', ${product.price}, ${product.salePrice != null ? product.salePrice : ''}, ${product.stock}, ${product.category.id}, '${product.imageUrl}', ${product.active})">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-sm btn-danger" onclick="deleteProduct(${product.id})">
                                            <i class="fas fa-trash"></i>
                                        </button>
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

<!-- Add Product Modal -->
<div class="modal fade" id="addProductModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${contextPath}/admin/product/add" method="post">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm sản phẩm</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Tên sản phẩm</label>
                            <input type="text" name="name" class="form-control" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Slug</label>
                            <input type="text" name="slug" class="form-control" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mô tả</label>
                        <textarea name="description" class="form-control" rows="3"></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Giá</label>
                            <input type="number" name="price" class="form-control" step="0.01" required>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Giá khuyến mãi</label>
                            <input type="number" name="salePrice" class="form-control" step="0.01">
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Tồn kho</label>
                            <input type="number" name="stock" class="form-control" required>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Danh mục</label>
                            <select name="categoryId" class="form-control" required>
                                <option value="">-- Chọn danh mục --</option>
                                <c:forEach items="${categories}" var="cat">
                                    <option value="${cat.id}">${cat.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Hình ảnh URL</label>
                            <input type="text" name="imageUrl" class="form-control">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Thêm</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Product Modal -->
<div class="modal fade" id="editProductModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${contextPath}/admin/product/update" method="post">
                <input type="hidden" name="id" id="edit-id">
                <div class="modal-header">
                    <h5 class="modal-title">Sửa sản phẩm</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Tên sản phẩm</label>
                            <input type="text" name="name" id="edit-name" class="form-control" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Slug</label>
                            <input type="text" name="slug" id="edit-slug" class="form-control" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mô tả</label>
                        <textarea name="description" id="edit-description" class="form-control" rows="3"></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Giá</label>
                            <input type="number" name="price" id="edit-price" class="form-control" step="0.01" required>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Giá khuyến mãi</label>
                            <input type="number" name="salePrice" id="edit-salePrice" class="form-control" step="0.01">
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Tồn kho</label>
                            <input type="number" name="stock" id="edit-stock" class="form-control" required>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Danh mục</label>
                            <select name="categoryId" id="edit-categoryId" class="form-control" required>
                                <option value="">-- Chọn danh mục --</option>
                                <c:forEach items="${categories}" var="cat">
                                    <option value="${cat.id}">${cat.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Hình ảnh URL</label>
                            <input type="text" name="imageUrl" id="edit-imageUrl" class="form-control">
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="form-check">
                            <input type="checkbox" name="active" id="edit-active" class="form-check-input" value="true">
                            <label class="form-check-label">Hoạt động</label>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Lưu</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Product Modal -->
<div class="modal fade" id="deleteProductModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${contextPath}/admin/product/delete" method="post">
                <input type="hidden" name="id" id="delete-id">
                <div class="modal-header">
                    <h5 class="modal-title">Xóa sản phẩm</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn xóa sản phẩm này?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-danger">Xóa</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function editProduct(id, name, slug, description, price, salePrice, stock, categoryId, imageUrl, active) {
        document.getElementById('edit-id').value = id;
        document.getElementById('edit-name').value = name;
        document.getElementById('edit-slug').value = slug;
        document.getElementById('edit-description').value = description;
        document.getElementById('edit-price').value = price;
        document.getElementById('edit-salePrice').value = salePrice || '';
        document.getElementById('edit-stock').value = stock;
        document.getElementById('edit-categoryId').value = categoryId;
        document.getElementById('edit-imageUrl').value = imageUrl;
        document.getElementById('edit-active').checked = active;
        new bootstrap.Modal(document.getElementById('editProductModal')).show();
    }

    function deleteProduct(id) {
        document.getElementById('delete-id').value = id;
        new bootstrap.Modal(document.getElementById('deleteProductModal')).show();
    }
</script>
</body>
</html>
