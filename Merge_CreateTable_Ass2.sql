CREATE DATABASE Assignment2_Restaurent;
USE  Assignment2_Restaurent;
-- END CREATE DATABASE -------------------

-- CREATE TABLE IS HERE -------------------
CREATE TABLE Khu (
	Ma_Khu VARCHAR(3),
	Ten_Khu VARCHAR(45) NOT NULL UNIQUE,
	PRIMARY KEY (Ma_Khu),
	CONSTRAINT check_ma_khu CHECK (Ma_Khu REGEXP '^K[0-9][0-9]$')
);

CREATE TABLE Ban (
	STT INT NOT NULL,
	Ma_Khu VARCHAR(3) NOT NULL,
	So_Ghe INT NOT NULL,
	PRIMARY KEY (STT, Ma_Khu),
	CONSTRAINT fk_ban_khu
		FOREIGN KEY (Ma_Khu)
		REFERENCES Khu (Ma_Khu)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	CHECK (So_Ghe >= 0 AND So_Ghe <= 10)
    -- CONSTRAINT check_ma_khu CHECK (Ma_Khu REGEXP '^K[0-9][0-9]$')
);





CREATE TABLE Phong_Vip (
	Ma_Phong VARCHAR(10) NOT NULL,
    Ma_Khu VARCHAR(3) NOT NULL,
    Min_Khach INT,
    Max_Khach INT,
    PRIMARY KEY (Ma_Phong),
    CONSTRAINT fk_phongvip_khu       -- VIP ROOM ref to "Khu" table
		FOREIGN KEY (Ma_Khu)
        REFERENCES Khu (Ma_Khu)
        ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	CONSTRAINT check_so_khach_toi_thieu
	CHECK (Min_Khach >= 1 AND Min_Khach <= 10),
	CONSTRAINT check_so_khach_toi_da
    CHECK (Max_Khach >= Min_Khach AND Max_Khach < 50),
    CONSTRAINT check_ma_phong CHECK (Ma_Phong REGEXP '^VIP[0-9]+$')
);

CREATE TABLE Khach_Hang(
	CMND_CCCD CHAR(12) PRIMARY KEY,
	Ho_Ten VARCHAR(255),
	Gioi_Tinh CHAR CHECK (Gioi_Tinh IN ('M', 'F')),
	Ngay_Sinh DATE,
	So_Dien_Thoai CHAR(10),
	So_Nha VARCHAR(4),
	Duong VARCHAR(255),
	Quan_Huyen VARCHAR(255),
	Phuong_Xa VARCHAR(255),
	Tinh_Thanh VARCHAR(255),
	Diem INT NOT NULL DEFAULT 0, -- không âm
	CHECK (Diem>=0)
);

-- Nguyen   
CREATE TABLE Nhom
(	
    Ma_nhom INT AUTO_INCREMENT PRIMARY KEY ,      -- check vu so nguyen tang dan 
	Ten_nhom VARCHAR(255) 
);

CREATE TABLE Mon_An
(	Ma_mon	CHAR(5)	PRIMARY KEY,
	Ten		VARCHAR(255) NOT NULL,						
	Hinh    VARCHAR(255),
	Ma_nhom	INT NOT NULL,
	CHECK (Ma_mon REGEXP '^[D|F][0-9]{4}$'),
    CONSTRAINT fk_Monan_Nhom_Manhom FOREIGN KEY (Ma_nhom) REFERENCES Nhom(Ma_nhom) 
    ON DELETE NO ACTION
	ON UPDATE NO ACTION
);

