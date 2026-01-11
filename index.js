const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'db_hewan'
});

// Endpoint untuk Registrasi User (Plain Text)
app.post('/api/register', (req, res) => {
    const { nama_lengkap, username, password } = req.body;

    // Validasi input
    if (!nama_lengkap || !username || !password) {
        return res.status(400).json({ 
            status: "error", 
            message: "Semua field harus diisi!" 
        });
    }

    const query = "INSERT INTO users (nama_lengkap, username, password) VALUES (?, ?, ?)";
    
    db.query(query, [nama_lengkap, username, password], (err, result) => {
        if (err) {
            // Cek jika username sudah ada (karena kolom username adalah UNIQUE)
            if (err.code === 'ER_DUP_ENTRY') {
                return res.status(400).json({ 
                    status: "error", 
                    message: "Username sudah digunakan, cari yang lain!" 
                });
            }
            return res.status(500).json({ status: "error", message: err.message });
        }
        
        res.status(201).json({ 
            status: "success", 
            message: "User berhasil terdaftar!",
            id: result.insertId 
        });
    });
});

// Endpoint Login
app.post('/api/login', (req, res) => {
    const { username, password } = req.body;
    const query = "SELECT * FROM users WHERE username = ? AND password = ?";
    
    db.query(query, [username, password], (err, results) => {
        if (results.length > 0) {
            res.json({ status: "success", message: "Login Berhasil" });
        } else {
            res.json({ status: "failed", message: "Username/Password Salah" });
        }
    });
});

app.post('/api/login/admin', (req, res) => {
    const { username, password } = req.body;
    const query = "SELECT * FROM admin WHERE username = ? AND password = ?";
    
    db.query(query, [username, password], (err, results) => {
        if (results.length > 0) {
            res.json({ status: "success", message: "Login Berhasil" });
        } else {
            res.json({ status: "failed", message: "Username/Password Salah" });
        }
    });
});

app.get('/api/ternak', (req, res) => {
    db.query('SELECT * FROM ternak', (err, result) => {
        if (err) return res.status(500).json(err);
        res.json(result);
    });
});

app.get('/api/gejala', (req, res) => {
    db.query('SELECT * FROM gejala', (err, result) => {
        if (err) return res.status(500).json(err);
        res.json(result);
    });
});

app.post('/api/diagnosa', (req, res) => {
    const gejala = req.body.gejala.join(',');

    // Menambahkan p.deskripsi dan p.solusi ke dalam SELECT dan GROUP BY
    const sql = `
        SELECT 
            p.nama_penyakit, 
            p.deskripsi, 
            p.solusi, 
            SUM(pg.bobot) AS skor
        FROM penyakit p
        JOIN penyakit_gejala pg ON p.id = pg.penyakit_id
        WHERE pg.gejala_id IN (${gejala})
        GROUP BY p.id, p.nama_penyakit, p.deskripsi, p.solusi
        ORDER BY skor DESC
        LIMIT 1
    `;

    db.query(sql, (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).json({ error: "Terjadi kesalahan pada server." });
        }
        
        if (result.length > 0) {
            res.json(result[0]);
        } else {
            res.status(404).json({ message: "Penyakit tidak ditemukan berdasarkan gejala tersebut." });
        }
    });
});



app.listen(3000, () => console.log('Server running on port 3000'));