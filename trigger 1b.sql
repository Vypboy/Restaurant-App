-- ================================================TRIGGER 1B ===================================================
USE  Assignment2_Restaurent;
-- =================1.b cho bang Hoa_don_gom_do_an=========================
select * from Hoa_Don;
select * from Hoa_Don_gom_do_an;
select * from Phong_vip_hoa_Don;
select * from Phong_Vip;
-- =============trigger cho update=========
drop trigger if exists update_tong_tien_do_an;
DELIMITER $$
CREATE TRIGGER update_tong_tien_do_an
BEFORE UPDATE ON Hoa_don_gom_do_an
FOR EACH ROW
BEGIN
    DECLARE ma_hd VARCHAR(16);
    DECLARE thanh_toan BIT;
    DECLARE so_tien DECIMAL;
    DECLARE tien_mon_moi DECIMAL;
    DECLARE tien_mon_cu DECIMAL;
    DECLARE phu_thu DECIMAL;
    DECLARE ma_phong VARCHAR(10);
    DECLARE min_no_vip INT;
    
    SELECT NEW.Ma_Hoa_Don INTO ma_hd;
    SELECT Ma_Phong INTO ma_phong FROM Phong_vip_hoa_don WHERE Ma_Hoa_Don=ma_hd;
	SELECT Min_Khach INTO min_no_vip FROM Phong_Vip WHERE Ma_Phong = ma_phong;
    iF( EXISTS(SELECT Ma_Phong FROM Phong_vip_hoa_don WHERE Ma_Hoa_Don=ma_hd) = 0) THEN
		SELECT (Hoa_Don.SL_Khach-Hoa_Don.SL_Mon)*100000 INTO phu_thu 
		FROM Hoa_Don WHERE Ma_Hoa_Don=ma_hd;
	ELSE
		SELECT (min_no_vip-Hoa_Don.SL_Mon)*100000 INTO phu_thu  
		FROM Hoa_Don WHERE Ma_Hoa_Don=ma_hd;
    END IF;
    -- neu phu thu am nghia la SL_Khach du yeu cau va ko can tinh phu thu
    IF(phu_thu < 0) THEN
		SET phu_thu = 0;
    END IF;
    
    SELECT Don_gia INTO tien_mon_moi FROM Do_An WHERE Ma_do_an = NEW.Ma_Do_An;
    SELECT Don_gia INTO tien_mon_cu FROM Do_An WHERE Ma_do_an = OLD.Ma_Do_An;
    SELECT tien_mon_moi*NEW.So_Luong - tien_mon_cu*OLD.So_Luong INTO so_tien;
    SELECT Da_Thanh_Toan INTO thanh_toan FROM Hoa_Don WHERE Ma_Hoa_Don = ma_hd;

    IF (thanh_toan=1) THEN
        UPDATE Hoa_Don
        SET Tong_Tien = Tong_Tien + so_tien + phu_thu
        WHERE Ma_Hoa_Don = ma_hd;
    END IF;
END$$
DELIMITER ;

-- =====trigger cho insert ==========
drop trigger if exists insert_tong_tien_do_an;
DELIMITER $$
CREATE TRIGGER insert_tong_tien_do_an
BEFORE INSERT ON Hoa_don_gom_do_an
FOR EACH ROW
BEGIN
    DECLARE ma_hd VARCHAR(16);
    DECLARE thanh_toan BIT;
    DECLARE so_tien DECIMAL;
    DECLARE tien_mon_moi DECIMAL;
    DECLARE tien_mon_cu DECIMAL;
    DECLARE phu_thu DECIMAL;
    DECLARE ma_phong VARCHAR(10);
    DECLARE min_no_vip INT;
    
    SELECT NEW.Ma_Hoa_Don INTO ma_hd;
    SELECT Ma_Phong INTO ma_phong FROM Phong_vip_hoa_don WHERE Ma_Hoa_Don=ma_hd;
	SELECT Min_Khach INTO min_no_vip FROM Phong_Vip WHERE Ma_Phong = ma_phong;
    iF( EXISTS(SELECT Ma_Phong FROM Phong_vip_hoa_don WHERE Ma_Hoa_Don=ma_hd) = 0) THEN
		SELECT (Hoa_Don.SL_Khach-Hoa_Don.SL_Mon)*100000 INTO phu_thu 
		FROM Hoa_Don WHERE Ma_Hoa_Don=ma_hd;
	ELSE
		SELECT (min_no_vip-Hoa_Don.SL_Mon)*100000 INTO phu_thu  
		FROM Hoa_Don WHERE Ma_Hoa_Don=ma_hd;
    END IF;
    -- neu phu thu am nghia la SL_Khach du yeu cau va ko can tinh phu thu
    IF(phu_thu < 0) THEN
		SET phu_thu = 0;
    END IF;
    
    SELECT Don_gia INTO tien_mon_moi FROM Do_An WHERE Ma_do_an = NEW.Ma_Do_An;
    SELECT tien_mon_moi*NEW.So_Luong INTO so_tien;
    SELECT Da_Thanh_Toan INTO thanh_toan FROM Hoa_Don WHERE Ma_Hoa_Don = ma_hd;

    IF (thanh_toan=1) THEN
        UPDATE Hoa_Don
        SET Tong_Tien = Tong_Tien + so_tien + phu_thu
        WHERE Ma_Hoa_Don = ma_hd;
    END IF;
