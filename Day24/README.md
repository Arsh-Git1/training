# Project

## Comprehensive AWS S3 Management and Static Website Hosting

### Objective:

To test your knowledge and skills in managing AWS S3 storage classes, lifecycle management, bucket policies, access control lists (ACLs), and hosting a static website on S3. You will apply their understanding in a practical scenario, ensuring you have mastered the critical aspects of AWS S3.


### Project Scenario:

You are tasked with creating and managing an S3 bucket for a fictional company, "TechVista Inc.," that hosts a static website for displaying their product portfolio. The website will have different types of content, including high-resolution images, which require careful storage management to optimize costs. Additionally, the company has strict security requirements for accessing the content.

## Project Steps and Deliverables:

### 1. Create and Configure an S3 Bucket:

* Create an S3 bucket named techvista-portfolio-[your-initials].
Enable versioning on the bucket.

### Output

![alt text](<images/Screenshot from 2024-08-13 15-29-49.png>)

![alt text](<images/Screenshot from 2024-08-13 15-28-41.png>)

![alt text](<images/Screenshot from 2024-08-13 15-28-48.png>)

![alt text](<images/Screenshot from 2024-08-13 16-20-49.png>)

* Set up the bucket for static website hosting.

![alt text](<images/Screenshot from 2024-08-13 16-22-31.png>)


* Upload the provided static website files (HTML, CSS, images).

![alt text](<images/Screenshot from 2024-08-13 17-20-02.png>)

* Ensure the website is accessible via the S3 website URL.

![alt text](<images/Screenshot from 2024-08-13 17-21-03.png>)

![alt text](<images/Screenshot from 2024-08-13 16-08-20.png>)

### 2. Implement S3 Storage Classes:

* Classify the uploaded content into different S3 storage classes (e.g., Standard, Intelligent-Tiering, Glacier).

* Justify your choice of storage class for each type of content (e.g., HTML/CSS files vs. images).

![alt text](<images/Screenshot from 2024-08-13 16-13-02.png>)

![alt text](<images/Screenshot from 2024-08-13 17-20-02.png>)



### 3. Lifecycle Management:

* Create a lifecycle policy that transitions older versions of objects to a more cost-effective storage class (e.g., Standard to Glacier).

![alt text](<images/Screenshot from 2024-08-13 16-27-16.png>)

![alt text](<images/Screenshot from 2024-08-13 16-27-05.png>)

* Set up a policy to delete non-current versions of objects after 90 days.

![alt text](<images/Screenshot from 2024-08-13 16-27-32.png>)


* Verify that the lifecycle rules are correctly applied.

![alt text](<images/Screenshot from 2024-08-13 16-27-39.png>)

### 4. Configure Bucket Policies and ACLs:

* Create and attach a bucket policy that allows read access to everyone for the static website content.

* Restrict access to the S3 management console for specific IAM users using the bucket policy.

![alt text](<images/Screenshot from 2024-08-13 16-31-25.png>)


### 5. Test and Validate the Configuration:

* Test the static website URL to ensure it is accessible.


    - https://techvista-portfolio-arsh.s3.ap-southeast-2.amazonaws.com/index.html


![alt text](<images/Screenshot from 2024-08-13 16-08-20.png>)