CREATE TABLE Users (
    id INTEGER PRIMARY KEY,
    user_status TEXT,
    badge INTEGER,
    flagged INTEGER ,
    flagged_reason TEXT,
    bio TEXT,
    email TEXT,
    first_names TEXT,
    last_name TEXT,
    gender TEXT,
    pronouns TEXT,
    year_group TEXT,
    date_of_birth TEXT,
    profile_picture BLOB,
    password TEXT,
    setup_complete INTEGER,
    mentee_capacity INTEGER DEFAULT 0,
    mentor_availability TEXT,
    session_token TEXT
);

CREATE TABLE Admins (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT,
    first_names TEXT,
    last_name TEXT,
    changed_password INTEGER,
    user_to_reassign INTEGER,
    password TEXT,
    session_token TEXT
);

CREATE TABLE Notifications (
   notification_id INTEGER PRIMARY KEY AUTOINCREMENT,
   id INTEGER,
   text TEXT,
   date TEXT,
   time TEXT,
   notification_read INTEGER,
   FOREIGN KEY (id) REFERENCES Users(id)
);

CREATE TABLE Requests (
    request_id INTEGER PRIMARY KEY AUTOINCREMENT,
    mentor_id INTEGER,
    mentee_id INTEGER,
    application_text TEXT,
    date TEXT,
    time TEXT,
    acceptance_status INTEGER
);

CREATE TABLE UserSettings (
    user_settings_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    bio TEXT,
    first_names TEXT,
    last_name TEXT,
    gender TEXT,
    year_group TEXT,
    date_of_birth TEXT,
    profile_picture BLOB,
    password TEXT,
    mentee_capacity INTEGER,
    mentor_availability TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

CREATE TABLE GlobalSettings (
    global_settings_id INTEGER PRIMARY KEY,
    global_max_mentee_capacity INTEGER DEFAULT 10
);


CREATE TABLE AdminActivity (
    event_id INTEGER PRIMARY KEY AUTOINCREMENT,
    event_text TEXT,
    event_date TEXT,
    event_time TEXT,
    event_viewed INTEGER
);

CREATE TABLE UserWithdrawalRequests (
    withdrawal_id INTEGER PRIMARY KEY AUTOINCREMENT,
    primary_user_id INTEGER,
    secondary_user_id INTEGER,
    reason_from_primary TEXT
)