CREATE DATABASE IF NOT EXISTS baixesv_uaa
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

CREATE DATABASE IF NOT EXISTS baixesv_gateway
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

CREATE DATABASE IF NOT EXISTS baixesv_parking
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'baixesv'@'%' IDENTIFIED BY 'baixesv';

GRANT ALL PRIVILEGES ON baixesv_uaa.* TO 'baixesv'@'%';
GRANT ALL PRIVILEGES ON baixesv_gateway.* TO 'baixesv'@'%';
GRANT ALL PRIVILEGES ON baixesv_parking.* TO 'baixesv'@'%';

FLUSH PRIVILEGES;
