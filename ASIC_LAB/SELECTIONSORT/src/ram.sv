module ram #(
    parameter DATA_WIDTH = 16,
    parameter ADDR_WIDTH = 8 // 4 bit địa chỉ tương ứng với N = 16 phần tử
)(
    input  logic                    clk,
    input  logic                    we,      // Tín hiệu ram_we từ Controller
    input  logic [ADDR_WIDTH-1:0]   addr,    // Tín hiệu sel_addr từ Datapath
    input  logic [DATA_WIDTH-1:0]   wdata,   // Dữ liệu cần ghi (từ reg_mv hoặc reg_t)
    output logic [DATA_WIDTH-1:0]   rdata    // Dữ liệu đọc ra (ram_data)
);

    // Khai báo mảng bộ nhớ (Depth = 2^ADDR_WIDTH)
    localparam DEPTH = 1 << ADDR_WIDTH;
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Nạp dữ liệu khởi tạo từ file do Python sinh ra
    initial begin
        $readmemh("ram_init.mem", mem);
    end

    // Hoạt động đọc/ghi đồng bộ theo sườn lên của clock
    always_ff @(posedge clk) begin
        // Ưu tiên ghi
        if (we) begin
            mem[addr] <= wdata;
        end
        
        // Đọc dữ liệu ra thanh ghi (Dữ liệu sẽ xuất hiện ở chu kỳ clock tiếp theo)
        rdata <= mem[addr];
    end

endmodule