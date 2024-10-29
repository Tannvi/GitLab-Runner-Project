# GitLab-Runner-Project


To set up a GitLab Group Runner on a GitLab Cloud Premium account and configure it on AWS, we'll be following the steps described below:

Step 1: Prerequisites

GitLab Premium Account: Take a GitLab Premium subscription and admin access to the group where the runner will be registered.
AWS EC2 Instance: Create an AWS EC2 instance to act as the GitLab Runner.
GitLab Runner: Familiarize ourself with GitLab Runner, which is a build instance (Docker, VM, etc.) that GitLab CI/CD uses to run jobs.

Using Amazon Linux 2023 ARM64 AMI 
The yum package manager is used instead of apt-get (as Amazon Linux uses yum by default).
Downloading and installing the ARM64 version of GitLab Runner.

Step 3: Configure the Group Runner
You'll create two separate runners, one for Docker and one for Shell.

Runner for Docker
Click on New group runner.
Enter a Runner Description: e.g., Docker Runner.
Tags: Enter docker to specify jobs that the runner can run.
Run untagged jobs: Check this option if you want the runner to run jobs without tags.
Configuration:
Paused: Leave unchecked (unless you want to pause it for initial setup).
Protected: Check this box if you only want it to run for protected branches.
Maximum job timeout: Set a timeout (e.g., 3600 for 1 hour).
Click on Create Runner to save.
Runner for Shell
Click on New group runner again.
Enter a Runner Description: e.g., Shell Runner.
Tags: Enter shell to specify jobs that the runner can run.
Run untagged jobs: Check this option if you want the runner to run jobs without tags.
Configuration:
Paused: Leave unchecked (unless you want to pause it for initial setup).
Protected: Check this box if you only want it to run for protected branches.
Maximum job timeout: Set a timeout (e.g., 3600 for 1 hour).
Click on Create Runner to save.
Step 4: Register Runners
After creating the runners, you'll need to register them. Follow these steps:

Open your terminal (SSH into the server where you want to install the runner).

Install GitLab Runner by following the official documentation.

Once GitLab Runner is installed, register each runner:
![image](https://github.com/user-attachments/assets/c48d1a7f-d772-47a0-85fd-40774dfc0748)
