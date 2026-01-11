-- 1. Tabel User
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nama_lengkap VARCHAR(100),
    username VARCHAR(50) UNIQUE,
    password VARCHAR(255)

);
CREATE TABLE admin (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nama_lengkap VARCHAR(100),
    username VARCHAR(50) UNIQUE,
    password VARCHAR(255),

);

CREATE TABLE ternak (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_ternak VARCHAR(50) NOT NULL
);

INSERT INTO ternak (nama_ternak) VALUES
('Sapi'),
('Kambing'),
('Domba'),
('Ayam'),
('Bebek');

-- =========================================
-- TABEL GEJALA
-- =========================================
CREATE TABLE gejala (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kode_gejala VARCHAR(10) UNIQUE,
    nama_gejala VARCHAR(200)
);

INSERT INTO gejala (kode_gejala, nama_gejala) VALUES
('G01','Demam tinggi'),
('G02','Nafsu makan menurun'),
('G03','Lesu dan lemah'),
('G04','Diare'),
('G05','Batuk'),
('G06','Sesak nafas'),
('G07','Keluar cairan dari hidung'),
('G08','Kematian mendadak'),
('G09','Luka pada kulit'),
('G10','Bulu rontok'),
('G11','Pembengkakan ambing'),
('G12','Kelumpuhan'),
('G13','Penurunan berat badan'),
('G14','Telur menurun'),
('G15','Telur abnormal'),
('G16','Pendarahan'),
('G17','Mulut berbusa'),
('G18','Gatal berlebihan'),
('G19','Keguguran'),
('G20','Bau tidak sedap dari mulut');

-- =========================================
-- TABEL PENYAKIT
-- =========================================
CREATE TABLE penyakit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ternak_id INT,
    kode_penyakit VARCHAR(10),
    nama_penyakit VARCHAR(150),
    deskripsi TEXT,
    solusi TEXT,
    FOREIGN KEY (ternak_id) REFERENCES ternak(id)
);

INSERT INTO penyakit (ternak_id, kode_penyakit, nama_penyakit, deskripsi, solusi) VALUES
-- SAPI
(1,'P01','Antraks','Penyakit menular akut disebabkan bakteri Bacillus anthracis','Isolasi ternak dan vaksinasi'),
(1,'P02','Brucellosis','Penyakit reproduksi menyebabkan keguguran','Eliminasi dan sanitasi'),
(1,'P03','PMK','Penyakit mulut dan kuku akibat virus','Vaksinasi dan karantina'),
(1,'P04','Mastitis','Infeksi pada ambing sapi','Pengobatan antibiotik'),

-- KAMBING
(2,'P05','Scabies','Penyakit kulit akibat tungau','Mandikan obat antiparasit'),
(2,'P06','Enterotoxemia','Gangguan pencernaan akut','Vaksinasi dan pakan seimbang'),

-- DOMBA
(3,'P07','Orf','Infeksi virus pada mulut dan kaki','Isolasi dan antiseptik'),
(3,'P08','Cacingan','Infeksi parasit cacing','Pemberian obat cacing'),

-- AYAM
(4,'P09','Flu Burung','Penyakit virus mematikan','Pemusnahan dan biosekuriti'),
(4,'P10','Tetelo','Newcastle Disease','Vaksinasi rutin'),
(4,'P11','Snot','Penyakit pernapasan ayam','Antibiotik'),

-- BEBEK
(5,'P12','Kolera Bebek','Penyakit bakteri menular','Antibiotik dan sanitasi'),
(5,'P13','Botulisme','Keracunan pakan','Ganti pakan dan air');

-- =========================================
-- TABEL RELASI PENYAKIT - GEJALA
-- =========================================
CREATE TABLE penyakit_gejala (
    id INT AUTO_INCREMENT PRIMARY KEY,
    penyakit_id INT,
    gejala_id INT,
    bobot DECIMAL(3,2),
    FOREIGN KEY (penyakit_id) REFERENCES penyakit(id),
    FOREIGN KEY (gejala_id) REFERENCES gejala(id)
);

INSERT INTO penyakit_gejala (penyakit_id, gejala_id, bobot) VALUES
-- ANTRAKS
(1,1,0.9),(1,8,1.0),(1,16,0.8),

-- BRUCELLOSIS
(2,2,0.7),(2,19,0.9),(2,13,0.6),

-- PMK
(3,17,0.9),(3,12,0.7),(3,1,0.6),

-- MASTITIS
(4,11,0.9),(4,1,0.5),(4,3,0.6),

-- SCABIES
(5,9,0.8),(5,10,0.7),(5,18,0.9),

-- ENTEROTOXEMIA
(6,4,0.9),(6,8,0.8),(6,3,0.7),

-- ORF
(7,9,0.7),(7,17,0.8),

-- CACINGAN
(8,13,0.8),(8,4,0.6),(8,2,0.7),

-- FLU BURUNG
(9,6,0.9),(9,8,1.0),(9,5,0.8),

-- TETELO
(10,6,0.8),(10,12,0.9),(10,14,0.6),

-- SNOT
(11,5,0.8),(11,7,0.9),

-- KOLERA BEBEK
(12,1,0.7),(12,8,0.9),

-- BOTULISME
(13,12,1.0),(13,3,0.7);

-- =========================================
-- TABEL RIWAYAT DIAGNOSA (OPSIONAL)
-- =========================================
CREATE TABLE diagnosa (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tanggal DATETIME DEFAULT CURRENT_TIMESTAMP,
    ternak_id INT,
    hasil_penyakit VARCHAR(150),
    tingkat_keyakinan DECIMAL(5,2),
    FOREIGN KEY (ternak_id) REFERENCES ternak(id)
);