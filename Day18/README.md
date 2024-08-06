# Project 01

## Problem Statement
You are tasked with deploying a three-tier web application (frontend, backend, and database) using Ansible roles. The frontend is an Nginx web server, the backend is a Node.js application, and the database is a MySQL server. Your solution should use Ansible Galaxy roles where applicable and define appropriate role dependencies. The deployment should be automated to ensure that all components are configured correctly and can communicate with each other.

## Steps and Deliverables

### 1. Define Project Structure

* Create a new Ansible project with a suitable directory structure to organize roles, playbooks, and inventory files.

```
ssh -i ansible-worker.pem ubuntu@3.145.1.63
```

![alt text](<Screenshot from 2024-08-05 16-55-15.png>)


```ini
target04 ansible_host=3.145.1.63 ansible_user=ubuntu ansible_ssh_private_key_file=/home/einfochips/training/Day18/ansible-worker.pem
```

![alt text](<Screenshot from 2024-08-05 17-24-04.png>)


```
ansible -i inventory.ini -m ping target04
```

![alt text](<Screenshot from 2024-08-05 17-34-40.png>)



### 2. Role Selection and Creation

Select appropriate roles from Ansible Galaxy for each tier of the application:

* Nginx for the frontend.

```
ansible-galaxy init frontend
```


![alt text](<Screenshot from 2024-08-05 17-22-57.png>)

    
* Node.js for the backend.

```
ansible-galaxy init backend
```

* MySQL for the database.

```
ansible-galaxy init database
```

![alt text](<Screenshot from 2024-08-05 17-23-29.png>)



Create any custom roles needed for specific configurations that are not covered by the Galaxy roles.

### 3. Dependencies Management

* Define dependencies for each role in the meta/main.yml file.
* Ensure that the roles have appropriate dependencies, such as ensuring the database is set up before deploying the backend.

```yaml
galaxy_info:
  author: Arsh Shaikh
  description: day 18 task
  company: your company (optional)
```
![alt text](<Screenshot from 2024-08-06 18-39-30.png>)

### 4. Inventory Configuration

* Create an inventory file that defines the groups of hosts for each tier (frontend, backend, database).
* Ensure proper group definitions and host variables as needed.

```ini
[frontend]
target05 ansible_host=3.142.12.135 ansible_user=ubuntu ansible_ssh_private_key_file=/home/einfochips/Documents/ansible-worker.pem

[backend]
target05 ansible_host=3.142.12.135 ansible_user=ubuntu ansible_ssh_private_key_file=/home/einfochips/Documents/ansible-worker.pem

[databse]
target05 ansible_host=3.142.12.135 ansible_user=ubuntu ansible_ssh_private_key_file=/home/einfochips/Documents/ansible-worker.pem
```

![alt text](<Screenshot from 2024-08-06 18-42-42.png>)

### 5. Playbook Creation
* Create a playbook (deploy.yml) that includes and orchestrates the roles for deploying the application.
* Ensure the playbook handles the deployment order and variable passing between roles.

```yml
---
- name: Full Stack Application
  hosts: all
  become: yes
  tasks:
    - name: update_cache
      apt:
        update_cache: yes

- hosts: database
  become: true
  roles: 
    - database

- hosts: backend
  become: true
  roles: 
    - backend

- hosts: frontend
  become: true
  roles: 
    - frontend
```

![alt text](<Screenshot from 2024-08-06 18-46-58.png>)


### 6. Role Customization and Variable Definition
* Customize the roles by defining the necessary variables in group_vars or host_vars as needed for the environment.
* Ensure sensitive data like database credentials are managed securely.

## First for Frontend role

* first in the file folder

```html
<html>
    <head>
        <title>The Day 18 Task</title>
    </head>
    <body>
        <center>
            <h1>Hey there, its the Frontend Page!</h1>
        </center>
    </body>
</html>
```

* then in the tasks/main.yml

