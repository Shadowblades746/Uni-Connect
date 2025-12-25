# UniConnect - COM1001 Team Project (Team 18)

## Overview
**UniConnect** is a web application designed to connect university students with mentors. It allows second-year and above students to register as mentors, while first-year students are mentees.

### Key Features
- **Mentee Application**: First-year students can apply for mentorship with available mentors, providing a bio and personal information for mentors to review.  
- **Profile Management**: Both mentors and mentees can manage their personal profiles, including their bio, profile picture, and other details.  
- **Mentor Approval**: Mentors can accept or deny mentee requests. Once matched, they can view each other's profiles and communicate.  
- **Admin Controls**: Admin users have full control of the platform, including approving or rejecting mentor-mentee matches, setting global limits on the number of mentees per mentor, managing user roles, and deleting or flagging users.  
- **Notifications & Requests**: Users receive notifications for new mentor-mentee requests, profile updates, and other system activities.  

The platform simplifies the mentor-mentee relationship by making it easy for students to connect, apply, and manage their profiles, while admins ensure smooth operation.

## Demo & Test Users

### Demo Video
[Watch the demo video showcasing the project](https://www.youtube.com/watch?v=hFcsrr2PXi8)

### Test Users
**Admin**  
- Email: `admin1@example.com`  
- Password: `admin1`

**Mentor**  
- Email: `mentor1@example.com`  
- Password: `mentor1`

**Mentee**  
- Email: `mentee1@example.com`  
- Password: `mentee1`

## Requirements
- **Ruby version:** 2.7 or higher  
- The project includes a `Gemfile` listing all required gems.

```bash
bundle install
```

## My Contributions 
As part of the team, I contributed the following features and improvements:  

### Student Functionality
- Implemented **student sign-up page** with functionality to add users to the database and error checking for duplicate accounts.  
- Added **password hashing** to secure password storage.  
- Implemented **student log-in page** allowing users to log in and stay logged in using the session token implemented by Lizzie.  
- Designed and applied **CSS for student log-in and sign-up pages**.  
- Added a **default profile picture** for users who don’t upload one.  

### Admin Functionality
- Implemented **admin sign-up request page** for new admins, sending notifications to current admins.  
- Implemented **admin sign-in page** and **change password page** for newly created admins.  
- Designed and implemented **admin dashboard page** with CSS styling.  
- Enabled **flagging users** with reason validation and a flagged users panel, including the ability to unflag users.  
- Implemented **user deletion**, **global mentee limit changes**, and **adding experienced mentor badges** from the admin dashboard.  
- Implemented **reassigning mentees to different mentors** with validation.  
- Enabled **creation of admin accounts** from the admin dashboard.  
- Implemented **activity logs and notifications** for all relevant actions.  

This repository demonstrates my contributions in both **frontend styling** and **backend functionality**, showcasing skills in **Ruby, web development, database integration, user authentication, session management, and admin tools**.
