# 1. Chuẩn bị môi trường và thư viện
library(readxl)
library(vars)
library(psych)
library(ggplot2)
library(tseries)
library(urca)
library(zoo)
library(xts)

# 2. Dữ liệu và tiền xử lý
# Nhập dữ liệu từ file excel
data <- read_excel("D:/My Project/DYNAMIC RELATIONSHIP BETWEEN EXCHANGE RATE AND VN-INDEX DURING MONETARY TIGHTENING (2022–2024)/data.xlsx", sheet = 1)
# Kiểm tra cấu trúc dữ liệu
str(data)

# Kiểm tra trùng thời gian
sum(duplicated(data$Date))

# Đảm bảo đúng thứ tự thời gian
data <- data[order(data$Date), ]  

# Kiểm tra giá trị thiếu
colSums(is.na(data))

# Nội suy nếu có NA
data$VNINDEX <- na.approx(data$VNINDEX)
data$USDVND  <- na.approx(data$USDVND)

# Ép kiểu numeric cho các cột giá
for (i in 2:ncol(data)) {data[[i]] <- as.numeric(data[[i]])}

# Tạo biến log returns để chuẩn bị phân tích
data$USDVND_return    <- c(NA, diff(log(data$USDVND)))
data$VNINDEX_return <- c(NA, diff(log(data$VNINDEX)))

# Tạo dataframe mới không chứa NA
data_returns <- na.omit(data[, c("VNINDEX_return", "USDVND_return")])

# 3. Thống kê mô tả và trực quan hóa dữ liệu
# Thống kê mô tả dữ liệu 
describe(data_returns)

# Chuyển đổi dữ liệu sang dạng time-series để vẽ biểu đồ biến động
data_xts <- xts(data_returns[, c("VNINDEX_return", "USDVND_return")], order.by = data$Date[-1])

# Vẽ 2 biểu đồ riêng biệt nhưng chung trục thời gian
par(mfrow = c(2, 1), mar = c(3, 4, 2, 2)) # Chia khung hình thành 2 dòng

# Biểu đồ trên cho VN-Index
plot(data_xts$VNINDEX_return, col = "blue", main = "VN-Index Daily Return")

# Biểu đồ dưới cho USD/VND
plot(data_xts$USDVND_return, col = "red", main = "USD/VND Daily Return")

par(mfrow = c(1, 1)) # Trả lại khung hình bình thường

# Vẽ biểu đồ phân tán dữ liệu
ggplot(data_returns, aes(x = VNINDEX_return, y = USDVND_return)) +
  geom_point(alpha = 0.5) +
  labs(title = "Scatter Plot: VNINDEX vs USD/VND Returns",
       x = "VNINDEX Return",
       y = "USD/VND Return")

# 4. Kiểm định tính dừng và chọn độ trễ
# Kiểm định dừng ADF
adf.test(data_returns$VNINDEX_return)
adf.test(data_returns$USDVND_return)

# Chọn độ trễ AIC
lag_sel <- VARselect(data_returns, lag.max = 10, type = "const")
print(lag_sel$selection)

# 3. Ước lượng mô hình
model_var <- VAR(data_returns, p = 1, type = "const")
summary(model_var)

# 4. Kiểm định sau ước lượng
# Kiểm định tính ổn định của mô hình (Stability)
plot(stability(model_var, type = "OLS-CUSUM"))

# Kiểm định Tự tương quan (Serial Correlation)
serial_test <- serial.test(model_var, lags.pt = 10, type = "PT.asymptotic")
print(serial_test)

# Kiểm định Phương sai thay đổi (ARCH Effect)
arch_test <- arch.test(model_var, lags.multi = 5, multivariate.only = TRUE)
print(arch_test)

# Kiểm định phân phối chuẩn của phần dư (Jarque-Bera)
normality.test(model_var)

# 5. Phân tích tác động
# Kiểm định nhân quả Granger (Granger Causality)
granger_usd_to_vni <- causality(model_var, cause = "USDVND_return")
granger_usd_to_vni

granger_vni_to_usd <- causality(model_var, cause = "VNINDEX_return")
granger_vni_to_usd

# Hàm phản ứng đẩy (IRF) 
irf_vni_to_usd <- irf(model_var, impulse = "VNINDEX_return", 
                      response = "USDVND_return", n.ahead = 10, 
                      boot = TRUE, runs = 500, seed = 123)
irf_usd_to_vni <- irf(model_var, impulse = "USDVND_return", 
                      response = "VNINDEX_return", n.ahead = 10, 
                      boot = TRUE, runs = 500, seed = 123)
# Vẽ tác động của VNINDEX lên USDVND
plot(irf_vni_to_usd, main = "Phản ứng của USDVND trước cú sốc từ VNINDEX",
     ylab = "USDVND Return", xlab = "Số phiên (Days)")
# Vẽ tác động của USDVND lên VNINDEX
plot(irf_usd_to_vni, main = "Phản ứng của VNINDEX trước cú sốc từ USDVND",
     ylab = "VNINDEX Return", xlab = "Số phiên (Days)")

# Phân rã phương sai (FEVD) 
# Xem biến này giải thích được bao nhiêu % sự biến động của biến kia
fevd_res <- fevd(model_var, n.ahead = 10)
plot(fevd_res)

