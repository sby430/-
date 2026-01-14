-- 科室表
CREATE TABLE Department (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(50) NOT NULL,
    department_desc VARCHAR(200),
    director_id INT
);

-- 医生表
CREATE TABLE Doctor (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    gender ENUM('男', '女'),
    title VARCHAR(50),
    department_id INT,
    contact VARCHAR(50),
    work_status ENUM('在岗', '休假') DEFAULT '在岗',
    schedule_permission BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

-- 补上科室负责人外键
ALTER TABLE Department
ADD CONSTRAINT fk_department_director
FOREIGN KEY (director_id) REFERENCES Doctor(doctor_id);

-- 患者表
CREATE TABLE Patient (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    gender ENUM('男', '女'),
    id_card VARCHAR(18) UNIQUE,
    phone VARCHAR(20),
    insurance_type ENUM('自费', '医保'),
    register_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 诊室表
CREATE TABLE ConsultingRoom (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    department_id INT,
    room_number VARCHAR(20),
    max_capacity INT,
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

-- 预约表
CREATE TABLE Reservation (
    reservation_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    department_id INT,
    reservation_date DATE,
    expected_time TIME,
    status ENUM('未就诊', '已就诊', '已取消') DEFAULT '未就诊',
    created_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

-- 就诊记录表
CREATE TABLE MedicalRecord (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    doctor_id INT,
    room_id INT,
    visit_date DATETIME,
    visit_status ENUM('就诊中', '已完成', '已离院'),
    symptom TEXT,
    diagnosis TEXT,
    prescription_id INT,
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id),
    FOREIGN KEY (room_id) REFERENCES ConsultingRoom(room_id)
);

-- 收费人员表
CREATE TABLE Cashier (
    cashier_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    department_id INT,
    contact VARCHAR(50),
    work_status ENUM('在岗', '休假'),
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

-- 缴费表
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    record_id INT,
    total_amount DECIMAL(10,2),
    insurance_amount DECIMAL(10,2),
    self_amount DECIMAL(10,2),
    payment_method ENUM('现金', '微信', '支付宝', '医保'),
    payment_date DATETIME,
    cashier_id INT,
    FOREIGN KEY (record_id) REFERENCES MedicalRecord(record_id),
    FOREIGN KEY (cashier_id) REFERENCES Cashier(cashier_id)
);

-- 行政人员表
CREATE TABLE Administrator (
    admin_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    department_id INT,
    contact VARCHAR(50),
    work_status ENUM('在岗', '休假'),
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

-- 排班表
CREATE TABLE Schedule (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_id INT,
    room_id INT,
    schedule_date DATE,
    start_time TIME,
    end_time TIME,
    max_reservations INT,
    reserved_count INT DEFAULT 0,
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id),
    FOREIGN KEY (room_id) REFERENCES ConsultingRoom(room_id)
);
