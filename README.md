# Automation_Project
- Automate creation of Apache server
    - if Apache server already not installed it
    - if EC2 instance restarts then Apache also restarts
- Archive access.log and error.log of Apache server to /tmp dir
- Copy the tar file to S3 location (${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar)

