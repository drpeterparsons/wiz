sudo apt-get install gnupg curl
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
curl -fsSL https://www.mongodb.org/static/pgp/server-6.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor
sudo apt-get update
sudo apt-get install -y mongodb-org=6.0.10 mongodb-org-database=6.0.10 mongodb-org-server=6.0.10 mongodb-org-mongos=6.0.10 mongodb-org-tools=6.0.10
sudo systemctl start mongod
sudo systemctl daemon-reload
sudo systemctl enable mongod
