# Build lại baixesv bằng JHipster 6.10.5 dạng microservice

Repo gốc `aloysiushunggiap/baixesv` là Spring Boot thuần, không phải JHipster. Bộ scaffold này chuyển kiến trúc sang:

- `uaa`: xác thực, user, role, token.
- `gateway`: UI + reverse proxy, chạy port `8080`.
- `parking`: microservice nghiệp vụ bãi xe, chạy port `8081`.
- `jhipster-registry`: Eureka registry, chạy port `8761`.
- MySQL riêng cho từng app: `uaa`, `gateway`, `parking`.

## 1. Chuẩn bị môi trường

Toàn bộ project này dùng Java 11. Mã gốc của bạn đang dùng Spring Boot 3.5/Java 21, nhưng khi chuyển sang JHipster 6.10.5 thì phải hạ về stack Spring Boot 2.x của JHipster 6 và chạy bằng JDK 11.

Kiểm tra JDK hiện tại:

```powershell
java -version
javac -version
```

Kết quả nên là Java 11, ví dụ `11.x.x`. Nếu máy có nhiều JDK, đặt `JAVA_HOME` về JDK 11 trước khi generate/build:

```powershell
$env:JAVA_HOME="C:\Program Files\Java\jdk-11"
$env:Path="$env:JAVA_HOME\bin;$env:Path"
java -version
```

```powershell
nvm use 14.8.0
node -v
npm -v
npm install -g yo generator-jhipster@6.10.5
jhipster --version
```

Nếu Node 14.8 gặp lỗi build frontend cũ, dùng Node 12.22.x sẽ ổn định hơn với JHipster 6.10.5.

## 2. Tạo workspace microservice

```powershell
mkdir baixesv-ms
cd baixesv-ms
copy ..\jhipster-microservice-kit\baixesv-microservices.jdl .
```

Import toàn bộ cấu hình app + domain:

```powershell
jhipster import-jdl baixesv-microservices.jdl
```

## 3. Chạy Eureka và database

```powershell
copy ..\jhipster-microservice-kit\docker-compose.yml .
docker compose up -d
```

Nếu máy bạn dùng Docker Compose v1:

```powershell
docker-compose up -d
```

### Chạy bằng Docker Desktop

1. Mở Docker Desktop và đợi trạng thái `Engine running`.
2. Vào `Settings > Resources`, nên cấp tối thiểu:
   - CPU: 2 cores
   - Memory: 4 GB
   - Swap: 1 GB hoặc hơn
3. Kiểm tra Docker từ PowerShell:

```powershell
docker version
docker compose version
```

4. Từ thư mục `baixesv-ms`, chạy Registry/Eureka và MySQL:

```powershell
docker compose up -d
```

5. Kiểm tra container:

```powershell
docker compose ps
```

Bạn cần thấy các service đang `running`:

- `jhipster-registry`
- `mysql-uaa`
- `mysql-gateway`
- `mysql-parking`

6. Xem log nếu service chưa chạy:

```powershell
docker compose logs -f jhipster-registry
docker compose logs -f mysql-uaa
docker compose logs -f mysql-gateway
docker compose logs -f mysql-parking
```

7. Mở Eureka/JHipster Registry:

```text
http://localhost:8761
```

Sau bước này Docker Desktop chỉ đang chạy hạ tầng. Bạn vẫn chạy 3 app JHipster bằng Gradle ở bước 5 để app tự đăng ký vào Eureka.

Lệnh dừng hạ tầng:

```powershell
docker compose down
```

Nếu muốn xóa cả dữ liệu MySQL container:

```powershell
docker compose down -v
```

## 4. Cấu hình datasource

Trong từng app, kiểm tra `src/main/resources/config/application-dev.yml`.

Nếu bạn muốn lưu dữ liệu vào database mới tự tạo trong DBeaver, nên tạo 3 database riêng:

- `baixesv_uaa`: dữ liệu user/auth của UAA.
- `baixesv_gateway`: dữ liệu gateway.
- `baixesv_parking`: dữ liệu nghiệp vụ bãi xe.

