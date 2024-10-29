# GitLab-Runner-Project


To set up a GitLab Group Runner on a GitLab Cloud Premium account and configure it on AWS, we'll be following the steps described below:

Step 1: Prerequisites

GitLab Premium Account: Take a GitLab Premium subscription and admin access to the group where the runner will be registered.
AWS EC2 Instance: Create an AWS EC2 instance to act as the GitLab Runner.
GitLab Runner: Familiarize ourself with GitLab Runner, which is a build instance (Docker, VM, etc.) that GitLab CI/CD uses to run jobs.

Using Amazon Linux 2023 ARM64 AMI 
The yum package manager is used instead of apt-get (as Amazon Linux uses yum by default).
Downloading and installing the ARM64 version of GitLab Runner.
