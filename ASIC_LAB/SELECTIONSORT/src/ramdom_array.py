import os
import random

# Tham so cau hinh (Chon N = 8 de mo phong truc quan nhat)
N = 8               # So phan tu mang
DATA_WIDTH = 16     # Do rong 16-bit

# Mang so mau ngau nhien ro rang, khong trung lap de de quan sat
array = [15, 3, 9, 1, 7, 12, 4, 6]

# Duong dan luu file ram_init.mem
script_dir = os.path.dirname(os.path.abspath(__file__))
filepath = os.path.join(script_dir, "ram_init.mem")

# Ghi file Hex 4 ky tu (16-bit) cho ram.sv
with open(filepath, "w", encoding="utf-8") as f:
    for val in array:
        f.write(f"{val:04X}\n")

print("Generated successfully: ram_init.mem")
print(f"Total elements: {N}")
print("Initial Array:", array)