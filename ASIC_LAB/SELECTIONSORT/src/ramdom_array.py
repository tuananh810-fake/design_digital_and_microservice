import os
import sys
import random

# Cau hinh ho tro console Windows in chuoi UTF-8
if sys.platform.startswith("win"):
    try:
        sys.stdout.reconfigure(encoding='utf-8')
    except Exception:
        pass

# Tham so cau hinh
N = 64              # So phan tu mang
DATA_WIDTH = 7      # Do rong bit (7-bit: 0 -> 127)
MAX_VAL = 127
MIN_VAL = 1

# Tao mang so ngau nhien chua sap xep va mang da sap xep
array = [random.randint(MIN_VAL, MAX_VAL) for _ in range(N)]
sorted_array = sorted(array)

# Duong dan thu muc
script_dir = os.path.dirname(os.path.abspath(__file__))
sim_dir = os.path.join(script_dir, "..", "sim")

# 1. Duong dan cac file mang CHUA SAP XEP (Hex va Thap phan)
hex_filepath = os.path.join(script_dir, "ram_init_hex.mem")
dec_filepath = os.path.join(script_dir, "ram_init_dec.mem")
dec_txt_filepath = os.path.join(script_dir, "ram_init_dec.txt")

# File mac dinh cho ram.sv doc ($readmemh("ram_init.mem", mem))
ram_init_filepath = os.path.join(script_dir, "ram_init.mem")

# 2. Duong dan cac file mang DA SAP XEP (Nhi phan va Thap phan)
sorted_bin_filepath = os.path.join(script_dir, "ram_sorted_bin.mem")
sorted_bin_txt_filepath = os.path.join(script_dir, "ram_sorted_bin.txt")
sorted_dec_filepath = os.path.join(script_dir, "ram_sorted_dec.mem")
sorted_dec_txt_filepath = os.path.join(script_dir, "ram_sorted_dec.txt")

# Tinh so chu so hex dua vao DATA_WIDTH (7-bit -> 2 ky tu hex, 16-bit -> 4 ky tu hex)
hex_width = max(2, (DATA_WIDTH + 3) // 4)

# --- GHI CAC FILE CHUA SAP XEP ---
# Ghi file ma Hex (.mem)
with open(hex_filepath, "w", encoding="utf-8") as f_hex:
    for val in array:
        f_hex.write(f"{val:0{hex_width}X}\n")

# Ghi dong thoi ram_init.mem de module ram.sv doc truc tiep
with open(ram_init_filepath, "w", encoding="utf-8") as f_ram:
    for val in array:
        f_ram.write(f"{val:0{hex_width}X}\n")

# Dong bo ram_init.mem sang thu muc sim (neu co) cho mo phong
if os.path.exists(sim_dir):
    with open(os.path.join(sim_dir, "ram_init.mem"), "w", encoding="utf-8") as f_sim:
        for val in array:
            f_sim.write(f"{val:0{hex_width}X}\n")

# Ghi file ma Thap phan (.mem va .txt)
with open(dec_filepath, "w", encoding="utf-8") as f_dec:
    for val in array:
        f_dec.write(f"{val}\n")

with open(dec_txt_filepath, "w", encoding="utf-8") as f_dec_txt:
    for val in array:
        f_dec_txt.write(f"{val}\n")

# --- GHI CAC FILE DA SAP XEP ---
# 1. Ghi file ma Nhi phan cua mang da sap xep (Binary, padded du DATA_WIDTH bit)
with open(sorted_bin_filepath, "w", encoding="utf-8") as f_sbin:
    for val in sorted_array:
        f_sbin.write(f"{val:0{DATA_WIDTH}b}\n")

with open(sorted_bin_txt_filepath, "w", encoding="utf-8") as f_sbin_txt:
    for val in sorted_array:
        f_sbin_txt.write(f"{val:0{DATA_WIDTH}b}\n")

# 2. Ghi file ma Thap phan cua mang da sap xep (Decimal)
with open(sorted_dec_filepath, "w", encoding="utf-8") as f_sdec:
    for val in sorted_array:
        f_sdec.write(f"{val}\n")

with open(sorted_dec_txt_filepath, "w", encoding="utf-8") as f_sdec_txt:
    for val in sorted_array:
        f_sdec_txt.write(f"{val}\n")

print("Generated successfully:")
print("  [CHUA SAP XEP]")
print("    - File Hex                  :", os.path.basename(hex_filepath), f"(va {os.path.basename(ram_init_filepath)})")
print("    - File Thap phan            :", os.path.basename(dec_filepath), f"(va {os.path.basename(dec_txt_filepath)})")
print("  [DA SAP XEP]")
print("    - File Nhi phan (Binary)    :", os.path.basename(sorted_bin_filepath), f"(va {os.path.basename(sorted_bin_txt_filepath)})")
print("    - File Thap phan (Decimal)  :", os.path.basename(sorted_dec_filepath), f"(va {os.path.basename(sorted_dec_txt_filepath)})")
print(f"Total elements: {N}")
print("Initial Array (Decimal) :", array)
print("Sorted Array  (Decimal) :", sorted_array)