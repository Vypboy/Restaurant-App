-- ===========================TRIGGER 1A ==================
USE Assignment2_Restaurent;
DELIMITER $$
-- ========TRIGGER FOR UPDATE METHOD================
CREATE TRIGGER update_so_luong_mon
BEFORE UPDATE ON Hoa_don_gom_do_an
FOR EACH ROW
BEGIN
    DECLARE ma_hd VARCHAR(16);
    DECLARE thanh_toan BIT;
    DECLARE so_luong INT;
    
    SELECT NEW.Ma_Hoa_Don INTO ma_hd;
    SELECT NEW.So_Luong -OLD.So_Luong INTO so_luong;
    SELECT Da_Thanh_Toan INTO thanh_toan FROM Hoa_Don WHERE Ma_Hoa_Don = ma_hd;

	
    IF (thanh_toan=1) THEN
        UPDATE Hoa_Don
        SET SL_Mon = SL_Mon + so_luong
        WHERE Ma_Hoa_Don = ma_hd;
    END IF;
END$$
DELIMITER ;

drop trigger if exists insert_so_luong_mon;
DELIMITER $$


DELIMITER $$
-- ========TRIGGER UPDATA NUOC UONG================
CREATE TRIGGER update_so_luong_mon_nuoc_uong
BEFORE UPDATE ON Hoa_don_gom_nuoc_uong
FOR EACH ROW
BEGIN
    DECLARE ma_hd VARCHAR(16);
    DECLARE thanh_toan BIT;
    DECLARE so_luong INT;
    
    SELECT NEW.Ma_Hoa_Don INTO ma_hd;
    SELECT NEW.So_Luong -OLD.So_Luong INTO so_luong;
    SELECT Da_Thanh_Toan INTO thanh_toan FROM Hoa_Don WHERE Ma_Hoa_Don = ma_hd;

	
    IF (thanh_toan=1) THEN
        UPDATE Hoa_Don
        SET SL_Mon = SL_Mon + so_luong
        WHERE Ma_Hoa_Don = ma_hd;
    END IF;
END$$
DELIMITER ;

-- ==TESTCASE FOR UPDATE TRIGGER==========
--  xem số luong mon o bang Hoa_Don
--  update thay doi SL_mon
update Hoa_don_gom_do_an
set So_Luong = 9
where Ma_Hoa_Don = 'HD01012021000004';
--  Check su thay doi so luong mon o bang Hoa_Don

--  update thay doi SL_mon
update Hoa_don_gom_nuoc_uong
set So_Luong = 2
where Ma_Hoa_Don = 'HD01012021000004';
--  Check su thay doi so luong mon o bang Hoa_Don
select * from Hoa_don;
select * from Hoa_don_gom_nuoc_uong;
select * from Hoa_don_gom_do_an;


drop trigger if exists insert_so_luong_mon;
DELIMITER $$
-- ========trigger cho insert================
CREATE TRIGGER insert_so_luong_mon
BEFORE INSERT ON Hoa_don_gom_do_an
FOR EACH ROW
BEGIN
    DECLARE ma_hd VARCHAR(16);
    DECLARE thanh_toan BIT;
    DECLARE so_luong INT;
    
    SELECT NEW.Ma_Hoa_Don INTO ma_hd;
    SELECT NEW.So_Luong INTO so_luong;
    SELECT Da_Thanh_Toan INTO thanh_toan FROM Hoa_Don WHERE Ma_Hoa_Don = ma_hd;

    IF (thanh_toan=1) THEN
        UPDATE Hoa_Don
        SET SL_Mon = SL_Mon + so_luong
        WHERE Ma_Hoa_Don = ma_hd;
    END IF;
END$$
DELIMITER ;

DELIMITER $$
-- ========trigger cho insert================
CREATE TRIGGER insert_so_luong_mon_nuoc_uong
BEFORE INSERT ON Hoa_don_gom_nuoc_uong
FOR EACH ROW
BEGIN
    DECLARE ma_hd VARCHAR(16);
    DECLARE thanh_toan BIT;
    DECLARE so_luong INT;
    
    SELECT NEW.Ma_Hoa_Don INTO ma_hd;
    SELECT NEW.So_Luong INTO so_luong;
    SELECT Da_Thanh_Toan INTO thanh_toan FROM Hoa_Don WHERE Ma_Hoa_Don = ma_hd;

    IF (thanh_toan=1) THEN
        UPDATE Hoa_Don
        SET SL_Mon = SL_Mon + so_luong
        WHERE Ma_Hoa_Don = ma_hd;
    END IF;
END$$
DELIMITER ;

-- TEST FOR INSERT TRIGGER
INSERT INTO Hoa_don_gom_do_an VALUES('HD01012021000004','F1001',4);
INSERT INTO Hoa_don_gom_nuoc_uong VALUES('HD01012021000004','D3004','L',5);
INSERT INTO Hoa_don_gom_nuoc_uong VALUES('HD01012021000004','D4001','L',5);
SELECT * FROM assignment2_restaurent.hoa_don_gom_nuoc_uong;
SELECT * FROM assignment2_restaurent.hoa_don_gom_do_an;
SELECT * FROM assignment2_restaurent.hoa_don;

