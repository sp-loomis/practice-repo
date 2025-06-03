packer {
  required_plugins {
    amazon = {
      version = " >= 1.2.8 "
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "app_version" {
  type    = string
  default = "latest"
}

source "amazon-ebs" "streamlit-app" {
  ami_name      = "streamlit-app-${var.app_version}-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  
  source_ami = "ami-02457590d33d576c3"
  
  ssh_username = "ec2-user"
  
  tags = {
    Name        = "streamlit-app"
    Version     = var.app_version
    Environment = "production"
    BuildDate   = formatdate("YYYY-MM-DD", timestamp())
  }
}

build {
  name = "streamlit-app"
  sources = [
    "source.amazon-ebs.streamlit-app"
  ]
  
  provisioner "shell" {
    inline = ["mkdir -p /tmp/app"]
  }
  # Copy application files
  provisioner "file" {
    source      = "../"
    destination = "/tmp/app/"
  }
  
  # Run setup script
  provisioner "shell" {
    script = "setup.sh"
  }
  
  # Create systemd service
  provisioner "file" {
    content = <<EOF
[Unit]
Description=Streamlit App
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/opt/streamlit-app
Environment=PATH=/opt/streamlit-app/venv/bin
ExecStart=/opt/streamlit-app/venv/bin/streamlit run app.py --server.address 0.0.0.0 --server.port 8501
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF
    destination = "/tmp/streamlit-app.service"
  }
  
  provisioner "shell" {
    inline = [
      "sudo mv /tmp/streamlit-app.service /etc/systemd/system/",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable streamlit-app"
    ]
  }
}