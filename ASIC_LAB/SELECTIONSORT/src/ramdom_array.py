import random

# Tham số cấu hình
N = 256             # Số phần tử của mảng (từ 0 đến N-1)
DATA_WIDTH = 8     # Độ rộng 8-bit (giá trị từ 0-255)

# Cách 1: Sinh mảng gồm chính xác các số từ 0 đến N-1 bị xáo trộn vị trí
array = list(range(N))
random.shuffle(array)

# Cách 2 (Tùy chọn): Sinh mảng chứa các giá trị ngẫu nhiên bất kỳ
# array = [random.randint(0, (1 << DATA_WIDTH) - 1) for _ in range(N)]

# Ghi ra file định dạng Hex (.mem) để SystemVerilog hoặc VHDL đọc
filename = "ram_init.mem"
with open(filename, "w") as f:
    for val in array:
        f.write(f"{val:02X}\n")

print(f"Đã tạo file {filename} chứa {N} phần tử:")
print(array)