-- ========trigger cho delete================
DELIMITER $$
CREATE TRIGGER delete_so_luong_mon
BEFORE DELETE ON Hoa_don_gom_do_an
FOR EACH ROW
BEGIN
    DECLARE ma_hd VARCHAR(16);
    DECLARE thanh_toan BIT;
    DECLARE so_luong INT;
    
    SELECT OLD.Ma_Hoa_Don INTO ma_hd;
    SELECT OLD.So_Luong INTO so_luong;
    SELECT Da_Thanh_Toan INTO thanh_toan FROM Hoa_Don WHERE Ma_Hoa_Don = ma_hd;

    IF (thanh_toan=1) THEN
        UPDATE Hoa_Don
        SET SL_Mon = SL_Mon - so_luong
        WHERE Ma_Hoa_Don = ma_hd;
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER delete_so_luong_mon_nuoc_uong
BEFORE DELETE ON Hoa_don_gom_nuoc_uong
FOR EACH ROW
BEGIN
    DECLARE ma_hd VARCHAR(16);
    DECLARE thanh_toan BIT;
    DECLARE so_luong INT;
    
    SELECT OLD.Ma_Hoa_Don INTO ma_hd;
    SELECT OLD.So_Luong INTO so_luong;
    SELECT Da_Thanh_Toan INTO thanh_toan FROM Hoa_Don WHERE Ma_Hoa_Don = ma_hd;

    IF (thanh_toan=1) THEN
        UPDATE Hoa_Don
        SET SL_Mon = SL_Mon - so_luong
        WHERE Ma_Hoa_Don = ma_hd;
    END IF;
END$$
DELIMITER ;
-- TEST FOR DELETE TRIGGER
DELETE FROM Hoa_don_gom_nuoc_uong
WHERE Ma_Hoa_Don='HD01012021000004' AND Ma_Nuoc_Uong='D4001';

SELECT * FROM assignment2_restaurent.hoa_don_gom_nuoc_uong;
SELECT * FROM assignment2_restaurent.hoa_don_gom_do_an;
SELECT * FROM assignment2_restaurent.hoa_don;

 -- ==========TRIGGER 1C====================
 -- =============trigger luc update Tong_Tien bang Hoa_Don=======
DROP TRIGGER IF EXISTS cap_nhat_diem;
DELIMITER $$
CREATE TRIGGER cap_nhat_diem
BEFORE UPDATE ON Hoa_Don
FOR EACH ROW
BEGIN
	DECLARE ma_kh CHAR(12); 
    DECLARE thanh_toan BIT; 
    DECLARE diem_cong INT; 
    DECLARE tien DECIMAL;
    SELECT NEW.Ma_Khach_Hang INTO ma_kh;
    SELECT NEW.Da_Thanh_Toan INTO thanh_toan;
    SELECT NEW.Tong_Tien - OLD.Tong_Tien INTO tien;
    SET diem_cong = tien/10000;
	IF ( thanh_toan=1) THEN
			UPDATE khach_hang
			SET Diem = Diem + diem_cong
			WHERE CMND_CCCD=ma_kh;
	END IF;
END$$
 DELIMITER ;
 -- ======trigger luc insert 1 hoa don moi vao bang Hoa_Don============
 DROP TRIGGER IF EXISTS cong_diem;
DELIMITER $$
CREATE TRIGGER cong_diem
BEFORE INSERT ON Hoa_Don
FOR EACH ROW
BEGIN
	DECLARE ma_kh CHAR(12); 
    DECLARE thanh_toan BIT; 
    DECLARE diem_cong INT; 
    DECLARE tien DECIMAL;
    SELECT NEW.Ma_Khach_Hang INTO ma_kh;
    SELECT NEW.Da_Thanh_Toan INTO thanh_toan;
    SELECT NEW.Tong_Tien INTO tien;
    SET diem_cong = tien/10000;
	IF ( thanh_toan=1) THEN
			UPDATE khach_hang
			SET Diem = Diem + diem_cong
			WHERE CMND_CCCD=ma_kh;
	END IF;
END$$
 DELIMITER ;
 -- ======trigger luc delete 1 hoa don moi vao bang Hoa_Don============
 DROP TRIGGER IF EXISTS tru_diem;
DELIMITER $$
CREATE TRIGGER tru_diem
BEFORE DELETE ON Hoa_Don
FOR EACH ROW
BEGIN
	DECLARE ma_kh CHAR(12); 
    DECLARE thanh_toan BIT; 
    DECLARE diem_cong INT; 
    DECLARE tien DECIMAL;
    SELECT OLD.Ma_Khach_Hang INTO ma_kh;
    SELECT OLD.Da_Thanh_Toan INTO thanh_toan;
    SELECT OLD.Tong_Tien INTO tien;
    SET diem_cong = tien/10000;
	IF ( thanh_toan=1) THEN
			UPDATE khach_hang
			SET Diem = Diem - diem_cong
			WHERE CMND_CCCD=ma_kh;
	END IF;
END$$
 DELIMITER ;
 
  -- =================test luc update==============
select * from Hoa_Don where  Ma_Hoa_Don = 'HD01012021000004';

 update Hoa_Don
 set Tong_Tien = 400000
 where Ma_Hoa_Don = 'HD01012021000004';
 
select * from Hoa_Don where  Ma_Hoa_Don = 'HD01012021000004';
 select Diem from Khach_Hang  where CMND_CCCD= '123456789012';
 -- ========test luc insert========
INSERT INTO Hoa_Don 
VALUES 	('HD01012021000012', '2022-05-20', 5, '20:00', '20:15', 10, 3500000, '112345678901', 1);
select Diem from khach_hang where CMND_CCCD='112345678901';
select * from Hoa_Don;
select * from Khach_Hang;
  -- ========test luc delete========
  DELETE FROM Hoa_Don
  WHERE Ma_Hoa_Don='HD01012021000012';
  select * from Hoa_Don;
select * from Khach_Hang;
select Diem from khach_hang where CMND_CCCD='112345678901';

