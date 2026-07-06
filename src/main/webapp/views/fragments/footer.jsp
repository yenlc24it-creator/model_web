<!-- Footer -->
<footer class="footer">
    <div class="container">
        <div class="row">
            <div class="col-md-4">
                <h5><i class="fas fa-store"></i> Model Web</h5>
                <p>Nền tảng thương mại điện tử chuyên nghiệp, dễ dàng tùy chỉnh cho mọi nhu cầu kinh doanh.</p>
            </div>
            <div class="col-md-4">
                <h5>Liên kết</h5>
                <ul class="list-unstyled">
                    <li><a href="${contextPath}/home"><i class="fas fa-chevron-right"></i> Trang chủ</a></li>
                    <li><a href="${contextPath}/product"><i class="fas fa-chevron-right"></i> Sản phẩm</a></li>
                    <li><a href="#"><i class="fas fa-chevron-right"></i> Giới thiệu</a></li>
                    <li><a href="#"><i class="fas fa-chevron-right"></i> Liên hệ</a></li>
                </ul>
            </div>
            <div class="col-md-4">
                <h5>Kết nối</h5>
                <ul class="list-unstyled">
                    <li><a href="#"><i class="fab fa-facebook"></i> Facebook</a></li>
                    <li><a href="#"><i class="fab fa-youtube"></i> YouTube</a></li>
                    <li><a href="#"><i class="fab fa-tiktok"></i> TikTok</a></li>
                </ul>
            </div>
        </div>
        <hr style="border-color: rgba(255,255,255,0.1);">
        <div class="text-center">
            <p class="mb-0">&copy; 2026 Model Web. All rights reserved.</p>
        </div>
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<!-- Custom JS -->
<script src="${contextPath}/assets/js/script.js"></script>

<script>
    // Auto dismiss toasts after 5 seconds
    $(document).ready(function() {
        setTimeout(function() {
            $('.toast').toast('hide');
        }, 5000);
    });
</script>
</body>
</html>