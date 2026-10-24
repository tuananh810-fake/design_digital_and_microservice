module ram #(
    parameter DATA_WIDTH = 16,
    parameter ADDR_WIDTH = 8
)(
    input  logic                    clk,
    input  logic                    we,      // Tín hiệu ram_we từ Controller
    input  logic [ADDR_WIDTH-1:0]   addr,    // Tín hiệu sel_addr từ Datapath
    input  logic [DATA_WIDTH-1:0]   wdata,   // Dữ liệu cần ghi (từ reg_mv hoặc reg_t)
    output logic [DATA_WIDTH-1:0]   rdata    // Dữ liệu đọc ra (ram_data)
);

    localparam DEPTH = 1 << ADDR_WIDTH;
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Nạp dữ liệu khởi tạo từ file
    initial begin
        $readmemh("ram_init.mem", mem);
        $display("\n========================================================");
        $display("   MANG BAN DAU TRONG RAM (TRUOC KHI SORT):");
        $display("========================================================");
        for (int k = 0; k < 8; k++) begin
            $display("   RAM[%0d] = %0d", k, mem[k]);
        end
        $display("========================================================\n");
    end

    // Hoạt động đọc/ghi đồng bộ theo sườn lên của clock
    always_ff @(posedge clk) begin
        if (we) begin
            mem[addr] <= wdata;
            // In chi tiết mỗi lần thực hiện Swap ghi vào RAM
            $display("[SWAP @ %0t ns] >> Ghi de vao RAM[%0d] = %0d", $time/1000, addr, wdata);
        end
        rdata <= mem[addr];
    end

    // Khi kết thúc mô phỏng, in toàn bộ mảng đã sắp xếp xong
    final begin
        $display("\n========================================================");
        $display("   KET QUA MANG TRONG RAM SAU KHI SORT XONG:");
        $display("========================================================");
        for (int k = 0; k < 8; k++) begin
            $display("   RAM[%0d] = %0d", k, mem[k]);
        end
        $display("========================================================\n");
        $writememh("ram_sorted.mem", mem);
    end

endmodule