#!/bin/bash
set -e

# Update system
sudo yum update -y

# Install Python and required packages
sudo yum install -y python3 python3-pip nginx

# Create application directory in home directory instead of /opt
mkdir -p ~/streamlit-app

# Copy application files
cp -r /tmp/app/* ~/streamlit-app/
cd ~/streamlit-app

# Remove packer directory from the app
rm -rf packer/

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install Python dependencies
pip install --upgrade pip
pip install -r requirements.txt

# Install CloudWatch agent
sudo yum install -y amazon-cloudwatch-agent

# Configure nginx
sudo tee /etc/nginx/conf.d/streamlit.conf << EOF
server {
    listen 80;
    server_name _;
    
    location / {
        proxy_pass http://localhost:8501;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

sudo systemctl enable nginx

# Clean up
sudo yum clean all
