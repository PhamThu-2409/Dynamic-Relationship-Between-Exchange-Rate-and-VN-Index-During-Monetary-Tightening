# Phân tích mối quan hệ động giữa tỷ giá hối đoái USD/VND và chỉ số VN-Index trong giai đoạn thắt chặt tiền tệ (2022-2024)

## Mô tả 
Dự án phân tích mối quan hệ động giữa tỷ giá USD/VND và chỉ số VN-Index trong giai đoạn 2022–2024 bằng mô hình VAR với dữ liệu tần suất ngày nhằm đánh giá mối quan hệ nhân quả và tác động ngắn hạn giữa thị trường ngoại hối và thị trường chứng khoán tại Việt Nam.
Nghiên cứu kết hợp các phương pháp kinh tế lượng cùng các lý thuyết định giá để trả lời cho câu hỏi liệu biến động của thị trường chứng khoán có khả năng dự báo tỷ giá hay không, cũng như mức độ tác động qua lại giữa hai thị trường trong bối cảnh biến động kinh tế và tài chính toàn cầu.

**Kết quả chính:**
- Tồn tại **quan hệ nhân quả một chiều** từ VN-Index → tỷ giá USD/VND (p-value = 1.75e-07)
- Chiều ngược lại (tỷ giá → VN-Index) **không có ý nghĩa thống kê** (p-value = 0.187)
- Tác động giữa hai thị trường là **yếu và mang tính ngắn hạn** (triệt tiêu sau ~4 phiên)
- Kết quả ủng hộ **Portfolio Balance Theory** (Branson, 1983) tại thị trường Việt Nam

---

## Dữ liệu
 
| Biến | Mô tả | Nguồn | Tần suất |
|------|--------|-------|----------|
| `VNINDEX_return` | Lợi suất logarit của chỉ số VN-Index | CafeF | Ngày |
| `USDVND_return` | Lợi suất logarit của tỷ giá USD/VND | Yahoo Finance | Ngày |
 
- **Giai đoạn:** 01/2022 – 12/2024
- **Số quan sát:** 746 (sau khi loại ngày lễ & cuối tuần)
- **Xử lý:** Nội suy tuyến tính cho giá trị thiếu; chuyển đổi sang log return: $r_t = \ln(P_t / P_{t-1})$

---
 
## Phương pháp
 
```
Kiểm định ADF (tính dừng)
        ↓
Chọn độ trễ tối ưu (VARselect – tiêu chí SC)
        ↓
Ước lượng VAR(1)
        ↓
Kiểm định chẩn đoán
  ├── OLS-CUSUM (ổn định cấu trúc)
  ├── Portmanteau (tự tương quan)
  ├── ARCH (phương sai thay đổi)
  └── Jarque-Bera (phân phối chuẩn)
        ↓
Phân tích chuyên sâu
  ├── Granger Causality Test
  ├── Impulse Response Function (IRF) – Bootstrap 95% CI
  └── Forecast Error Variance Decomposition (FEVD)
```
 
---

## Cài đặt (Installation)
### Yêu cầu
- **R**  hoặc **RStudio**
- Hệ điều hành: Windows / macOS / Linux

### Cài đặt thư viện
```bash
Rscript requirements.R
```

---

## Cách sử dụng (Usage)
Chạy toàn bộ quy trình bằng lệnh:
```bash
Rscript analysis.R
```

---

## Cấu trúc dự án (Project Structure)
```
Dynamic Relationship Between Exchange Rate and VN-Index During Monetary Tightening (2022–2024)/
│
├── requirements.R               # Danh sách packages cần cài đặt
├── analysis.R                   # Code phân tích và mô hình hóa
├── data.xlxs                    # Dữ liệu đã xử lý
├── output/                      # Biểu đồ
├── research_paper.pdf           # Bài nghiên cứu đầy đủ
└── README.md
```

---

## Báo cáo đầy đủ (Report)
Bản báo cáo hoàn chỉnh có thể xem tại đây:

📄 https://github.com/PhamThu-2409/Dynamic-Relationship-Between-Exchange-Rate-and-VN-Index-During-Monetary-Tightening/blob/main/research_paper.pdf

---

## Định hướng phát triển (Roadmap)
- Cải thiện mô hình dự báo (VAR-GARCH, TVP-VAR, Structural VAR (SVAR), Markov Switching VAR)
- Bổ sung thêm các biến kinh tế vĩ mô khác như lạm phát, lãi suất, giá vàng...
- Mở rộng phạm vi thời gian nghiên cứu 

---

## Đóng góp (Contributing)
Dự án hiện được xây dựng cho mục đích học tập và trải nghiệm cá nhân. Mọi góp ý hoặc đề xuất cải thiện đều được hoan nghênh thông qua GitHub Issues.

---

## Tác giả (Author)
**Phạm Thị Anh Thư**  
Chuyên ngành: Công nghệ Tài chính  

---

## Trạng thái dự án (Project Status)
Dự án đã hoàn thành phiên bản cơ bản và có thể tiếp tục được mở rộng trong tương lai.

---

## Lưu ý
Nghiên cứu này được thực hiện nhằm mục đích học thuật, không nhằm mục đích tư vấn đầu tư.

