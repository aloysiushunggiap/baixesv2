# Huong dan chay BaiXeSV2 tu dau

Thu muc lam viec chinh:

```text
D:\Work\BaiXeSV2
```

Trang thai hien tai:

- Da co source goc: `D:\Work\BaiXeSV2\baixesv`
- Da co bo JHipster kit: `D:\Work\BaiXeSV2\jhipster-microservice-kit`
- Chua co project JHipster microservice: `uaa`, `gateway`, `parking`
- Node hien tai: `14.8.0`
- JHipster global: `6.10.5`
- May co JDK 11 tai: `C:\Program Files\Java\jdk-11.0.1`
- PATH hien tai dang uu tien Java 25, can ep terminal dung Java 11 truoc khi generate/build

## Buoc 1: Kiem tra database trong DBeaver

Trong DBeaver, MySQL local nen co 3 database:

```text
baixesv_uaa
baixesv_gateway
baixesv_parking
```

Neu chua co, mo SQL Editor va chay:

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

Chi can tao database rong. Cac table se do JHipster Liquibase tu tao khi chay app.

## Buoc 2: Mo PowerShell tai D:\Work\BaiXeSV2

```powershell
cd D:\Work\BaiXeSV2
```

Ep terminal dung Java 11:

```powershell
$env:JAVA_HOME="C:\Program Files\Java\jdk-11.0.1"
$env:Path="$env:JAVA_HOME\bin;$env:Path"
java -version
javac -version
```

Ket qua phai la Java 11.

Kiem tra Node va JHipster:

```powershell
node -v
npm -v
jhipster.cmd --version
```

Neu PowerShell chan `jhipster`, dung `jhipster.cmd` thay vi `jhipster`.

## Buoc 3: Generate 3 project JHipster

Van o `D:\Work\BaiXeSV2`, chay:

```powershell
mkdir baixesv-ms
cd baixesv-ms
copy ..\jhipster-microservice-kit\baixesv-microservices.jdl .
jhipster.cmd import-jdl baixesv-microservices.jdl
```

Neu lenh tren bi dung o cau hoi thong ke cua JHipster, chay lenh nay:

```powershell
jhipster.cmd import-jdl baixesv-microservices.jdl --skip-checks --skip-install --no-insight --force
```

Sau khi chay xong, thu muc `D:\Work\BaiXeSV2\baixesv-ms` phai co:

```text
uaa
gateway
parking
```

Kiem tra entity da sinh du chua:

```powershell
dir D:\Work\BaiXeSV2\baixesv-ms\parking\src\main\java\com\baixesv\parking\domain
dir D:\Work\BaiXeSV2\baixesv-ms\gateway\src\main\webapp\app\entities\parking
```

Neu chua thay `Student`, `ParkingLog`, `ParkingPriceRule`, `MonthlyReport`, `PasswordResetRequest`, chay tiep:

```powershell
cd D:\Work\BaiXeSV2\baixesv-ms\parking
$entities = @('Student','ParkingLog','ParkingPriceRule','MonthlyReport','PasswordResetRequest')
foreach ($entity in $entities) { jhipster.cmd entity $entity --regenerate --skip-install --no-insight --force }

cd D:\Work\BaiXeSV2\baixesv-ms\gateway
$entities = @('Student','ParkingLog','ParkingPriceRule','MonthlyReport','PasswordResetRequest')
foreach ($entity in $entities) { jhipster.cmd entity $entity --regenerate --skip-install --no-insight --force }
```

## Buoc 4: Tro 3 app vao database DBeaver/MySQL local

Sua file:

```text
D:\Work\BaiXeSV2\baixesv-ms\uaa\src\main\resources\config\application-dev.yml
```

Datasource:

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/baixesv_uaa?useUnicode=true&characterEncoding=utf8&useSSL=false&useLegacyDatetimeCode=false&serverTimezone=UTC
    username: root
    password: 1111
```

Sua file:

```text
D:\Work\BaiXeSV2\baixesv-ms\gateway\src\main\resources\config\application-dev.yml
```

Datasource:

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/baixesv_gateway?useUnicode=true&characterEncoding=utf8&useSSL=false&useLegacyDatetimeCode=false&serverTimezone=UTC
    username: root
    password: 1111
```

Sua file:

```text
D:\Work\BaiXeSV2\baixesv-ms\parking\src\main\resources\config\application-dev.yml
```

Datasource:

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/baixesv_parking?useUnicode=true&characterEncoding=utf8&useSSL=false&useLegacyDatetimeCode=false&serverTimezone=UTC
    username: root
    password: 1111
```

Neu DBeaver/MySQL cua ban dung password khac, doi `username` va `password` cho dung.

## Buoc 5: Chay Eureka bang Docker Desktop

Mo Docker Desktop truoc, doi den khi hien `Engine running`.

Kiem tra Docker:

```powershell
docker version
docker compose version
```

Chay Eureka Registry:

```powershell
cd D:\Work\BaiXeSV2
docker compose -f .\jhipster-microservice-kit\docker-compose-registry-only.yml up -d
```

Kiem tra:

```powershell
docker compose -f .\jhipster-microservice-kit\docker-compose-registry-only.yml ps
```

Mo trinh duyet:

```text
http://localhost:8761
```

Neu can xem log:

```powershell
docker compose -f .\jhipster-microservice-kit\docker-compose-registry-only.yml logs -f
```

Dung Eureka:

```powershell
docker compose -f .\jhipster-microservice-kit\docker-compose-registry-only.yml down
```

## Buoc 6: Chay 3 app JHipster

Mo 3 cua so PowerShell rieng. Moi cua so deu ep Java 11 truoc:

```powershell
$env:JAVA_HOME="C:\Program Files\Java\jdk-11.0.1"
$env:Path="$env:JAVA_HOME\bin;$env:Path"
```

Terminal 1:

```powershell
cd D:\Work\BaiXeSV2\baixesv-ms\uaa
.\gradlew --stop
.\gradlew --no-daemon
```

Terminal 2:

```powershell
cd D:\Work\BaiXeSV2\baixesv-ms\parking
.\gradlew --stop
.\gradlew --no-daemon
```

Terminal 3:

```powershell
cd D:\Work\BaiXeSV2\baixesv-ms\gateway
.\gradlew --stop
.\gradlew --no-daemon
```

Mo ung dung:

```text
http://localhost:8080
```

Sau khi chay thanh cong, quay lai DBeaver, Refresh 3 database. Luc nay cac table moi se xuat hien.

Neu Gradle bao loi `grgit-core:3.1.1` hoac `handshake_failure`, kiem tra 3 file `gradle.properties` cua `uaa`, `parking`, `gateway` phai co:

```properties
git_properties_plugin_version=2.4.2
org.gradle.jvmargs=-Xmx1024m -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8 -Dhttps.protocols=TLSv1.2 -Djdk.tls.client.protocols=TLSv1.2
org.gradle.java.home=C:\\Program Files\\Java\\jdk-11.0.1
```

Sau do dung Gradle daemon cu va chay lai:

```powershell
.\gradlew --stop
.\gradlew --refresh-dependencies --no-daemon
```

## Thu tu chay hang ngay

1. Mo MySQL local.
2. Mo Docker Desktop.
3. Chay Eureka:

```powershell
cd D:\Work\BaiXeSV2
docker compose -f .\jhipster-microservice-kit\docker-compose-registry-only.yml up -d
```

4. Chay `uaa`.
5. Chay `parking`.
6. Chay `gateway`.
7. Mo `http://localhost:8080`.