END$$
DELIMITER ;

-- ===================triggrt cho delete===============
drop trigger if exists delete_tong_tien_do_an;
DELIMITER $$
CREATE TRIGGER delete_tong_tien_do_an
BEFORE DELETE ON Hoa_don_gom_do_an
FOR EACH ROW
BEGIN
    DECLARE ma_hd VARCHAR(16);
    DECLARE thanh_toan BIT;
    DECLARE so_tien DECIMAL;
    DECLARE tien_mon_cu DECIMAL;
    
    SELECT Don_gia INTO tien_mon_cu FROM Do_An WHERE Ma_do_an = OLD.Ma_Do_An;
    SELECT OLD.Ma_Hoa_Don INTO ma_hd;
    SELECT tien_mon_cu*OLD.So_Luong INTO so_tien;
    SELECT Da_Thanh_Toan INTO thanh_toan FROM Hoa_Don WHERE Ma_Hoa_Don = ma_hd;

    IF (thanh_toan=1) THEN
        UPDATE Hoa_Don
        SET Tong_Tien = Tong_Tien - so_tien
        WHERE Ma_Hoa_Don = ma_hd;
    END IF;
END$$
DELIMITER ;




-- =================1.b cho bang Hoa_don_gom_nuoc_uong=========================
select * from Hoa_Don;
select * from Hoa_Don_gom_do_an;
select * from Phong_vip_hoa_Don;
select * from Phong_Vip;
-- =============trigger cho update=========
drop trigger if exists update_tong_tien_nuoc;
DELIMITER $$
CREATE TRIGGER update_tong_tien_nuoc
BEFORE UPDATE ON Hoa_don_gom_nuoc_uong
FOR EACH ROW
BEGIN
    DECLARE ma_hd VARCHAR(16);
    DECLARE thanh_toan BIT;
    DECLARE so_tien DECIMAL;
    DECLARE tien_mon_moi DECIMAL;
    DECLARE tien_mon_cu DECIMAL;
    -- DECLARE phu_thu DECIMAL;
    DECLARE ma_phong VARCHAR(10);
    -- DECLARE min_no_vip INT;
    
    SELECT NEW.Ma_Hoa_Don INTO ma_hd;
    SELECT Ma_Phong INTO ma_phong FROM Phong_vip_hoa_don WHERE Ma_Hoa_Don=ma_hd;
	-- SELECT Min_Khach INTO min_no_vip FROM Phong_Vip WHERE Ma_Phong = ma_phong;

    
    SELECT Don_gia INTO tien_mon_moi FROM Kich_thuoc_nuoc_uong 
    WHERE Ma_nuoc_uong = NEW.Ma_nuoc_uong AND Size = NEW.Size;
    SELECT Don_gia INTO tien_mon_cu FROM Kich_thuoc_nuoc_uong 
    WHERE Ma_nuoc_uong = OLD.Ma_nuoc_uong AND Size = OLD.Size;
    SELECT tien_mon_moi*NEW.So_Luong - tien_mon_cu*OLD.So_Luong INTO so_tien;
    SELECT Da_Thanh_Toan INTO thanh_toan FROM Hoa_Don WHERE Ma_Hoa_Don = ma_hd;

    IF (thanh_toan=1) THEN
        UPDATE Hoa_Don
        SET Tong_Tien = Tong_Tien + so_tien + phu_thu
        WHERE Ma_Hoa_Don = ma_hd;
    END IF;
