USE demo;
CREATE TABLE IF NOT EXISTS feature_flags (
    id INT AUTO_INCREMENT PRIMARY KEY,
    flag VARCHAR(255) NOT NULL,
    last_changed_date DATE,
    value VARCHAR(255),
    value_int INT
)  ENGINE=INNODB;