Trong DBeaver:

1. Kết nối vào MySQL server bạn muốn dùng.
2. Mở `SQL Editor`.
3. Chạy file [create-databases.sql](/C:/Users/Admin/Documents/Codex/2026-05-29/t-i-mu-n-x-y/jhipster-microservice-kit/create-databases.sql).

Hoặc chạy trực tiếp:

```sql
CREATE DATABASE IF NOT EXISTS baixesv_uaa
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

CREATE DATABASE IF NOT EXISTS baixesv_gateway
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

CREATE DATABASE IF NOT EXISTS baixesv_parking
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
```

Nếu dùng MySQL local đang chạy ở port `3306`, cấu hình datasource như sau.

`uaa`:

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/baixesv_uaa?useUnicode=true&characterEncoding=utf8&useSSL=false&useLegacyDatetimeCode=false&serverTimezone=UTC
    username: root
    password: 1111
```

`gateway`:

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/baixesv_gateway?useUnicode=true&characterEncoding=utf8&useSSL=false&useLegacyDatetimeCode=false&serverTimezone=UTC
    username: root
    password: 1111
```

`parking`:

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/baixesv_parking?useUnicode=true&characterEncoding=utf8&useSSL=false&useLegacyDatetimeCode=false&serverTimezone=UTC
    username: root
    password: 1111
```

Nếu bạn vẫn dùng MySQL container trong Docker Compose của file này, giữ port theo Docker:

- UAA: `localhost:3307/uaa`
- Gateway: `localhost:3308/gateway`
- Parking: `localhost:3309/parking`

Nếu bạn dùng một MySQL server riêng trong DBeaver, dùng port của server đó, thường là `3306`, và dùng 3 database `baixesv_uaa`, `baixesv_gateway`, `baixesv_parking`.

## 5. Chạy từng service

Mở 3 terminal:

```powershell
cd uaa
.\gradlew
```

```powershell
cd parking
.\gradlew
```

```powershell
cd gateway
.\gradlew
```

Mở:

- Gateway: `http://localhost:8080`
- Eureka/JHipster Registry: `http://localhost:8761`

Nếu muốn ép Gradle luôn build bằng Java 11, thêm vào cuối `gradle.properties` của từng app (`uaa`, `parking`, `gateway`):

```properties
org.gradle.java.home=C:\\Program Files\\Java\\jdk-11
```

Đường dẫn trên cần đổi đúng theo thư mục JDK 11 trên máy bạn.

## 6. Port logic từ repo gốc

JDL chỉ tạo CRUD/entity/service khung. Các API tùy biến từ repo gốc cần port thủ công sang `parking`:

- `ParkingController`: `/api/parking/swipe`, `/simulate-fee`, `/history`, `/delete-card`
- `ParkingFeeService`
- `PricingRuleService`
- `PasswordResetService`
- `CardSignatureService`
- `AutoReportService`

Các API auth/session cũ không nên port nguyên xi:

- `/api/auth/login`, `/api/auth/refresh`, `/api/auth/logout`
- `/api/sessions`
- `AdminAccount`
- `UserSession`

Trong JHipster microservice, phần này do `uaa` quản lý. Hãy tạo user/admin trong UAA và lưu thông tin sinh viên/thẻ ở `parking.Student`.

## 7. Ghi chú khác biệt quan trọng

- `Student.id` của code gốc là mã sinh viên dạng `String`. JHipster mặc định sinh `Long id`, nên scaffold này dùng thêm field `studentCode` để giữ mã sinh viên.
- `LocalTime` trong JHipster 6 không tiện bằng `Instant/ZonedDateTime` trong JDL. `ParkingPriceRule.startTime/endTime` đang để `ZonedDateTime`; nếu bạn muốn đúng kiểu giờ trong ngày, chỉnh entity Java sau khi generate thành `LocalTime`.
- Frontend static HTML/JS cũ có thể đặt dưới `gateway/src/main/webapp/legacy`, hoặc port lại thành Angular component của gateway.
