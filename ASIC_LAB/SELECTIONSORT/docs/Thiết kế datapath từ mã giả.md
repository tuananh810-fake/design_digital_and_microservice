Đầu vào: Mảng A có N phần tử, chỉ số từ 0 đến N-1.

BẮT ĐẦU
    // Vòng lặp ngoài (quét các vị trí cần đặt số nhỏ nhất)
    Cho i chạy từ 0 đến N - 2:
        
        // Giả sử phần tử nhỏ nhất đang nằm ở vị trí i
        min_idx = i
        min_val = A[i]
        
        // Vòng lặp trong (tìm phần tử nhỏ nhất thực sự trong phần còn lại của mảng)
        Cho j chạy từ i + 1 đến N - 1:
            
            Nếu A[j] < min_val:
                min_idx = j
                min_val = A[j]
                
        // Hoán đổi (Swap) phần tử nhỏ nhất tìm được với phần tử ở vị trí i
        temp = A[i]
        A[i] = A[min_idx]
        A[min_idx] = temp

KẾT THÚC