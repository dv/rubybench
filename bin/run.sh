#!/bin/bash

vmlist=(ruby-head jruby-head rbx-head ree-1.8.7-head ironruby-head)

cat > /home/ubuntu/bootstrap.sh <<EOF
#!/bin/bash

cd /home/ubuntu/

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y git-core make gcc build-essential autoconf libreadline5 ruby libruby1.8 ruby1.8 bison build-essential bison openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake mono-devel subversion ant openjdk-6-jdk curl g++ openjdk-6-jre-headless 

bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
echo '[[ -s "/home/ubuntu/.rvm/scripts/rvm" ]] && source "/home/ubuntu/.rvm/scripts/rvm"' >> /home/ubuntu/.bashrc

source "/home/ubuntu/.rvm/scripts/rvm"

for vm in ${vmlist[@]}
do
  rvm install \$vm
done

git clone https://github.com/acangiano/ruby-benchmark-suite.git
cd ruby-benchmark-suite

for vm in ${vmlist[@]}
do
  rvm use \$vm
  rake bench
done

bash
EOF

chmod +x /home/ubuntu/bootstrap.sh


su -c 'screen -d -m /home/ubuntu/bootstrap.sh' ubuntu
