# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'docker'

VAGRANTFILE_API_VERSION = "2"

CURRENT_DIR = Dir.pwd

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    config.vm.define "minidb" do |db|
        db.vm.provider "docker" do |docker|
            docker.name = "minidb"
            docker.image = "mysql"
            docker.remains_running = true
            docker.ports = [ "3306:3306" ]
            docker.expose = [ 3306 ]
            docker.env = {
                "MYSQL_ROOT_PASSWORD" => "changeme"
            }
            docker.cmd = ["mysqld"]
        end
    end

    config.vm.define "web" do |web|
        web.vm.provider "docker" do |docker|
            docker.name = "miniweb"
            docker.build_dir = "."
            docker.ports = [ "1234:1234" ]
            docker.privileged = true
            docker.link 'minidb:minidb'
            docker.volumes = [
                CURRENT_DIR + ":/src"
            ]
            docker.env = {
                'OPENSHIFT_MYSQL_DB_HOST' => 'minidb',
                'OPENSHIFT_MYSQL_DB_PORT' => 3306,
                'OPENSHIFT_MYSQL_DB_USERNAME' => 'root',
                'OPENSHIFT_MYSQL_DB_PASSWORD' => 'changeme',
                'OPENSHIFT_GEAR_NAME' => 'miniminer'
            }
        end
  end


end
