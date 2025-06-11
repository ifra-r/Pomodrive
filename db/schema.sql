-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL
);

-- Create pomodoro_sessions table
CREATE TABLE IF NOT EXISTS pomodoro_sessions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    session_date DATE DEFAULT (DATE('now')),
    duration_minutes INTEGER NOT NULL,
    completed INTEGER DEFAULT 1,  -- 1 for true
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE todos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    completed TINYINT(1) DEFAULT 0,
    priority INT DEFAULT 2,
    created_date DATETIME,
    completed_date DATETIME,
    INDEX idx_user_id (user_id)
);