```yml
---
- name: Installing Nginx
  apt:
    name: nginx
    state: present
    update_cache: yes

- name: Start/Enable Nginx
  systemd:
    name: nginx
    state: started
    enabled: yes

- name: Configure Nginx
  template:
    src: index.html.j2
    dest: /var/www/html/index.html
  notify: Restart Nginx

- name: Ensure Nginx is running
  service:
    name: nginx
    state: started
    enabled: yes
```

* Then in handler/main.yml

```yml
---
- name: Restart Nginx
  systemd:
    name: nginx
    state: restarted
```

* Then for the templates/index.html.j2

```j2
<html>
    <head>
        <title>Day-18-Task</title>
    </head>
    <body>
        <center>
            <h1>Frontend Page</h1>
        </center>
    </body>
</html>

```

## For the database(Mysql)

* In tasks/main.yml

```yml
---
- name: Installing Mysql
  package:
      name: "{{item}}"
      state: present
      update_cache: yes
  loop:
    - mysql-server
    - mysql-client
    - python3-mysqldb
    - libmysqlclient-dev
    
- name: Enabling MySQL service
  service:
      name: mysql
      state: started
      enabled: yes

- name: Setting up user-password
  mysql_user:
    name: root
    password: "{{root_password}}"
    login_unix_socket: /var/run/mysqld/mysqld.sock
    host: localhost
    login_user: root
    login_password: ''
    state: present

- name: Creating admin user (remote access)
  mysql_user:
    name: "{{admin_user}}"
    password: "{{admin_password}}"
    priv: '*.*:ALL'
    host: '%'
    append_privs: yes
    login_user: root
    login_password: "{{root_password}}"
    state: present

- name: Creating Database 
  mysql_db:
    name: "{{db_name}}"
    state: present
    login_user: root
    login_password: "{{root_password}}"

- name: Enabling remote login to mysql
  lineinfile:
    path: /etc/mysql/mysql.conf.d/mysqld.cnf
    regex: '^bind-address\s*=\s*127.0.0.1'
    line: 'bind-address = 0.0.0.0'
    backup: yes
  notify:
    - Restart mysql

- name: Execute MySQL secure installation
  expect:
    command: mysql_secure_installation
    responses:
      'Enter password for user root:': "{{ root_password }}"
      'Press y\|Y for Yes, any other key for No': 'Y'
      'Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG': "{{ password_validation_policy }}"
      'Change the password for root \? \(\(Press y\|Y for Yes, any other key for No\)': 'n'
      'Remove anonymous users\? \(Press y\|Y for Yes, any other key for No\)': 'Y'
      'Disallow root login remotely\? \(Press y\|Y for Yes, any other key for No\)': 'Y'
      'Remove test database and access to it\? \(Press y\|Y for Yes, any other key for No\)': 'Y'
      'Reload privilege tables now\? \(Press y\|Y for Yes, any other key for No\)': 'Y'
  environment:
    MYSQL_PWD: "{{ root_password }}"
```

* then in vars/main.yml for passing credentials we will modify with our requiremetns

## For the Backend (nodejs)

* In tasks/main.yml

```yml
---
  - name: Installing Ca-certificates
    apt:
      name: ca-certificates
      state: present
      update_cache: yes

  - name: Download NodeSource GPG key
    shell: |
      curl -o /tmp/nodesource.gpg.key https://deb.nodesource.com/gpgkey/nodesource.gpg.key
    args:
      warn: false

  - name: Add the NodeSource GPG key
    apt_key:
      file: "/tmp/nodesource.gpg.key"
      state: present

  - name: Install Node.js LTS repository
    apt_repository:
      repo: "deb https://deb.nodesource.com/node_{{ NODEJS_VERSION }}.x {{ ansible_distribution_release }} main"
      state: present
      update_cache: yes

  - name: Install Node.js and npm
    apt:
      name: 
        - nodejs
        - npm
      state: present
```

* In vars/main.yml

```yml
---
NODEJS_VERSION: "16"
ansible_distribution_release: "focal"
```

## Final Output

![alt text](<Screenshot from 2024-08-06 18-28-06.png>)

![alt text](<Screenshot from 2024-08-06 18-35-44.png>)
















