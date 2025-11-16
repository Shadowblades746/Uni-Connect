INSERT INTO Users (id, user_status, bio, email, first_names, last_name, gender, year_group, date_of_birth, password, setup_complete, mentee_capacity)
VALUES (1234, "mentee","mentee bio example", "mentee1@example.com", "Mentee1", "Mentee1LastName", "female", 1, "2000-01-01","K+uvDPQKRjwr1V4yIH74kp6PljupRS/KU1GbTiFqvfkubIoI0jMIuLnYQYQB+/qN", 1, 0);

INSERT INTO Users (id, user_status, email, first_names, last_name, gender, date_of_birth, password, bio)
VALUES (2345, "mentor", "mentor1@example.com", "Mentor1", "Mentor1LastName", "male", "2000-01-02", "0+A3c1dToKGtnTUES+CWn5hUO16X2s0LQAu/cCLrmwq0IgRSTVKQCuPo8FaPMRIu", "Mentor Test Bio");

INSERT INTO Admins (id, email, first_names, last_name, password)
VALUES (1, "admin1@example.com", "Admin1", "Admin1LastName", "tirUS0SHCeyaxrWzZf83Jt0NlGh7jzjBhFuDMuqhogCpvkX0KYrymdIgU883AO/e");

INSERT INTO Notifications(id, text, date, time, notification_read)
VALUES (1234, "Welcome to UniConnect Mentee1!", "2000-01-01", "12:00", 0);

INSERT INTO Notifications(id, text, date, time, notification_read)
VALUES (2345, "Welcome to UniConnect Mentor1!", "2000-01-02", "13:00", 0);

INSERT INTO GlobalSettings(global_settings_id, global_max_mentee_capacity)
VALUES (1, 10);
