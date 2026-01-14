-- 数据库与表结构的展示
SHOW DATABASES;
USE My_Hospital;
SHOW TABLES;

DESCRIBE Patient;
DESCRIBE Doctor;
DESCRIBE MedicalRecord;

-- 基础数据展示
SELECT * FROM Department;
SELECT * FROM Doctor;
SELECT * FROM ConsultingRoom;

-- 患者预约
INSERT INTO Reservation
(patient_id, department_id, reservation_date, expected_time)
VALUES
(1, 1, '2026-01-18', '09:30');

SELECT
r.reservation_id,
p.name AS 患者,
d.department_name AS 科室,
r.reservation_date,
r.expected_time,
r.status
FROM Reservation r
JOIN Patient p ON r.patient_id = p.patient_id
JOIN Department d ON r.department_id = d.department_id
ORDER BY r.reservation_id DESC;

-- 到院登记
INSERT INTO MedicalRecord
(patient_id, doctor_id, room_id, visit_date, visit_status, symptom)
VALUES
(1, 1, 1, NOW(), '就诊中', '发热、头痛');
 
 UPDATE Reservation
SET status = '已就诊'
ORDER BY reservation_id DESC
LIMIT 1;

SELECT
m.record_id,
p.name AS 患者,
doc.name AS 医生,
cr.room_number AS 诊室,
m.visit_status
FROM MedicalRecord m
JOIN Patient p ON m.patient_id = p.patient_id
JOIN Doctor doc ON m.doctor_id = doc.doctor_id
JOIN ConsultingRoom cr ON m.room_id = cr.room_id
ORDER BY m.record_id DESC;

-- 缴费结算
INSERT INTO Payment
(record_id, total_amount, insurance_amount, self_amount, payment_method, payment_date, cashier_id)
VALUES
(
  (SELECT record_id FROM MedicalRecord ORDER BY record_id DESC LIMIT 1),
  150.00,
  100.00,
  50.00,
  '医保',
  NOW(),
  1
);

UPDATE MedicalRecord
SET visit_status = '已离院'
ORDER BY record_id DESC
LIMIT 1;

SELECT
p.name AS 患者,
pay.total_amount,
pay.insurance_amount,
pay.self_amount,
pay.payment_method
FROM Payment pay
JOIN MedicalRecord m ON pay.record_id = m.record_id
JOIN Patient p ON m.patient_id = p.patient_id
ORDER BY pay.payment_id DESC;

-- 管理统计功能
SELECT
d.department_name AS 科室,
SUM(p.total_amount) AS 总收入
FROM Payment p
JOIN MedicalRecord m ON p.record_id = m.record_id
JOIN Doctor doc ON m.doctor_id = doc.doctor_id
JOIN Department d ON doc.department_id = d.department_id
GROUP BY d.department_name;

SELECT COUNT(*) AS 已完成就诊人次
FROM MedicalRecord
WHERE visit_status = '已离院';

-- 切换用户hospital_admin
SHOW TABLES;
SELECT
d.department_name,
SUM(p.total_amount) AS total_income
FROM Payment p
JOIN MedicalRecord m ON p.record_id = m.record_id
JOIN Doctor doc ON m.doctor_id = doc.doctor_id
JOIN Department d ON doc.department_id = d.department_id
GROUP BY d.department_name;


-- 切换用户hospital_cashier
SELECT * FROM Payment;
INSERT INTO Payment
(record_id, total_amount, insurance_amount, self_amount, payment_method, payment_date, cashier_id)
VALUES
(1, 200.00, 120.00, 80.00, '医保', NOW(), 1);


SELECT * FROM Patient;