END$$
DELIMITER ;
select * from Kich_thuoc_nuoc_uong;
-- =====trigger cho insert ==========
drop trigger if exists insert_tong_tien_nuoc_uong;
DELIMITER $$
CREATE TRIGGER insert_tong_tien_nuoc_uong
BEFORE INSERT ON Hoa_don_gom_nuoc_uong
FOR EACH ROW
BEGIN
    DECLARE ma_hd VARCHAR(16);
    DECLARE thanh_toan BIT;
    DECLARE so_tien DECIMAL;
    DECLARE tien_mon_moi DECIMAL;
    DECLARE tien_mon_cu DECIMAL;
    DECLARE phu_thu DECIMAL;
    DECLARE ma_phong VARCHAR(10);
    DECLARE min_no_vip INT;
    
    SELECT NEW.Ma_Hoa_Don INTO ma_hd;
    SELECT Ma_Phong INTO ma_phong FROM Phong_vip_hoa_don WHERE Ma_Hoa_Don=ma_hd;
	SELECT Min_Khach INTO min_no_vip FROM Phong_Vip WHERE Ma_Phong = ma_phong;
    iF( EXISTS(SELECT Ma_Phong FROM Phong_vip_hoa_don WHERE Ma_Hoa_Don=ma_hd) = 0) THEN
		SELECT (Hoa_Don.SL_Khach-Hoa_Don.SL_Mon)*100000 INTO phu_thu 
		FROM Hoa_Don WHERE Ma_Hoa_Don=ma_hd;
	ELSE
		SELECT (min_no_vip-Hoa_Don.SL_Mon)*100000 INTO phu_thu  
		FROM Hoa_Don WHERE Ma_Hoa_Don=ma_hd;
    END IF;
    -- neu phu thu am nghia la SL_Khach du yeu cau va ko can tinh phu thu
    IF(phu_thu < 0) THEN
		SET phu_thu = 0;
    END IF;
    
    SELECT Don_gia INTO tien_mon_moi FROM Kich_thuoc_nuoc_uong 
    WHERE Ma_nuoc_uong = NEW.Ma_nuoc_uong AND Size = NEW.Size;
    SELECT tien_mon_moi*NEW.So_Luong INTO so_tien;
    SELECT Da_Thanh_Toan INTO thanh_toan FROM Hoa_Don WHERE Ma_Hoa_Don = ma_hd;

    IF (thanh_toan=1) THEN
        UPDATE Hoa_Don
        SET Tong_Tien = Tong_Tien + so_tien + phu_thu
        WHERE Ma_Hoa_Don = ma_hd;
    END IF;
END$$
DELIMITER ;

-- ===================triggrt cho delete===============
drop trigger if exists delete_tong_tien_nuoc_uong;
DELIMITER $$
CREATE TRIGGER delete_tong_tien_nuoc_uong
BEFORE DELETE ON Hoa_don_gom_nuoc_uong
FOR EACH ROW
BEGIN
    DECLARE ma_hd VARCHAR(16);
    DECLARE thanh_toan BIT;
    DECLARE so_tien DECIMAL;
    DECLARE tien_mon_cu DECIMAL;
    
    SELECT Don_gia INTO tien_mon_cu FROM Kich_thuoc_nuoc_uong 
    WHERE Ma_nuoc_uong = OLD.Ma_nuoc_uong AND Size = OLD.Size;
    SELECT tien_mon_cu*OLD.So_Luong INTO so_tien;
    SELECT Da_Thanh_Toan INTO thanh_toan FROM Hoa_Don WHERE Ma_Hoa_Don = ma_hd;

    IF (thanh_toan=1) THEN
        UPDATE Hoa_Don
        SET Tong_Tien = Tong_Tien - so_tien
        WHERE Ma_Hoa_Don = ma_hd;
    END IF;
END$$
DELIMITER ;
-- ======test khi update =============
update Hoa_Don
set Hoa_Don.Da_Thanh_Toan = 1 AND Hoa_Don.Gio_Ra = '23:20'
where Ma_Hoa_Don = 'HD01012021000008' ;

-- test khi update ban
update Hoa_don_gom_do_an
set So_Luong = 3
where Ma_Hoa_Don = 'HD01012021000009';
-- AND Ma_Do_An = 'F1002'

select SL_Mon from Hoa_Don  where Ma_Hoa_Don= 'HD01012021000004';
select * from Hoa_Don  where Ma_Hoa_Don= 'HD01012021000008';
select Diem from Khach_Hang  where CMND_CCCD= '456789012345';
select * from Ban_hoa_don;
select * from Phong_vip_hoa_don;
select * from Phong_vip;
select * from Hoa_don;
select * from Khach_Hang;
select * from Hoa_don_gom_do_an;
select * from Hoa_don_gom_nuoc_uong;
select * from Do_An;
select * from Kich_thuoc_nuoc_uong;
