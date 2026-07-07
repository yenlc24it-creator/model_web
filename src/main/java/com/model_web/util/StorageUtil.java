package com.model_web.util;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public class StorageUtil {

    private static final String SUPABASE_URL = "https://cahykacskytpfqpshcvi.supabase.co";
    private static final String SERVICE_ROLE_KEY = System.getenv("SUPABASE_SERVICE_ROLE_KEY");      private static final String API_KEY = "sb_publishable_sKykGzk7VTPmEdzfyWYYZQ_rt3eKj48";
    private static final String BUCKET = "product-images";

    public static String uploadFile(InputStream fileStream, String fileName, String contentType) throws IOException {
        String objectPath = generateObjectPath(fileName);
        URL url = new URL(SUPABASE_URL + "/storage/v1/object/" + BUCKET + "/" + objectPath);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setDoOutput(true);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("apikey", API_KEY);
        conn.setRequestProperty("Authorization", "Bearer " + SERVICE_ROLE_KEY);
        conn.setRequestProperty("Content-Type", contentType);

        try (OutputStream os = conn.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = fileStream.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }
        }

        int responseCode = conn.getResponseCode();
        if (responseCode < 200 || responseCode > 299) {
            String error = readStream(conn.getErrorStream());
            throw new IOException("Upload failed (HTTP " + responseCode + "): " + error);
        }

        return getPublicUrl(objectPath);
    }

    public static boolean deleteFile(String fileUrl) {
        try {
            String objectPath = extractObjectPath(fileUrl);
            if (objectPath == null) return false;

            URL url = new URL(SUPABASE_URL + "/storage/v1/object/" + BUCKET);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setDoOutput(true);
            conn.setRequestMethod("DELETE");
            conn.setRequestProperty("apikey", API_KEY);
            conn.setRequestProperty("Authorization", "Bearer " + SERVICE_ROLE_KEY);
            conn.setRequestProperty("Content-Type", "application/json");

            String jsonBody = "{\"prefixes\":[\"" + objectPath + "\"]}";
            try (OutputStream os = conn.getOutputStream()) {
                os.write(jsonBody.getBytes(StandardCharsets.UTF_8));
            }

            int responseCode = conn.getResponseCode();
            return responseCode >= 200 && responseCode < 300;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static String getPublicUrl(String objectPath) {
        return SUPABASE_URL + "/storage/v1/object/public/" + BUCKET + "/" + objectPath;
    }

    private static String generateObjectPath(String fileName) {
        String ext = "";
        int dotIdx = fileName.lastIndexOf('.');
        if (dotIdx > 0) {
            ext = fileName.substring(dotIdx);
        }
        String baseName = System.currentTimeMillis() + "_" + (int)(Math.random() * 100000);
        return "products/" + baseName + ext;
    }

    private static String extractObjectPath(String fileUrl) {
        String prefix = SUPABASE_URL + "/storage/v1/object/public/" + BUCKET + "/";
        if (fileUrl.startsWith(prefix)) {
            return fileUrl.substring(prefix.length());
        }
        String altPrefix = SUPABASE_URL + "/storage/v1/object/" + BUCKET + "/";
        if (fileUrl.startsWith(altPrefix)) {
            return fileUrl.substring(altPrefix.length());
        }
        return null;
    }

    private static String readStream(InputStream stream) throws IOException {
        if (stream == null) return "";
        try (BufferedReader br = new BufferedReader(new InputStreamReader(stream, StandardCharsets.UTF_8))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
            return sb.toString();
        }
    }
}