CREATE TABLE Nuoc_Uong
(	
    Ma_nuoc	CHAR(5) PRIMARY KEY ,
    CHECK (Ma_nuoc REGEXP '^D[0-9]{4}$'),
    CONSTRAINT fk_Nuocuong_Monan_Mamon FOREIGN KEY (Ma_nuoc) REFERENCES Mon_An(Ma_mon)
	ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

CREATE TABLE Do_An
(	
	Ma_do_an   CHAR(5) PRIMARY KEY,
    Don_gia DECIMAL(10,2),
    CHECK (Ma_do_an REGEXP '^F[0-9]{4}$'),
	CONSTRAINT fk_Doan_Monan_Mamon FOREIGN KEY (Ma_do_an) REFERENCES Mon_An(Ma_mon) 
    ON DELETE NO ACTION	
    ON UPDATE NO ACTION
);

CREATE TABLE Kich_Thuoc_Nuoc_Uong
(	
	Ma_nuoc_uong	CHAR(5), 
	Size	CHAR NOT NULL,
    Don_gia  DECIMAL(10,2),
    CHECK (Ma_nuoc_uong REGEXP '^D[0-9]{4}$'),
    CHECK (Size IN ('S', 'M', 'L')),
    PRIMARY KEY (Ma_nuoc_uong, Size),
    CONSTRAINT fk_Kichthuocnuocuong_Nuocuong_Manuoc FOREIGN KEY (Ma_nuoc_uong) REFERENCES Nuoc_Uong(Ma_nuoc) ON DELETE NO ACTION
);
CREATE TABLE Gio_Phuc_Vu_Do_An
(	
    Ma_do_an_phuc_vu   CHAR(5),
	Bat_dau  TIME NOT NULL,
	Ket_thuc TIME NOT NULL,
    CHECK (Ma_do_an_phuc_vu REGEXP '^F[0-9]{4}$'),
    CONSTRAINT chk_bat_dau_ket_thuc CHECK (
        Bat_dau < Ket_thuc  ),
	PRIMARY KEY (Ma_do_an_phuc_vu, Bat_dau),
    CONSTRAINT fk_Giophucvu_Doan_Mamon FOREIGN KEY (Ma_do_an_phuc_vu) REFERENCES Do_An(Ma_do_an) 
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

CREATE TABLE Hoa_Don(
	Ma_Hoa_Don VARCHAR(16) PRIMARY KEY,
	CHECK (Ma_Hoa_Don REGEXP '^HD[0-9]{8}[0-9]{6}$'),
	Ngay DATE,
	SL_Khach INT,
	Gio_Vao TIME,
	Gio_Ra TIME,
	SL_Mon INT,
	Tong_Tien DECIMAL NOT NULL DEFAULT 0,
	Ma_Khach_Hang CHAR(12),
	Da_Thanh_Toan BIT DEFAULT 0,
	CHECK(Gio_Ra > Gio_Vao),
	CONSTRAINT fk_hd_kh_mkh FOREIGN KEY (Ma_Khach_Hang) REFERENCES Khach_Hang(CMND_CCCD)
	ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
CREATE TABLE Hoa_Don_Gom_Nuoc_Uong(
	Ma_Hoa_Don VARCHAR(16),
	Ma_Nuoc_Uong CHAR(5) NOT NULL,
	Size CHAR CHECK (Size IN ('S','M','L')),
	So_Luong INT NOT NULL DEFAULT 1,
	CHECK (So_Luong >0),
	CONSTRAINT pk_hdgnu PRIMARY KEY (Ma_Hoa_Don,Ma_Nuoc_Uong,Size),
	CONSTRAINT fk_hdgnu_hd_mhd FOREIGN KEY (Ma_Hoa_Don) REFERENCES Hoa_Don(Ma_Hoa_Don),
	CONSTRAINT fk_hdgnu_ktnu_ma FOREIGN KEY (Ma_Nuoc_Uong,Size) REFERENCES Kich_Thuoc_Nuoc_Uong(Ma_Nuoc_Uong,Size)
	ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

CREATE TABLE Hoa_Don_Gom_Do_An(
	Ma_Hoa_Don VARCHAR(16),
	Ma_Do_An CHAR(5),
	So_Luong INT NOT NULL DEFAULT 1,
	CHECK (So_Luong > 0),
	CONSTRAINT pk_hdgda PRIMARY KEY (Ma_Hoa_Don,Ma_Do_An),
	CONSTRAINT fk_hdgda_hd_mhd FOREIGN KEY (Ma_Hoa_Don) REFERENCES Hoa_Don(Ma_Hoa_Don),
	CONSTRAINT fk_hdgda_da_mda FOREIGN KEY (Ma_Do_An) REFERENCES Do_An(Ma_do_an)
	ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

CREATE TABLE Ban_hoa_don (
	Ma_Hoa_Don VARCHAR(16),
    Ma_Khu VARCHAR(3),
    STT INT ,
    PRIMARY KEY (Ma_Hoa_Don, Ma_Khu, STT),
    CONSTRAINT fk_hoadon1
		FOREIGN KEY (Ma_Hoa_Don)
        REFERENCES Hoa_Don (Ma_Hoa_Don)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
    CONSTRAINT fk_ban
		FOREIGN KEY (STT, Ma_Khu)
        REFERENCES Ban (STT, Ma_Khu)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	CONSTRAINT check_ma_khu_ban_hoa_don CHECK (Ma_Khu REGEXP 'K[0-9][0-9]$')
 );
CREATE TABLE Phong_vip_hoa_don (
	Ma_Hoa_Don VARCHAR(16),
	Ma_Phong VARCHAR(10),
	PRIMARY KEY (Ma_Hoa_Don, Ma_Phong),
    CONSTRAINT fk_hoadon2
		FOREIGN KEY (Ma_Hoa_Don)
        REFERENCES Hoa_Don (Ma_Hoa_Don)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	CONSTRAINT fk_phongvip
		FOREIGN KEY (Ma_Phong)
        REFERENCES Phong_Vip (Ma_Phong)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	CONSTRAINT check_ma_phong_pvip_hoadon CHECK (Ma_Phong REGEXP 'VIP[0-9]+$')
 );
 
 CREATE TABLE Nguyen_Lieu (
  Ma_NguyenLieu CHAR(6) PRIMARY KEY,
  Ten CHAR(10),
  Don_Vi VARCHAR(10),
  Mo_Ta VARCHAR(255),
  -- contraint to check Ma_nguyen_Lieu has true format: "NL[0-9][0-9][0-9][0-9]"
  -- Example: NL0912 => true format.
  -- Example: NL1a67 => wrong format.
  CONSTRAINT chk_Ma_NguyenLieu CHECK (Ma_NguyenLieu REGEXP '^NL[0-9]{4}$')

);

CREATE TABLE Nha_Cung_Cap(
  Ma_NCC     CHAR(6) PRIMARY KEY,
  Ten_NCC    CHAR(5),
  MST        CHAR(12) NOT NULL UNIQUE,
  So_Nha     CHAR(3),
  Ten_Duong  VARCHAR(50),
  Ten_Quan_Huyen VARCHAR(50),
  Ten_Phuong_Xa  VARCHAR(50),
  Ten_Tinh       VARCHAR(50)
);

CREATE TABLE Email_NCC(
  Ma_NCC_tmp CHAR(6) ,
  Email_NCC VARCHAR(255) CHECK (Email_NCC REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+(\.vn|\.com)$'),
  PRIMARY KEY	(Ma_NCC_tmp, Email_NCC),
  CONSTRAINT	fk_email_ncc	FOREIGN KEY (Ma_NCC_tmp)
  REFERENCES Nha_Cung_Cap(Ma_NCC)
  -- ON DELTE NO ACTION has mean: 
  -- The root-table has been successfully removed , when the sub-table must been removed.
  ON DELETE NO ACTION
  ON UPDATE NO ACTION
);

CREATE TABLE Dien_Thoai_NCC(
  Ma_NCC_tmp CHAR(6) ,
  SDT_NCC CHAR(10) ,
  PRIMARY KEY	(Ma_NCC_tmp, SDT_NCC),
  CONSTRAINT	fk_phone_ncc	FOREIGN KEY (Ma_NCC_tmp)
  REFERENCES Nha_Cung_Cap(Ma_NCC)
   ON DELETE NO ACTION
   ON UPDATE NO ACTION
);

CREATE TABLE Mua_Nguyen_Lieu(
  Ma_NL_tmp CHAR(6),
  Ma_NCC_tmp CHAR(6),
  Don_Gia   DECIMAL(10,2),
  PRIMARY KEY(Ma_NL_tmp,Ma_NCC_tmp),
  CONSTRAINT	fk_Ma_NL_tmp	FOREIGN KEY (Ma_NL_tmp)
  REFERENCES Nguyen_Lieu(Ma_NguyenLieu)
  ON DELETE NO ACTION,
  CONSTRAINT	fk_Ma_NCC_tmp	FOREIGN KEY (Ma_NCC_tmp)
  REFERENCES Nha_Cung_Cap(Ma_NCC)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION
);

CREATE TABLE Lan_Mua(
  Ma_NL_tmp CHAR(6) NOT NULL,
  Ma_NCC_tmp CHAR(6) NOT NULL,
  Thoi_gian DATETIME,
  So_Luong INT NOT NULL DEFAULT 1,
  PRIMARY KEY(Ma_NL_tmp,Ma_NCC_tmp,Thoi_gian),
  CONSTRAINT	fk_Ma_NL_Lan_Mua_tmp	FOREIGN KEY (Ma_NL_tmp)
  REFERENCES Nguyen_Lieu(Ma_NguyenLieu)
  ON DELETE NO ACTION,
  CONSTRAINT	fk_Ma_NCC_Lan_Mua_tmp	FOREIGN KEY (Ma_NCC_tmp)
  REFERENCES Nha_Cung_Cap(Ma_NCC)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION
);

CREATE TABLE Cung_Cap(
 Ma_Nguyen_Lieu_tmpCC CHAR(6),
 Ma_Mon_tmpCC CHAR(5),
 Ma_NCC_tmpCC CHAR(6),
 PRIMARY KEY(Ma_Nguyen_Lieu_tmpCC, Ma_Mon_tmpCC),
 CONSTRAINT	fk_Ma_NL_tmpCC	FOREIGN KEY (Ma_Nguyen_Lieu_tmpCC)
 REFERENCES Nguyen_Lieu(Ma_NguyenLieu)
 ON DELETE NO ACTION,
  CONSTRAINT	fk_Ma_Mon_tmpCC	FOREIGN KEY (Ma_Mon_tmpCC)
 REFERENCES Mon_An(Ma_mon)
 ON DELETE NO ACTION,
 CONSTRAINT	fk_Ma_NCC_tmpCC	FOREIGN KEY (Ma_NCC_tmpCC)
 REFERENCES Nha_Cung_Cap(Ma_NCC)
 ON DELETE NO ACTION
 ON UPDATE NO ACTION
);
 -- END TABLE IS HERE -------------------
 -- TRIGGER CHECK FOR CREATE TABLE IS HERE: ----------
DELIMITER $$
CREATE TRIGGER check_ma_phong_trigger
BEFORE INSERT ON Phong_Vip
FOR EACH ROW
BEGIN
    DECLARE temp INT;
    SET temp = SUBSTRING(NEW.Ma_Phong, 4);
    IF NEW.Ma_Phong NOT REGEXP '^VIP[0-9]*$' OR temp < 0 OR temp != (SELECT COUNT(*) FROM Phong_Vip WHERE Ma_Phong REGEXP '^VIP[0-9]*$') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ma_Phong khong dung dinh dang';
    END IF;
END $$
DELIMITER ;










 -- END TRIGGER CHECK FOR CREATE TABLE IS HERE: ----------
 
 -- TEST CASE FOR TRIGGER USE FOR CREATE TABLE IS HERE --
 
--  INSERT INTO Phong_Vip (Ma_Phong, Ma_Khu, Min_Khach, Max_Khach)
-- VALUES ('VIP1', 'K01', 5, 40), ('VIP2', 'K02',  5, 40), ('VIP3', 'K03',  5, 40),
--         ('VIP4', 'K04', 5, 30), ('VIP5', 'K05',  5, 20);
 
--   INSERT INTO Phong_Vip (Ma_Phong, Ma_Khu, Min_Khach, Max_Khach)
-- VALUES ('VIP1', 'K01', 5, 40), ('VIP1', 'K02',  5, 40), ('VIP3', 'K03',  5, 40),
--         ('VIP4', 'K04', 5, 30), ('VIP5', 'K05',  5, 20);
 
 -- END TESTCASE ----------------------------------------
 
 
 
  -- INSERT TABLE IS HERE -------------------
  
  INSERT INTO Khu (Ma_Khu, Ten_Khu)
VALUES ('K01', 'A'), ('K02', 'B'), ('K03', 'C'), ('K04', 'D'), ('K05', 'E');

INSERT INTO Ban (Ma_Khu, STT, So_Ghe)
VALUES ('K01', 1, 4), ('K01', 2, 4), ('K01', 3, 4), ('K01', 4, 4), 
	('K01', 5, 6), ('K01', 6, 6),
        ('K01', 7, 8), ('K01', 8, 8),
        
        ('K02', 1, 4), ('K02', 2, 4), ('K02', 3, 4), ('K02', 4, 4), 
	('K02', 5, 6), ('K02', 6, 6),
        ('K02', 7, 8), ('K02', 8, 8),
        
        ('K03', 1, 4), ('K03', 2, 4), ('K03', 3, 4), ('K03', 4, 4), 
	('K03', 5, 6), ('K03', 6, 6),
        ('K03', 7, 8), ('K03', 8, 8),
        
        ('K04', 1, 4), ('K04', 2, 4), ('K04', 3, 4), ('K04', 4, 4), 
	('K04', 5, 6), ('K04', 6, 6),
        ('K04', 7, 8), ('K04', 8, 8),
        
        ('K05', 1, 4), ('K05', 2, 4), ('K05', 3, 4), ('K05', 4, 4), 
	('K05', 5, 6), ('K05', 6, 6),
        ('K05', 7, 8), ('K05', 8, 8);
        
INSERT INTO Phong_Vip (Ma_Phong, Ma_Khu, Min_Khach, Max_Khach)
VALUES ('VIP0', 'K01', 5, 40), ('VIP1', 'K02',  5, 40), ('VIP2', 'K03',  5, 40),
        ('VIP3', 'K04', 5, 30), ('VIP4', 'K05',  5, 20);

        
        


INSERT INTO Nhom VALUES ('1','Bánh');
INSERT INTO Nhom VALUES ('2','Cơm');
INSERT INTO Nhom VALUES ('3','Coffee');
INSERT INTO Nhom VALUES ('4','Trà');
INSERT INTO Nhom VALUES ('5','Nước ép & sinh tố');

INSERT INTO mon_an VALUES ('F1001','Bánh mì que','image11','1');
INSERT INTO mon_an VALUES ('F1002','Bánh crepe','image12','1');
INSERT INTO mon_an VALUES ('F1003','Bánh sừng bò','image13','1');
INSERT INTO mon_an VALUES ('F1004','Bánh trứng muối','image14','1');
INSERT INTO mon_an VALUES ('F2001','Cơm sườn','image21','2');
INSERT INTO mon_an VALUES ('F2002','Cơm gà','image22','2');
INSERT INTO mon_an VALUES ('F2003','Cơm chiên dương châu','image23','2');
INSERT INTO mon_an VALUES ('F2004','Cơm lam','image24','2');
INSERT INTO mon_an VALUES ('D3001','Espresso','image31','3');
INSERT INTO mon_an VALUES ('D3002','Cafe late','image32','3');
INSERT INTO mon_an VALUES ('D3003','Cafe trứng','image33','3');
INSERT INTO mon_an VALUES ('D3004','Caramel Macchiato','image34','3');
INSERT INTO mon_an VALUES ('D4001','Trà đào','image41','4');
INSERT INTO mon_an VALUES ('D4002','Hồng Trà Váng Sữa','image42','4');
INSERT INTO mon_an VALUES ('D4003','Trà Matcah Macchiato','image43','4');
INSERT INTO mon_an VALUES ('D4004','Trà đào cam sả','image44','4');
INSERT INTO mon_an VALUES ('D5001','Sinh tố bơ','image51','5');
INSERT INTO mon_an VALUES ('D5002','Sinh tố dâu','image52','5');
INSERT INTO mon_an VALUES ('D5003','Nước ép dưa hấu','image53','5');
INSERT INTO mon_an VALUES ('D5004','Nước ép cam','image54','5');
INSERT INTO mon_an VALUES ('D5005','Nước ép táo','image55','5');


INSERT INTO nuoc_uong VALUES ('D3001'); 
INSERT INTO nuoc_uong VALUES ('D3002'); 
INSERT INTO nuoc_uong VALUES ('D3003'); 
INSERT INTO nuoc_uong VALUES ('D3004'); 
INSERT INTO nuoc_uong VALUES ('D4001'); 
INSERT INTO nuoc_uong VALUES ('D4002'); 
INSERT INTO nuoc_uong VALUES ('D4003'); 
INSERT INTO nuoc_uong VALUES ('D4004'); 
INSERT INTO nuoc_uong VALUES ('D5001'); 
INSERT INTO nuoc_uong VALUES ('D5002'); 
INSERT INTO nuoc_uong VALUES ('D5003'); 
INSERT INTO nuoc_uong VALUES ('D5004'); 
INSERT INTO nuoc_uong VALUES ('D5005'); 


INSERT INTO Kich_Thuoc_Nuoc_Uong VALUES ('D3001','S',28000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D3001','M',35000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D3001','L',40000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D3002','S',30000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D3002','M',38000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D3002','L',45000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D3003','S',40000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D3003','M',48000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D3003','L',55000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D3004','S',40000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D3004','M',48000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D3004','L',55000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D4001','S',32000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D4001','M',40000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D4001','L',45000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D4002','S',35000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D4002','M',45000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D4002','L',52000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D4003','S',45000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D4003','M',52000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D4003','L',60000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D4004','S',40000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D4004','M',52000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D4004','L',60000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D5001','S',30000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D5001','M',40000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D5001','L',48000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D5002','S',30000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D5002','M',40000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D5002','L',48000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D5003','S',25000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D5003','M',33000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D5003','L',40000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D5004','S',25000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D5004','M',33000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D5004','L',40000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D5005','S',25000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D5005','M',33000);
INSERT INTO kich_thuoc_nuoc_uong VALUES ('D5005','L',40000);

INSERT INTO do_an VALUES ('F1001',15000);
INSERT INTO do_an VALUES ('F1002',22000);
INSERT INTO do_an VALUES ('F1003',28000);
INSERT INTO do_an VALUES ('F1004',28000);
INSERT INTO do_an VALUES ('F2001',35000);
INSERT INTO do_an VALUES ('F2002',35000);
INSERT INTO do_an VALUES ('F2003',35000);
INSERT INTO do_an VALUES ('F2004',35000);

INSERT INTO gio_phuc_vu_do_an VALUES ('F1001','06:00:00','22:00:00'); # theo giờ mở cửa 6h:22h
INSERT INTO gio_phuc_vu_do_an VALUES ('F1002','06:00:00','22:00:00'); # theo giờ mở cửa 6h:22h
INSERT INTO gio_phuc_vu_do_an VALUES ('F1003','06:00:00','22:00:00'); # theo giờ mở cửa 6h:22h
INSERT INTO gio_phuc_vu_do_an VALUES ('F1004','06:00:00','22:00:00'); # theo giờ mở cửa 6h:22h
INSERT INTO gio_phuc_vu_do_an VALUES ('F2001','10:00:00','15:00:00'); 
INSERT INTO gio_phuc_vu_do_an VALUES ('F2002','10:00:00','15:00:00');
INSERT INTO gio_phuc_vu_do_an VALUES ('F2003','10:00:00','15:00:00');
INSERT INTO gio_phuc_vu_do_an VALUES ('F2004','10:00:00','20:00:00');        
  
  
  
-- ====Them gia tri vao bang khach hang

INSERT INTO Khach_hang
VALUES('112345678901', 'Tran Thi Hoa', 'F', '1985-02-15', '0909123456', '12', 'Tran Hung Dao', 'District 1', 'Ben Nghe', 'TP.HCM', 8);
INSERT INTO Khach_hang
VALUES('212345678901', 'Pham Van Tuan', 'M', '1995-10-05', '0918234567', '24', 'Nguyen Trai', 'District 5', '4th Ward', 'TP.HCM', 10);
INSERT INTO Khach_hang
VALUES('312345678901', 'Nguyen Thi Thuy', 'F', '2000-12-01', '0976123456', '5', 'Dang Van Sam', 'District 9', 'Phuoc Long B', 'TP.HCM', 6);
INSERT INTO Khach_hang
VALUES('123456789012', 'Nguyen Van An', 'M', '1990-01-01', '0987654321', '10', 'Nguyen Van Linh', 'Quan 7', 'Phu My', 'TP.HCM', 8);
INSERT INTO Khach_hang
VALUES('234567890123', 'Tran Thi Bich', 'F', '1985-05-05', '0987654322', '15', 'Tran Quoc Thao', 'Quan 3', 'Ward 7', 'TP.HCM', 7);
INSERT INTO Khach_hang
VALUES('345678901234', 'Pham Van Cuong', 'M', '1995-10-15', '0987654323', '20', 'Pham Van Dong', 'Quan 9', 'Tam Binh', 'TP.HCM', 10);
INSERT INTO Khach_hang
VALUES('456789012345', 'Nguyen Thi Mai', 'F', '1992-12-25', '0987654324', '25', 'Cach Mang Thang Tam', 'Quan 10', 'Ward 4', 'TP.HCM', 12);
INSERT INTO Khach_hang
VALUES('567890123456', 'Le Minh Tuan', 'M', '1988-08-08', '0987654325', '30', 'Le Van Sy', 'Tan Binh', 'Ward 14', 'TP.HCM', 15);
INSERT INTO Khach_hang
VALUES('678901234567', 'Nguyen Thi Hong', 'F', '1993-03-03', '0987654326', '35', 'Vo Van Ngan', 'Thu Duc', 'Phuong Trung My Tay', 'TP.HCM', 18);
INSERT INTO Khach_hang
VALUES('789012345678', 'Tran Van Minh', 'M', '1980-06-20', '0987654327', '40', 'Nguyen Van Cu', 'Binh Thanh', 'Ward 25', 'TP.HCM', 22);
-- ====Them gia tri vao bang Hoa don

INSERT INTO Hoa_Don 
VALUES ('HD01012021000001', '2022-05-20', 5, '20:00', '23:00', 10, 3500000, '112345678901', 0);
INSERT INTO Hoa_Don
VALUES ('HD01012021000002', '2022-06-15', 2, '12:30', '15:30', 6, 1800000, '212345678901', 0);
INSERT INTO Hoa_Don
VALUES ('HD01012021000003', '2022-07-03', 4, '19:00', '22:00', 8, 2500000, '312345678901', 1);
INSERT INTO Hoa_Don
VALUES ('HD01012021000004', '2022-08-15', 2, '08:30', '12:00', 6, 1800000, '123456789012', 1);
INSERT INTO Hoa_Don
VALUES ('HD01012021000005', '2022-08-25', 3, '10:15', null, 10, 3200000, '234567890123', 1);
INSERT INTO Hoa_Don
VALUES ('HD01012021000006', '2022-09-05', 5, '07:00', '11:00', 12, 4000000, '345678901234', 1);
INSERT INTO Hoa_Don
VALUES ('HD01012021000007', '2022-09-12', 2, '17:30', '21:00', 5, 1500000, '456789012345', 1);
INSERT INTO Hoa_Don
VALUES ('HD01012021000008', '2022-10-01', 4, '14:00', NULL, 9, 2700000, '567890123456', 0);
INSERT INTO Hoa_Don
VALUES ('HD01012021000009', '2022-10-10', 3, '11:30', '15:00', 7, 2100000, '678901234567', 0);
INSERT INTO Hoa_Don
VALUES ('HD01012021000010', '2022-11-01', 6, '20:00', '23:00', 11, 3500000, '789012345678', 0);

-- Them gia vao bang Hoa_Don_Gom_Nuoc_Uong
INSERT INTO Hoa_Don_Gom_Nuoc_Uong
VALUES ('HD01012021000001', 'D3001','L', 6);
INSERT INTO Hoa_Don_Gom_Nuoc_Uong
VALUES ('HD01012021000002', 'D3002','M', 2);
INSERT INTO Hoa_Don_Gom_Nuoc_Uong
VALUES ('HD01012021000003', 'D3002','L', 3);
INSERT INTO Hoa_Don_Gom_Nuoc_Uong
VALUES ('HD01012021000004', 'D3003','S', 5);
INSERT INTO Hoa_Don_Gom_Nuoc_Uong
VALUES ('HD01012021000005', 'D4001','L', 2);
INSERT INTO Hoa_Don_Gom_Nuoc_Uong
VALUES ('HD01012021000006', 'D4002','S', 2);
INSERT INTO Hoa_Don_Gom_Nuoc_Uong
VALUES ('HD01012021000007', 'D5003','L', 2);
INSERT INTO Hoa_Don_Gom_Nuoc_Uong
VALUES ('HD01012021000008', 'D5004','S', 4);
INSERT INTO Hoa_Don_Gom_Nuoc_Uong
VALUES ('HD01012021000009', 'D5004','M', 2);
INSERT INTO Hoa_Don_Gom_Nuoc_Uong
VALUES ('HD01012021000010', 'D5004','L', 3);
  
-- Them gia tri vao bang Hoa_Don_Gom_Do_An
INSERT INTO Hoa_Don_Gom_Do_An VALUES ('HD01012021000001', 'F1001', 2);
INSERT INTO Hoa_Don_Gom_Do_An VALUES ('HD01012021000001', 'F1003', 1);
INSERT INTO Hoa_Don_Gom_Do_An VALUES ('HD01012021000001', 'F1004', 1);

INSERT INTO Hoa_Don_Gom_Do_An VALUES ('HD01012021000002', 'F1001', 1);
INSERT INTO Hoa_Don_Gom_Do_An VALUES ('HD01012021000002', 'F1002', 1);
INSERT INTO Hoa_Don_Gom_Do_An VALUES ('HD01012021000002', 'F2003', 1);
INSERT INTO Hoa_Don_Gom_Do_An VALUES ('HD01012021000002', 'F2002', 1);

INSERT INTO Hoa_Don_Gom_Do_An VALUES ('HD01012021000003', 'F1003', 3);
INSERT INTO Hoa_Don_Gom_Do_An VALUES ('HD01012021000003', 'F2004', 2);

INSERT INTO Hoa_Don_Gom_Do_An VALUES ('HD01012021000004', 'F2002', 1);

INSERT INTO Hoa_Don_Gom_Do_An VALUES ('HD01012021000005', 'F1001', 4);
INSERT INTO Hoa_Don_Gom_Do_An VALUES ('HD01012021000005', 'F2001', 4);

INSERT INTO Hoa_Don_Gom_Do_An VALUES ('HD01012021000006', 'F1003', 2);
INSERT INTO Hoa_Don_Gom_Do_An VALUES ('HD01012021000006', 'F2003', 5);
INSERT INTO Hoa_Don_Gom_Do_An VALUES ('HD01012021000006', 'F2004', 3);

INSERT INTO Hoa_Don_Gom_Do_An VALUES ('HD01012021000007', 'F2002', 3);

INSERT INTO Hoa_Don_Gom_Do_An VALUES ('HD01012021000008', 'F1004', 3);
INSERT INTO Hoa_Don_Gom_Do_An VALUES ('HD01012021000008', 'F2002', 2);

INSERT INTO Hoa_Don_Gom_Do_An VALUES ('HD01012021000009', 'F1002', 5);

INSERT INTO Hoa_Don_Gom_Do_An VALUES ('HD01012021000010', 'F1001', 1);
INSERT INTO Hoa_Don_Gom_Do_An VALUES ('HD01012021000010', 'F1002', 1);
INSERT INTO Hoa_Don_Gom_Do_An VALUES ('HD01012021000010', 'F2002', 2);
INSERT INTO Hoa_Don_Gom_Do_An VALUES ('HD01012021000010', 'F2003', 1);
INSERT INTO Hoa_Don_Gom_Do_An VALUES ('HD01012021000010', 'F2004', 3);

  -- Nguyên liệu (Mã nguyên liệu, tên, đơn vị tính, mô tả)
 INSERT INTO Nguyen_Lieu VALUES ('NL0001', 'Đường','kg','Đường cát');
  INSERT INTO Nguyen_Lieu VALUES ('NL0002', 'Muối','kg','Muối tây ninh');
  INSERT INTO Nguyen_Lieu (Ma_NguyenLieu, Ten, Don_Vi, Mo_Ta)
VALUES 
('NL0003', 'Bột mì', 'kg', 'Nguyên liệu làm bánh'),
('NL0004', 'Tỏi', 'kg', 'Nguyên liệu làm đồ ăn'),
('NL0005', 'Sữa tươi', 'ml', 'Nguyên liệu làm kem'),
('NL0006', 'Trứng gà', 'quả', 'Nguyên liệu làm bánh, kem'),
('NL0007', 'Nước mắm', 'ml', 'Nguyên liệu làm nước chấm');


INSERT INTO Nha_Cung_Cap(Ma_NCC, Ten_NCC, MST, So_Nha, Ten_Duong, Ten_Quan_Huyen, Ten_Phuong_Xa, Ten_Tinh)
VALUES
('NCC001', 'ABC', '012345678901',  '10', 'Le Lai', 'Quan 1', 'Ben Nghe', 'TP.HCM'),
('NCC002', 'DEF', '123456789012','20', 'Nguyen Van Cu', 'Quan 5', 'Tan Phu', 'TP.HCM'),
('NCC003', 'GHI', '234567890123', '30', 'Nguyen Hue', 'Quan 1', 'Ben Thanh', 'TP.HCM'),
('NCC004', 'JKL', '345678901234', '40', 'Pham Ngu Lao', 'Quan 1', 'Pham Ngu Lao', 'TP.HCM'),
('NCC005', 'MNO', '456789012345', '50', 'Cach Mang Thang Tam', 'Quan 10', '10A', 'TP.HCM'),
('NCC006', 'PQR', '567890123456','60', 'Tran Hung Dao', 'Quan 5', 'Tan Phu', 'TP.HCM'),
('NCC007', 'STU', '678901234567', '70', 'Vo Thi Sau', 'Quan 3', 'Tan Dinh', 'TP.HCM');

INSERT INTO Email_NCC(Ma_NCC_tmp, Email_NCC)
VALUES
('NCC001', 'tri.nguyenhoangminh@hcmut.edu.vn'),
('NCC001', 'tri.nguyenhoangminh@gmail.com'),
('NCC002', 'hoangminhtri2002zz@gmail.com'),
('NCC003', 'ghi@abc.com'),
('NCC004', 'jkl@def.vn'),
('NCC005', 'mno@ghi.com'),
('NCC006', 'pqr@jkl.vn'),
('NCC007', 'stu@mno.com');
 
 INSERT INTO Dien_Thoai_NCC (Ma_NCC_tmp, SDT_NCC)
VALUES 
  ('NCC001', '0901234567'),
  ('NCC002', '0902222222'),
  ('NCC003', '0123456789'),
  ('NCC004', '0904444444'),
  ('NCC005', '0987654321'),
  ('NCC006', '0906666666'),
  ('NCC007', '0912345678');
 
 
 INSERT INTO Mua_Nguyen_Lieu (Ma_NL_tmp, Ma_NCC_tmp, Don_Gia)
VALUES
('NL0001', 'NCC001', 50000),
('NL0002', 'NCC002', 55000),
('NL0003', 'NCC003', 55000),
('NL0004', 'NCC004', 55000),
('NL0005', 'NCC005', 55000),
('NL0006', 'NCC006', 55000),
('NL0007', 'NCC007', 55000);


INSERT INTO Lan_Mua (Ma_NL_tmp, Ma_NCC_tmp, Thoi_gian, So_Luong)
VALUES 
('NL0001', 'NCC001', '2022-03-15 10:30:00', 5),
('NL0002', 'NCC002', '2022-03-20 14:00:00', 10),
('NL0003', 'NCC003', '2022-03-21 11:45:00', 3),
('NL0004', 'NCC004', '2022-03-23 16:20:00', 4),
('NL0005', 'NCC005', '2022-03-25 09:15:00', 2),
('NL0006', 'NCC006', '2022-03-27 13:30:00', 6),
('NL0007', 'NCC007', '2022-03-29 10:00:00', 8);



INSERT INTO Cung_Cap(Ma_Nguyen_Lieu_tmpCC, Ma_Mon_tmpCC, Ma_NCC_tmpCC)
VALUES 
('NL0001', 'F1001', 'NCC001'),
('NL0001', 'F1002', 'NCC001'),
('NL0001', 'D3001', 'NCC001'),
('NL0002', 'F2004', 'NCC002'),
('NL0003', 'F1003', 'NCC003'),
('NL0003', 'F1004', 'NCC003'),
('NL0005', 'D4002', 'NCC005'),
('NL0005', 'D5001', 'NCC007');

  INSERT INTO Ban_Hoa_Don (Ma_Hoa_Don, Ma_Khu, STT)
VALUES ('HD01012021000001', 'K01', 1) , ('HD01012021000002', 'K01', 5),
		('HD01012021000003', 'K02', 3) , ('HD01012021000004', 'K03', 3),
        ('HD01012021000005', 'K04', 1) , ('HD01012021000006', 'K05', 6);
        
INSERT INTO Phong_Vip_Hoa_Don (Ma_Hoa_Don, Ma_Phong)
VALUES ('HD01012021000007', 'VIP1'), ('HD01012021000008', 'VIP1'),
		('HD01012021000009', 'VIP2'), ('HD01012021000010', 'VIP4');  