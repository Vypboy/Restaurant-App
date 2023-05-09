USE  Assignment2_Restaurent;
DELIMITER //
CREATE FUNCTION StatusOfTable(makhu CHAR(3), stt INT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    IF EXISTS(SELECT 1 FROM Ban_Hoa_Don WHERE Ma_Khu = makhu AND STT = stt) THEN
		IF EXISTS(SELECT 1 FROM Hoa_Don hd
				  INNER JOIN Ban_Hoa_Don bhd ON hd.Ma_Hoa_Don = bhd.Ma_Hoa_Don
				  WHERE bhd.Ma_Khu = makhu AND bhd.STT = stt AND hd.Gio_Ra IS NULL) THEN
			RETURN 'No';
		ELSE
			RETURN 'Yes';
		END IF;
    ELSE
        RETURN 'Not Exist';
    END IF;
END //

CREATE FUNCTION StatusOfVIP(maphong CHAR(10))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
        IF EXISTS(SELECT 1 FROM Phong_Vip_Hoa_Don WHERE Ma_Phong = maphong) THEN
		IF EXISTS(SELECT 1 FROM Hoa_Don hd
				  INNER JOIN Phong_Vip_Hoa_Don pvhd ON hd.Ma_Hoa_Don = pvhd.Ma_Hoa_Don
				  WHERE pvhd.Ma_Phong = maphong AND hd.Gio_Ra IS NULL) THEN
			RETURN 'No';
		ELSE
			RETURN 'Yes';
		END IF;
    ELSE
        RETURN 'Not Exist';
    END IF;
END //

DELIMITER //
CREATE PROCEDURE ThongKeDoanhThu(p_Nam INT)
BEGIN
    DECLARE tong_thu FLOAT;
    DECLARE tong_thu_nuoc_uong FLOAT;
    DECLARE tong_thu_do_an FLOAT;
    DECLARE thang INT;
    DECLARE cur CURSOR FOR SELECT DISTINCT MONTH(Ngay) FROM Hoa_Don WHERE YEAR(Ngay) = p_Nam;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET @finished = 1;
    
    DROP TEMPORARY TABLE IF EXISTS Thong_Ke_Tung_Thang;
    CREATE TEMPORARY TABLE Thong_Ke_Tung_Thang (Thang INT, Doanh_Thu FLOAT);
    
    OPEN cur;
    SET @finished = 0;
    
    read_loop: LOOP
        FETCH cur INTO thang;
        IF @finished = 1 THEN
            LEAVE read_loop;
        END IF;
        
        SET tong_thu = 0;
        SET tong_thu_nuoc_uong = 0;
        SET tong_thu_do_an = 0;
        
        SELECT SUM(ktnu.Don_Gia * hdn.So_Luong) INTO tong_thu_nuoc_uong
        FROM Hoa_Don hdon
        JOIN Hoa_Don_Gom_Nuoc_Uong hdn ON hdon.Ma_Hoa_Don = hdn.Ma_Hoa_Don
        JOIN Kich_Thuoc_Nuoc_Uong ktnu ON hdn.Ma_Nuoc_Uong = ktnu.Ma_Nuoc_Uong AND hdn.Size = ktnu.Size
        WHERE MONTH(hdon.Ngay) = thang AND YEAR(hdon.Ngay) = p_Nam;
        
        SELECT SUM(da.Don_Gia * hdda.So_Luong) INTO tong_thu_do_an
        FROM Hoa_Don hdon
        JOIN Hoa_Don_Gom_Do_An hdda ON hdon.Ma_Hoa_Don = hdda.Ma_Hoa_Don
        JOIN do_an da ON hdda.Ma_Do_An = da.Ma_Do_An
        WHERE MONTH(hdon.Ngay) = thang AND YEAR(hdon.Ngay) = p_Nam;
        
        INSERT INTO Thong_Ke_Tung_Thang (Thang, Doanh_Thu) VALUES (thang, tong_thu_nuoc_uong + tong_thu_do_an);
    END LOOP;
    
    CLOSE cur;
    
    SELECT * FROM Thong_Ke_Tung_Thang;
END //

DELIMITER ;

-- TESTCASE FOR FUNCTION ---------------------------------
-- Testcase for function 1
SELECT StatusOfTable('K01',5), StatusOfTable('K02',4),StatusOfTable('K06',7),
StatusOfTable('K04',3);
-- Testcase for function 2
SELECT StatusOfVIP('VIP1'),StatusOfVIP('VIP2'),StatusOfVIP('VIP3'),StatusOfVIP('VIP4');
-- Testcase for function 3
CALL ThongKeDoanhThu('2022');








-- TRIGGER - QUESTION 2 ------------------------------------------------------------------
drop trigger if exists update_chi_chon_ban_trong;
DELIMITER $$
CREATE TRIGGER update_chi_chon_ban_trong
BEFORE UPDATE ON Ban_hoa_don
FOR EACH ROW
BEGIN
    DECLARE ma_khu VARCHAR(3);
    DECLARE stt INT;
    
    SELECT NEW.Ma_Khu INTO ma_khu;
    SELECT NEW.STT INTO stt;
IF (StatusOfTable(ma_khu,stt) = 'No') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cant Order!';
    SET NEW = OLD;
END IF;
END$$
DELIMITER ;

-- =====TEST trigger chi duoc chon ban trong=============
select * from Ban_Hoa_Don;
-- ta thu ktra ban ('K01',5) co trong hay khong
select statusOfTable('K01',5);
-- func = 'No' -> Ban khong trong
-- -> khong the update cho ban nay
UPDATE Ban_hoa_don
SET STT=5
Where Ma_Hoa_Don = 'HD01012021000001' AND Ma_Khu='K01';

-- TESTCASE 2 FOR UPDATE -- case: ban khong trong
select statusOfTable('K04',1);
UPDATE Ban_hoa_don
SET STT=1
Where Ma_Hoa_Don = 'HD01012021000005' AND Ma_Khu='K04';


-- =========== trigger chi update cho phongVip cont rong=================
DROP TRIGGER IF EXISTS update_chi_chon_pvip_trong;
DELIMITER $$
CREATE TRIGGER update_chi_chon_pvip_trong
BEFORE UPDATE ON Phong_vip_hoa_don
FOR EACH ROW
BEGIN
    DECLARE ma_phong VARCHAR(10);

	SELECT NEW.Ma_Phong INTO  ma_phong;
	IF (StatusOfVip(ma_phong) = 'No') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cant Order!';
        SET NEW = OLD;
	END IF;
END$$
DELIMITER ;
-- ===================test=======================
-- TESTECASE: can update for VIP4 -- 
select * from Phong_vip_hoa_don;
-- ta thu ktra phong_vip ('VIP1') co trong hay khong
select statusOfVip('VIP4');
-- func = 'No' -> VIP1 khong trong
-- -> khong the update cho pVip nay
UPDATE Phong_vip_hoa_don
SET Ma_Phong='VIP4'
Where Ma_Hoa_Don = 'HD01012021000010';
-- -> lenh update tren khong the thuc hien
-- TESTECASE: can't update for VIP1 --
select statusOfVip('VIP1'); 
UPDATE Phong_vip_hoa_don
SET Ma_Phong='VIP1'
Where Ma_Hoa_Don = 'HD01012021000007';

-- ==================TRIGGER -  QUESTION 2  - INSERT METHOD==========================
drop trigger if exists insert_chi_chon_ban_trong;
DELIMITER $$
CREATE TRIGGER insert_chi_chon_ban_trong
BEFORE INSERT ON Ban_hoa_don
FOR EACH ROW
BEGIN
    DECLARE ma_khu VARCHAR(3);
    DECLARE stt INT;
    
    SELECT NEW.Ma_Khu INTO ma_khu;
    SELECT NEW.STT INTO stt;
IF (StatusOfTable(ma_khu,stt) = 'No') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cant Order!';
    SET NEW = OLD;
END IF;
END$$
DELIMITER ;

-- =====test=============
select * from Ban_Hoa_Don;
select * from Hoa_Don;
-- ta thu ktra ban ('K01',5) co trong hay khong
select statusOfTable('K01',5);
-- func = 'No' -> Ban khong trong
-- -> khong the insert cho ban nay

-- Truoc tien tao 1 hoa don moi
INSERT INTO Hoa_Don 
VALUES ('HD01012021000011', '2022-05-20', 5, '20:00', '20:30', 10, 3500000, '112345678901', 1);
-- Insert vao bang Ban_Hoa_Don vs hoa don vua tao voi ban ('K01',5)
INSERT INTO Ban_Hoa_Don (Ma_Hoa_Don, Ma_Khu, STT)
VALUES ('HD01012021000011', 'K01', 5);

-- TESTCASE: CAN'T INSERT -> vi ban khong trong nen se hien canh bao "Cant Order!"
select statusOfTable('K04',1);
INSERT INTO Hoa_Don 
VALUES ('HD01012021000012', '2022-05-20', 5, '20:00', '20:30', 10, 3500000, '112345678901', 1);
-- Insert vao bang Ban_Hoa_Don vs hoa don vua tao voi ban ('K01',5)
INSERT INTO Ban_Hoa_Don (Ma_Hoa_Don, Ma_Khu, STT)
VALUES ('HD01012021000012', 'K04', 1);
-- ==============================================================================
DROP TRIGGER IF EXISTS insert_chi_chon_pvip_trong;
DELIMITER $$
CREATE TRIGGER insert_chi_chon_pvip_trong
BEFORE INSERT ON Phong_vip_hoa_don
FOR EACH ROW
BEGIN
    DECLARE ma_phong VARCHAR(10);

	SELECT NEW.Ma_Phong INTO  ma_phong;
	IF (StatusOfVip(ma_phong) = 'No') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cant Order!';
        SET NEW = OLD;
	END IF;
END$$
DELIMITER ;
-- =====test=======
-- tuong tu voi update_chi_chon_pvip_trong
select * from Phong_vip_hoa_don;
-- ta thu ktra phong_vip ('VIP1') co trong hay khong
select statusOfVip('VIP1');
-- func = 'No' -> VIP1 khong trong
-- -> khong the insert 
INSERT INTO Phong_vip_hoa_don (Ma_Hoa_Don, Ma_Phong)
VALUES ('HD01012021000001', 'VIP1');


