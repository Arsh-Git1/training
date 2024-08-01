# Project 01

## Deploy a Database Server with Backup Automation

### Objective: 
Automate the deployment and configuration of a PostgreSQL database server on an Ubuntu instance hosted on AWS, and set up regular backups.

## Problem Statement

### Objective: 
Automate the deployment, configuration, and backup of a PostgreSQL database server on an Ubuntu instance using Ansible.

### Requirements:
#### AWS Ubuntu Instance: 
You have an Ubuntu server instance running on AWS.

#### Database Server Deployment: 
Deploy and configure PostgreSQL on the Ubuntu instance.

#### Database Initialization: 
Create a database and a user with specific permissions.
Backup Automation: Set up a cron job for regular database backups and ensure that backups are stored in a specified directory.

#### Configuration Management: 
Use Ansible to handle the deployment and configuration, including managing sensitive data like database passwords.

## Deliverables

### 1. Ansible Inventory File

Filename: inventory.ini

Content: Defines the AWS Ubuntu instance and connection 
details for Ansible.

```ini
[web]
target02 ansible_host=18.190.176.41 ansible_user=ubuntu ansible_ssh_private_key_file=/home/einfochips/training/Day17/ansible-worker.pem
```
![alt text](<Screenshot from 2024-08-01 15-51-42.png>)

### 2. Ansible Playbook

Filename: deploy_database.yml

Content: Automates the installation of PostgreSQL, sets up the database, creates a user, and configures a cron job for backups. It also includes variables for database configuration and backup settings.
Jinja2 Template

```yml
- name: setup Mysql on target machine
  hosts: web
  become: yes
  vars:
   db_name: "my_database"
   db_user: "my_user"
   db_password: "user123" 
   backup_dir: "/backup/mysql"
   backup_schedule: "daily"

  tasks:
  - name: Install MySQL server
    apt:
      update_cache: yes
      name: "{{ item }}"
      state: present
    with_items:
    - mysql-server
    - mysql-client
    - python3-mysqldb
    - libmysqlclient-dev

  - name: Copy MySQL configuration file
    template:
      src: /home/einfochips/training/Day17/templates/mysql.config.j2
      dest: /etc/mysql/mysql.conf.d/mysqld.cnfx

  - name: start and enable mysql service
    service:
      name: mysql
      state: started
      enabled: yes

  - name: Create MySQL user
    mysql_user:
      name: "{{ db_user }}"
      password: "{{ db_password }}"
      priv: '*.*:ALL'
      host: '%'
      state: present

  - name: Create MySQL database
    mysql_db:
      name: "{{ db_name }}"
      state: present
  
  - name: Configure backup directory
    file:
      path: "{{ backup_dir }}"
      state: directory
      mode: '0755'

  - name: Copy MySQL backup script
    copy:
      src: /home/einfochips/training/Day17/scripts/backup.sh
      dest: /usr/local/bin/mysql_backup.sh
      mode: '0755'

  - name: Configure backup cron job
    cron:
      name: "mysql backup"
      minute: "0"
      hour: "2"
      day: "*"
      month: "*"
      weekday: "*"
      job: "/usr/local/bin/mysql_backup.sh"
      state: present

  handlers:
  - name: Restart mysql
    service:
      name: mysql
      state: restarted
 
```

### 3. Jinja2 Template

Filename: templates/mysql.config.j2

Content: Defines the PostgreSQL configuration file (pg_hba.conf) using Jinja2 templates to manage access controls dynamically.
Backup Script

```j2
# Here is entries for some specific programs
# The following values assume you have at least 32M ram

!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mysql.conf.d/
 
```

### 4. Backup Script

Filename: scripts/backup.sh

Content: A script to perform the backup of the PostgreSQL database. This script should be referenced in the cron job defined in the playbook.

```sh
#!/bin/bash

# Set variables
DATABASE_NAME=mydatabase
BACKUP_DIR=/var/backups/mysql
DATE=$(date +"%Y-%m-%d")

# Create backup file name
BACKUP_FILE="${BACKUP_DIR}/${DATABASE_NAME}_${DATE}.sql"

# Dump database to backup file
mysqldump -u myuser -p${database_password} ${DATABASE_NAME} > ${BACKUP_FILE}

# Compress backup file
gzip ${BACKUP_FILE}

# Remove old backups (keep only 7 days)
find ${BACKUP_DIR} -type f -mtime +7 -delete

```

