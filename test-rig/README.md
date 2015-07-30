___DO NOT USE THIS YET___

A test rig for running multiple variants of the build as a kind of poor-man's CI

We use Digital Ocean's plugin https://www.digitalocean.com/community/projects/vagrant

You need to do this if you want to play along at home:

* vagrant plugin install vagrant-digitalocean
* Copy config.yaml.example to config.yaml and edit it to your requirements
* And then `vagrant up --provider=digital_ocean`
