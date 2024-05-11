provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "jenkins_instance" {
  ami           = "ami-04b70fa74e45c3917"  # Ubuntu AMI ID
  instance_type = "t2.micro"
  key_name      = "lab-1"
  security_groups = ["new-security"]
  tags = {
    Name = "Lab 1"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("lab-1.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y fontconfig",
      "sudo apt install -y openjdk-17-jre",
      "sudo apt install -y python3",
      "wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key |sudo gpg --dearmor -o /usr/share/keyrings/jenkins.gpg",
      "sudo sh -c 'echo deb [signed-by=/usr/share/keyrings/jenkins.gpg] http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'",
      "sudo apt update",
      "sudo apt install -y jenkins",
      "sudo systemctl start jenkins.service"
    ]
  }
}
