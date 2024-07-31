Project 1: Deploying Ansible

Key File: https://drive.google.com/file/d/17Qw7j-A6wlmF3ra0CjqHgJ2vH8fghjh2/view?usp=sharing

Username: ubuntu
Arsh - 18.190.160.189

Click on the key file link and download the ansible-worker.pem

give the permission to it by chmod command

chmod 400 ansible-worker.pem

![alt text](<Screenshot from 2024-07-30 15-57-53.png>)

![alt text](<Screenshot from 2024-07-30 15-58-07.png>)

After giving permission create an inventory file in the same directory 

target01 ansible_host=18.190.160.189 ansible_user=ubuntu ansible_ssh_private_key_file=/home/einfochips/training/Day16/ansible-worker.pem

![alt text](<Screenshot from 2024-07-30 15-58-18.png>)

![alt text](<Screenshot from 2024-07-30 15-58-35.png>)

Deliverables:

Control Node Setup:
Install Ansible on the control node.
Configure SSH key-based authentication between the control node and managed nodes.

Managed Nodes Configuration:
Ensure all managed nodes are properly configured to be controlled by Ansible.
Verify connectivity and proper setup between the control node and managed nodes.

Documentation:
Detailed installation and configuration steps.
Troubleshooting guide for common issues encountered during deployment

ansible all -i inventory -m ping 

![alt text](<Screenshot from 2024-07-30 16-06-53.png>)



Project 2: Ad-Hoc Ansible Commands

Problem Statement: Your organization needs to perform frequent, one-off administrative tasks across a fleet of servers. These tasks include checking disk usage, restarting services, and updating packages. You are required to use Ansible ad-hoc commands to accomplish these tasks efficiently.

Deliverables:
Task Execution:
Execute commands to check disk usage across all managed nodes.

ansible -i inventory -m shell -a "du" all

![alt text](<Screenshot from 2024-07-30 16-31-14.png>)


Restart a specific service on all managed nodes.

ansible -i inventory -m service -b -a "name=nginx state=restarted" all

![alt text](<Screenshot from 2024-07-30 16-39-05.png>)


Update all packages on a subset of managed nodes.

ansible -i inventory -m apt -b -a "update_cache=yes" all

![alt text](<Screenshot from 2024-07-30 16-45-05.png>)



Command Scripts:
Create a script or documentation for each task, detailing the ad-hoc command used and its output.

Documentation:
Provide a comprehensive guide on using Ansible ad-hoc commands.
Include examples of common administrative tasks that can be performed with ad-hoc commands.

Project 3: Working with Ansible Inventories

Problem Statement: You need to manage a dynamic and diverse set of servers, which requires an organized and flexible inventory system. The project involves creating static and dynamic inventories in Ansible to categorize servers based on different attributes such as environment (development, staging, production) and roles (web servers, database servers).

Deliverables:

Static Inventory:
Create a static inventory file with different groups for various environments and roles.
Verify that the inventory is correctly structured and accessible by Ansible.

Dynamic Inventory:
Implement a dynamic inventory script or use a dynamic inventory plugin.
Configure the dynamic inventory to categorize servers automatically based on predefined criteria.

Documentation:
Instructions for setting up and using static and dynamic inventories.

Examples of playbooks utilizing both types of inventories.

ansible all -i inventory -m ping

![alt text](<Screenshot from 2024-07-30 16-06-53-1.png>)


Project 4: Ansible Playbooks: The Basics

Problem Statement: Your team needs to automate repetitive tasks such as installing packages, configuring services, and managing files on multiple servers. The project involves writing basic Ansible playbooks to automate these tasks, ensuring consistency and efficiency in the operations.

Deliverables:

Playbook Creation:
Write a playbook to install a specific package on all managed nodes.

Create a playbook to configure a service with specific parameters.
Develop a playbook to manage files, such as creating, deleting, and modifying files on managed nodes.

Testing and Verification:
Test the playbooks to ensure they run successfully and perform the intended tasks.
Validate the changes made by the playbooks on the managed nodes.

Documentation:
Detailed explanation of each playbook, including the tasks and modules used.
Guide on how to run the playbooks and interpret the results.

ansible-playbook -i inventory playbook.yaml

![alt text](<Screenshot from 2024-07-30 17-26-34.png>)



Project 5: Ansible Playbooks - Error Handling

Problem Statement: In a complex IT environment, tasks automated by Ansible playbooks may encounter errors due to various reasons such as incorrect configurations, unavailable resources, or network issues. The project focuses on implementing error handling in Ansible playbooks to ensure resilience and proper reporting of issues.

Deliverables:

Playbook with Error Handling:
Write a playbook that includes tasks likely to fail, such as starting a non-existent service or accessing a non-existent file.
Implement error handling strategies using modules like block, rescue, and always.

Logging and Notifications:
Configure the playbook to log errors and notify administrators of any issues encountered during execution.
Use Ansible modules to send notifications via email or other communication channels.

Documentation:
Comprehensive guide on error handling in Ansible playbooks, including examples of common scenarios and solutions.
Detailed instructions on setting up logging and notifications for error handling.

ansible-playbook -i inventory block_rescue.yaml -b

![alt text](<Screenshot from 2024-07-30 19-11-48.png>) 