![alt text](<Screenshot from 2024-08-01 16-19-16.png>)


# Project 02

### Objective: 
Automate the setup of a multi-tier web application stack with separate database and application servers using Ansible.
Problem Statement

### Objective: 
#### Automate the deployment and configuration of a multi-tier web application stack consisting of:

#### Database Server: 
Set up a PostgreSQL database server on one Ubuntu instance.

#### Application Server: 
Set up a web server (e.g., Apache or Nginx) on another Ubuntu instance to host a web application.

#### Application Deployment: 
Ensure the web application is deployed on the application server and is configured to connect to the PostgreSQL database on the database server.

#### Configuration Management: 
Use Ansible to automate the configuration of both servers, including the initialization of the database and the deployment of the web application.

## Deliverables

### 1. Ansible Inventory File

Filename: inventory.ini
Content: Defines the database server and application server instances, including their IP addresses and connection details.

```ini
[db]
target04 ansible_host=52.66.130.19 ansible_user=ubuntu ansible_ssh_private_key_file=/home/einfochips/training/Day17/project2/harsh.pem

[app]
target02 ansible_host=18.190.176.41 ansible_user=ubuntu ansible_ssh_private_key_file=/home/einfochips/training/Day17/ansible-worker.pem
```

![alt text](<Screenshot from 2024-08-01 17-27-50.png>)

### 2. Ansible Playbook

Filename: deploy_multitier_stack.yml

Content: 

Automates:
The deployment and configuration of the PostgreSQL database server.
The setup and configuration of the web server.
The deployment of the web application and its configuration to connect to the database.

```yml
- name: Deploy and configure MySQL database
  hosts: db
  become: yes
  vars:
    db_name: "my_database"
    db_user: "my_user"
    db_password: "user123"

  tasks:
  - name: Install MySQL server
    apt:
      update_cache: yes
      name: "{{ item }}"
      state: present
    with_items:
    - mysql-server
    - mysql-client
    - python3-mysqldb
    - libmysqlclient-dev

  - name: Ensure MySQL service is running
    service:
      name: mysql
      state: started
      enabled: yes

  - name: Create MySQL user
    mysql_user:
      name: "{{ db_user }}"
      password: "{{ db_password }}"
      priv: '*.*:ALL'
      host: '%'
      state: present

  - name: Create MySQL database
    mysql_db:
      name: "{{ db_name }}"
      state: present

- name: Deploy and configure web server and application
  hosts: app
  become: yes

  vars:
    db_host: "host_ip"
    db_name: "my_database"
    db_user: "my_user"
    db_password: "user123"

  tasks:
  - name: Install web server
    apt:
      name: nginx
      state: present
      update_cache: yes

  - name: Ensure web server is running
    service:
      name: nginx
      state: started
      enabled: yes

  - name: Deploy application files
    copy:
      src: files/index.html
      dest: /var/www/html/index.html

  - name: Configure application
    template:
      src: templates/app_config.php.j2
      dest: /var/www/html/app_config.php

  - name: Restart web server to apply changes
    service:
      name: nginx
      state: restarted
```

### 3. Jinja2 Template

Filename: templates/app_config.php.j2

Content: Defines a configuration file for the web application that includes placeholders for dynamic values such as database connection details.

```j2
<?php
$servername = "{{ db_host }}";
$username = "{{ db_user }}";
$password = "{{ db_password }}";
$dbname = "{{ db_name }}";

// Create connection

$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
echo "Connected successfully";
?>
```
![alt text](<Screenshot from 2024-08-01 17-40-51-1.png>)

### 4. Application Files

Filename: files/index.html (or equivalent application files)
Content: Static or basic dynamic content served by the web application.

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>THE WEB APPLICATION</title>
</head>
<body>
    <h1>Welcome to the Web Application</h1>
    <p>The current working application is connected to a MySQL database.</p>
</body>
</html>
```

![alt text](<Screenshot from 2024-08-01 17-40-30.png>)








