package com.model_web.controller;

import com.model_web.dao.ProductDAO;
import com.model_web.model.Product;
import com.model_web.util.StorageUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;

@WebServlet(name = "UploadServlet", urlPatterns = {"/admin/upload"})
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 10 * 1024 * 1024)
public class UploadServlet extends HttpServlet {

    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            Part filePart = request.getPart("file");
            String productIdStr = request.getParameter("productId");

            if (filePart == null || filePart.getSize() == 0) {
                writeJson(response, HttpServletResponse.SC_BAD_REQUEST,
                        "{\"success\":false,\"error\":\"Vui lòng chọn file ảnh\"}");
                return;
            }

            String fileName = getFileName(filePart);
            String contentType = filePart.getContentType();

            if (contentType == null || !contentType.startsWith("image/")) {
                writeJson(response, HttpServletResponse.SC_BAD_REQUEST,
                        "{\"success\":false,\"error\":\"Chỉ hỗ trợ upload file ảnh\"}");
                return;
            }

            if (filePart.getSize() > 5 * 1024 * 1024) {
                writeJson(response, HttpServletResponse.SC_BAD_REQUEST,
                        "{\"success\":false,\"error\":\"File ảnh không được vượt quá 5MB\"}");
                return;
            }

            String uploadedUrl;
            try (InputStream fileStream = filePart.getInputStream()) {
                uploadedUrl = StorageUtil.uploadFile(fileStream, fileName, contentType);
            }

            if (productIdStr != null && !productIdStr.isEmpty()) {
                try {
                    Long productId = Long.parseLong(productIdStr);
                    Product product = productDAO.findById(productId).orElse(null);
                    if (product != null) {
                        String oldUrl = product.getImageUrl();
                        product.setImageUrl(uploadedUrl);
                        productDAO.update(product);
                        if (oldUrl != null && !oldUrl.isEmpty()) {
                            StorageUtil.deleteFile(oldUrl);
                        }
                    }
                } catch (NumberFormatException ignored) {
                }
            }

            writeJson(response, HttpServletResponse.SC_OK,
                    "{\"success\":true,\"url\":\"" + escapeJson(uploadedUrl) + "\"}");

        } catch (Exception e) {
            e.printStackTrace();
            writeJson(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "{\"success\":false,\"error\":\"Lỗi upload: " + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private String getFileName(Part part) {
        String cd = part.getHeader("content-disposition");
        if (cd != null) {
            for (String s : cd.split(";")) {
                s = s.trim();
                if (s.startsWith("filename")) {
                    String name = s.substring(s.indexOf('=') + 1).trim().replace("\"", "");
                    int lastSlash = name.lastIndexOf('\\');
                    if (lastSlash >= 0) name = name.substring(lastSlash + 1);
                    return name;
                }
            }
        }
        return "upload_" + System.currentTimeMillis();
    }

    private void writeJson(HttpServletResponse response, int status, String json) throws IOException {
        response.setStatus(status);
        response.getWriter().write(json);
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
