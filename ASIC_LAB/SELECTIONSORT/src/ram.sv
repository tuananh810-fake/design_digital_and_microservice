module ram #(
    parameter DATA_WIDTH = 7,
    parameter ADDR_WIDTH = 6
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
    end

    // Hoạt động đọc/ghi đồng bộ theo sườn lên của clock
    always_ff @(posedge clk) begin
        if (we) begin
            mem[addr] <= wdata;
        end
        rdata <= mem[addr];
    end

endmodule