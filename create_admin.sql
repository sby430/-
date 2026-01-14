CREATE USER 'admin_user'@'%' IDENTIFIED BY 'admin123';
CREATE USER 'cashier_user'@'%' IDENTIFIED BY 'cashier123';

GRANT ALL PRIVILEGES ON My_Hospital.* TO 'admin_user'@'%';

GRANT SELECT, INSERT
ON My_Hospital.Payment
TO 'cashier_user'@'%';

FLUSH PRIVILEGES;
