// Custom JavaScript for Model Web

$(document).ready(function() {
    // Auto dismiss toasts after 5 seconds
    setTimeout(function() {
        $('.toast').toast('hide');
    }, 5000);

    // Quantity input validation
    $('input[type="number"]').on('change', function() {
        var min = parseInt($(this).attr('min')) || 1;
        var max = parseInt($(this).attr('max')) || 999;
        var val = parseInt($(this).val()) || min;

        if (val < min) {
            $(this).val(min);
        } else if (val > max) {
            $(this).val(max);
        }
    });

    // Confirm delete
    $('.btn-delete').on('click', function(e) {
        if (!confirm('Bạn có chắc chắn muốn xóa?')) {
            e.preventDefault();
        }
    });

    // Add to cart with animation
    $('.add-to-cart').on('click', function(e) {
        e.preventDefault();
        var $btn = $(this);
        var $icon = $btn.find('i');

        $icon.removeClass('fa-cart-plus').addClass('fa-spinner fa-spin');

        setTimeout(function() {
            $icon.removeClass('fa-spinner fa-spin').addClass('fa-check');
            $btn.addClass('btn-success').removeClass('btn-primary');

            setTimeout(function() {
                $icon.removeClass('fa-check').addClass('fa-cart-plus');
                $btn.removeClass('btn-success').addClass('btn-primary');
            }, 2000);
        }, 1000);
    });

    // Search form submit
    $('.search-form').on('submit', function(e) {
        var keyword = $(this).find('input[name="keyword"]').val().trim();
        if (!keyword) {
            e.preventDefault();
            return false;
        }
    });

    // Update cart quantity
    $('.update-cart').on('change', function() {
        $(this).closest('form').submit();
    });
});

// Admin functions
function editProduct(id) {
    // Implement edit product modal
    window.location.href = '/admin/products?edit=' + id;
}

function deleteProduct(id) {
    if (confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')) {
        $.ajax({
            url: '/admin/product/delete',
            method: 'POST',
            data: { id: id },
            success: function() {
                location.reload();
            },
            error: function() {
                alert('Có lỗi xảy ra!');
            }
        });
    }
}

function editCategory(id) {
    window.location.href = '/admin/categories?edit=' + id;
}

function deleteCategory(id) {
    if (confirm('Bạn có chắc chắn muốn xóa danh mục này?')) {
        $.ajax({
            url: '/admin/category/delete',
            method: 'POST',
            data: { id: id },
            success: function() {
                location.reload();
            },
            error: function() {
                alert('Có lỗi xảy ra!');
            }
        });
    }
}

function viewOrder(id) {
    window.location.href = '/admin/orders?detail=' + id;
}

function updateStatus(orderId, status) {
    if (confirm('Cập nhật trạng thái đơn hàng?')) {
        $.ajax({
            url: '/admin/order/update-status',
            method: 'POST',
            data: {
                orderId: orderId,
                status: status
            },
            success: function() {
                location.reload();
            },
            error: function() {
                alert('Có lỗi xảy ra!');
            }
        });
    }
}

// Format currency
function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(amount);
}

// Get URL parameters
function getUrlParams() {
    var params = {};
    window.location.search.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(str, key, value) {
        params[key] = value;
    });
    return params;
}

// Toast notification
function showToast(message, type) {
    var icon = type === 'success' ? 'fa-check-circle' :
        type === 'error' ? 'fa-exclamation-circle' : 'fa-info-circle';
    var bgClass = type === 'success' ? 'text-bg-success' :
        type === 'error' ? 'text-bg-danger' : 'text-bg-info';

    var toast = `
        <div class="toast align-items-center ${bgClass} border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas ${icon}"></i> ${message}
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    `;

    $('.toast-container').append(toast);
    var $toast = $('.toast-container .toast:last');
    $toast.toast('show');

    setTimeout(function() {
        $toast.remove();
    }, 5000);
}