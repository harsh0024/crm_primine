const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt');

const app = express();
const port = 3000;

app.use(bodyParser.json());

// MySQL connection
const db = mysql.createConnection({
    host: 'localhost',
    user: 'mansi',
    password: 'mansi',
    database: 'primine_crm'
});

db.connect((err) => {
    if (err) {
        throw err;
    }
    console.log('MySQL connected...');
});

// Register route
app.post('/register', async (req, res) => {
    const { firstName, lastName, email, contactNumber, password } = req.body;

    try {
        const hashedPassword = await bcrypt.hash(password, 10);
        const user = { first_name: firstName, last_name: lastName, email, contact_number: contactNumber, password: hashedPassword };

        const sql = 'INSERT INTO users SET ?';
        db.query(sql, user, (err, result) => {
            if (err) {
                return res.status(500).json({ error: 'Registration failed' });
            }
            res.status(200).json({ message: 'Registration successful' });
        });
    } catch (error) {
        res.status(500).json({ error: 'Server error' });
    }
});

// Login route
app.post('/login', (req, res) => {
    const { email, password } = req.body;

    const sql = 'SELECT * FROM users WHERE email = ?';
    db.query(sql, [email], async (err, results) => {
        if (err || results.length === 0) {
            return res.status(401).json({ error: 'Invalid email or password' });
        }

        const user = results[0];

        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(401).json({ error: 'Invalid email or password' });
        }

        res.status(200).json({ message: 'Login successful' });
    });
});

app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});
