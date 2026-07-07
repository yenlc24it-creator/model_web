<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String contextPath = request.getContextPath();
    request.setAttribute("contextPath", contextPath);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý danh mục - Model Web</title>
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
                    <a class="nav-link active" href="${contextPath}/admin/categories">
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
                <h2><i class="fas fa-tags"></i> Quản lý danh mục</h2>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                    <i class="fas fa-plus"></i> Thêm danh mục
                </button>
            </div>

            <div class="card">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên danh mục</th>
                                <th>Slug</th>
                                <th>Số sản phẩm</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${categories}" var="category">
                                <tr>
                                    <td>${category.id}</td>
                                    <td>${category.name}</td>
                                    <td>${category.slug}</td>
                                    <td>${category.products.size()}</td>
                                    <td>
                                        <span class="badge bg-${category.active ? 'success' : 'danger'}">
                                            ${category.active ? 'Hoạt động' : 'Ẩn'}
                                        </span>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-warning" onclick="editCategory(${category.id}, '${category.name}', '${category.slug}', '${category.description != null ? category.description : ''}', ${category.active})">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-sm btn-danger" onclick="deleteCategory(${category.id})">
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

<!-- Add Category Modal -->
<div class="modal fade" id="addCategoryModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${contextPath}/admin/category/add" method="post">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm danh mục</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Tên danh mục</label>
                        <input type="text" name="name" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Slug</label>
                        <input type="text" name="slug" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mô tả</label>
                        <textarea name="description" class="form-control" rows="3"></textarea>
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

<!-- Edit Category Modal -->
<div class="modal fade" id="editCategoryModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${contextPath}/admin/category/update" method="post">
                <input type="hidden" name="id" id="edit-id">
                <div class="modal-header">
                    <h5 class="modal-title">Sửa danh mục</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Tên danh mục</label>
                        <input type="text" name="name" id="edit-name" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Slug</label>
                        <input type="text" name="slug" id="edit-slug" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mô tả</label>
                        <textarea name="description" id="edit-description" class="form-control" rows="3"></textarea>
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

<!-- Delete Category Modal -->
<div class="modal fade" id="deleteCategoryModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${contextPath}/admin/category/delete" method="post">
                <input type="hidden" name="id" id="delete-id">
                <div class="modal-header">
                    <h5 class="modal-title">Xóa danh mục</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn xóa danh mục này?</p>
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
    function editCategory(id, name, slug, description, active) {
        document.getElementById('edit-id').value = id;
        document.getElementById('edit-name').value = name;
        document.getElementById('edit-slug').value = slug;
        document.getElementById('edit-description').value = description;
        document.getElementById('edit-active').checked = active;
        new bootstrap.Modal(document.getElementById('editCategoryModal')).show();
    }

    function deleteCategory(id) {
        document.getElementById('delete-id').value = id;
        new bootstrap.Modal(document.getElementById('deleteCategoryModal')).show();
    }
</script>
</body>
</html>
