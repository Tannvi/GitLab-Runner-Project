#Step 1: Install Docker on AWS Linux 2023 ARM64

#Connect to your EC2 instance: Use SSH to connect to your EC2 instance.
ssh ec2-user@<your-ec2-public-ip>

#Update the system: Make sure your system is up-to-date.
sudo yum update -y

#Install Docker: Install Docker using Amazon Linux's package manager.
sudo yum install -y docker

#Start the Docker service: Enable and start the Docker service.
sudo systemctl start docker
sudo systemctl enable docker

#Add ec2-user to the docker group: This allows the runner to execute Docker commands without requiring sudo.
sudo usermod -aG docker ec2-user

#Log out and log back in to apply the group changes:
exit
ssh ec2-user@<your-ec2-public-ip>

#Verify Docker installation: Check if Docker is installed correctly by running:
docker --version

#This should output the Docker version installed on the system.

#Step 2: Configure Docker for ARM64 if Needed
docker build --platform linux/arm64 -t ${DOCKER_IMAGE} .

Step 3: Test Docker with GitLab Runner
sudo gitlab-runner restart

#Ensure the correct runner tags (docker tag for Docker executor) are set in your .gitlab-ci.yml.

curl -LO https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh
sudo gitlab-runner run



curl -LO https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh

sudo bash script.deb.sh

sudo dnf update -y

curl -LO https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64

sudo install gitlab-runner-linux-amd64 /usr/local/bin/gitlab-runner

sudo dnf install -y git curl vim

sudo dnf update

sudo dnf clean all

sudo dnf install -y git curl vim --allowerasing

sudo dnf install -y curl

sudo gitlab-runner register

uname -m

sudo rm /usr/

local/bin/gitlab-runner

curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-arm64

sudo curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-arm64

sudo chmod +x /usr/local/bin/gitlab-runner

ls -l /usr/local/bin/gitlab-runner

sudo gitlab-runner register

gitlab-runner run

sudo gitlab-runner register

sudo gitlab-runner run

sudo yum update -y

sudo yum install -y docker

sudo systemctl start docker

sudo systemctl enable docker

sudo usermod -aG docker ec2-user

exit

ssh ec2-user@35.179.171.76
docker --version
