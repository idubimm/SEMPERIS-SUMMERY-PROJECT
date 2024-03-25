user_data = <<-EOF
    #!/bin/bash
    echo "Installing dependencies..."
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo apt-get install -y docker-compose
    echo "pulling docker compose images "
    wget "https://raw.githubusercontent.com/idubimm/SEMPERIS-SUMMERY-PROJECT/main/src/docker-compose-flat-withoutparamters.yml" ./docker-compose-image.yml
    sudo docker-compose -f ./docker-compose-flat-withoutparamters.yml  up
EOF