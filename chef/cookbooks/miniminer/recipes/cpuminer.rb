#cpuminer
git 'cpuminer_repo' do
  repository 'https://github.com/pooler/cpuminer.git'
  destination '/miners/cpuminer'
  action :sync
end

# remote_file '/miners/cpuminer' do
#     source 'http://downloads.sourceforge.net/project/cpuminer/pooler-cpuminer-2.4.4-linux-x86_64.tar.gz?&use_mirror=ufpr'
# end

file '/miners/cpuminer/starter' do
    content '#!/bin/sh
./minerd --algo=scrypt --url=stratum+tcp://us.litecoinpool.org:3333 --userpass=poolcrox.worker1:1122'
end

# execute 'start' do
#   command '/miners/cpuminer/starter'
# end
