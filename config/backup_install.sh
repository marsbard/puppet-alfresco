

cd "`dirname $0`"/..

if [ -f .IS_VAGRANT ]
then
  vagrant ssh "/vagrant/install/vagrant-apply-backup.sh"
else
  puppet apply --modulepath=modules do_backup.pp
fi
