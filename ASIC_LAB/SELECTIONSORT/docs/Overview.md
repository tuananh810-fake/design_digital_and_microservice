Đọc và mô tả ý hiểu của mình về luồng hoạt động của selection_top:
*Đây là bộ điều khiển để kết nối khối selectionsort với ram để phục vụ cho quá trình sắp xếp mảng dữ liệu. Ở đây thì ta cần quan sát những tín hiệu nào thì ta sẽ khái báo trong entity.Như mọi mạch tuần tự thì ta cần khai báo các tín hiệu quen thuộc là rst,clk, tín hiệu start_i để cho phép nạp dữ liệu từ ram vào khối sắp xếp, done_o để thông báo ra bên ngoài là đã sắp xếp xong và tiến hành kiểm tra kết quả trên mạch hoặc khi simulation xong thì ta cũng có thể quan sát được khi nào mạch sắp xếp xong để tiến hành đọc dữ liệu từ ram xem nó đã sắp xếp xong chưa.Tiếp tục đến với ext_addr : dùng để gạt các chân switch kiểm tra địa chỉ trong ram khi đã sắp xếp xong, rdata_out để hiển thị kết quả của addr trong ram.*
*Tiếp theo đến với architecture(kiến trúc) của selectionsort_top:*
*Ở đây ta có 2 nhiệm vụ chính :* 
*1.Nối dữ liệu từ ram vào selectionsort để hai khối này làm việc với nhau.*
*2.Kiểm tra sắp xếp xong chưa và in ram ra sau khi sắp xếp xong.*

*Đầu tiên ta khai báo các tín hiệu còn thiếu để nối hai khối này với nhau như bản thiết kế.*
*Tại sao ta cần phải khai báo các tín hiệu riêng ra chung của ram và khối sort ví dụ: sort_we,ram_we,sort_addr,ram_add?*
*Vì selectionsort_top ta có hai luồng hoạt động là lấy dữ liệu từ ram vào khối selectionsort và sắp xếp.Luồng thứ 2 là đọc dữ liệu ra ngoài theo chân địa chỉ của ram. Hai luồng này hoạt động độc lập do ram.sv là single port ram(bộ nhớ một cổng) nên tại một thời điểm nó chỉ cho phép một khối sử dụng chức năng.Giả sử nếu chúng ta khai báo chung thì khi khối sắp xếp xong ta cần in kết quả ra mà lúc này cả ram và selectionsort cùng sử dụng ram thì nó sẽ gây ra xung đột.*
*Vậy tại sao ram_rdata có thể sử dụng chung đơn giản vì đây là đầu quan trọng giúp kết nối dữ liệu từ ram đến khối sắp xếp , nếu nó không chung thì không thể truyền dữ liệu từ ram đến khối sắp xếp để sắp xếp được.*
*-- ghi dữ liệu ra được khi nào*
*ta khai báo thêm signal sort_done(vì done_o là out nên chỉ có thể được gán chứ không thể bị đọc nên ta cần tín hiệu trung gian để sử dụng được done_o).*
*sắp xếp hoàn thành khi done_o = 1. Lúc này ram sẽ hoạt động và ta sử dụng ext_addr để điều chỉnh địa chỉ để in ra rdata_out ra bên ngoài mạch.*

