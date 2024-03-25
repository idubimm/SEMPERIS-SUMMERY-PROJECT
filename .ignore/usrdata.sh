user_data = <<-EOF
    #!/bin/bash
    echo "Installing dependencies..."
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo apt  install docker-compose
    sudo apt-get install -y docker-compose
    wget "https://raw.githubusercontent.com/idubimm/SEMPERIS-SUMMERY-PROJECT/main/src/docker-compose-image.yml" .
    sudo docker-compose -f ./docker-compose-image.yml  up
    echo "pulling docker compose file "
    sudo  pull lilachamar/flask-sql-i:latest
    sudo docker run -d -p 5000:5000 lilachamar/flask-sql-i:latest
EOF