*Phân tích và tạo ra datapath:*
*datapath được xây dựng từ mã giả,ta sẽ phân tích cách tạo ra datapath này:*
*Đầu tiên ta cần hiểu luồng hoạt động của bộ sắp xếp là gì:*
*Ban đầu nó nhận dữ liệu từ ram và sắp xếp chung --> bộ truy cập vào ram và sắp xếp dữ liệu.Và muốn truy cập vào ram thì ta cần điều chỉnh địa chỉ với mã giả ta có 3 địa chỉ được sử dụng là i,j,min_idx : đây là 3 biến lưu địa chỉ của ram --> cần sử dụng 3 bộ regn để lưu dữ liệu của 3 thanh này . Vì 3 thanh này không thể cùng lúc sử dụng ram nên ta cần phải có bộ phân kênh 3 thành 1 để điều khiển luồng hoạt động trong một thời điểm thì chỉ được sử dụng địa chỉ từ i , j hoặc min_idx. Các biển này có thể tăng --> sử dụng thêm bộ cộng để tăng giá trị của i,j.* 
*Với địa chỉ i,j ta cần phải tăng giá trị của chúng nên và phân biệt chúng với giá trị khởi tạo là 0 (với i) và i+1 (với j)--> cần thêm hai bộ mux,tương tự min_idx nhận giá trị của i hoặc j để swap và thay đổi giá trị của min_val --> dùng thêm bộ mux.*
*Ta cũng cần kiểm tra khi nào dừng sắp xếp với i (i to N-2 )  và j (j to N-1) --> dùng 2 bộ so sánh và xuất tín hiệu cho controller biết.*
*Làm việc với ram:*
*Trong ram ta làm việc với các value ở trong mã giả ta có 2 phép so sánh và swap.*
*Phép so sánh:*
*So sánh A[j] hiện tại với min_val (Là A[i])  --> gửi trạng kết quả cho controller biết*
*Swap : ta sử dụng một biến trung gian là temp :* 
		*temp = A[i]*
        *A[i] = A[min_idx]*
        *A[min_idx] = temp*
*Nhân tín hiệu từ controller cho phép swap --> swap A[i] và A[min_idx]--> dùng phân kênh dữ liệu này đi lại vào ram để đảo value trong địa chỉ i và min_idx.*

*Xây dựng máy trạng thái FSM:*
*Mô tả một phiên làm việc của bộ sắp xếp :*
*Ta biết bộ sắp xếp hoạt động với i và j và i =0 thì j phải chạyi+1 to n-1 lần để tìm được số nhỏ nhất và swap vì vậy ta chỉ cần làm phiên làm việc của i =0 và cho nó lặp lại cho đến khi i = n-2 là xong.*

*Trạng thái rst--> s0 thì :*
*tất cả vào mặc định và chờ tín hiệu start_i cho phép mạch hoạt động.*
*Trạng thái S1:*
*Khi start_i bằng 1 ta bắt đầu nạp địa chỉ của i =0 vào ram lúc này*
*sel_addr = 00.*
*và j = 0 +1 = 1*
*min_dix = i = 0* 
*Trạng thái S1_READ:*
*Đọc giá trị của i =0* 
*lúc này của ram_data , ram_temp,ram_min_val đều bằng A[i]*
*Với ram_min_val = A[i] do đã cấu hình từ trước*
*ram_data và ram_temp lưu biến tạm thời (Khi j sử dụng thì chúng sẽ lưu giá trị của A[j]) và ram_data sẽ dùng giá trị của A[i(min_dix)] để so sánh với từng A[j].*
*--> lúc này en_t = 1,en_mv =1 cho phép lưu dữ liệu trước của A[i].*
*en_t sau khi lưu xong sẽ về 0 vì nó chỉ lưu giá trị của A[i] sau mỗi lượt làm việc của i thôi .*
*S2 READ(gửi yêu cầu): Bắt đầu đọc giá trị của j* 
*--> sel_addr = 01*
*S2_READ ( Nhận kết quả )*
*giá trị của A[j] được duyện lần lượt:*
*Nếu A[j]> A[i] thì  chuyển sang S3*
*Ngược lại chuyển sang S4.*
*S3 : Khi đã lớn hơn thì ta bắt đầu thay đổi giá trị min_val lần lượt thành j hiện tại và cập nhật giá trị của regn lưu giá trị min_val*
*S4 : Khi không lớn hơn thì ta duyệt các j tiếp theo*

 *Sau khi S3,S4 đã duyệt xong j phần tử --> tiến hành swap A[min_val] cùng với A[temp] = A[i] được lưu ở S1_READ.*
*S5 , S6 thực hiện quá trình swap min_idx với i hiện tại thôi* 
*Đến khi duyệt hết i = n-2 thì mảng đã sắp xếp xong --> done_o = 1(S8),*
*không thì duyệt đến khi hết i (S7).*
S9 quay trở lại S0


