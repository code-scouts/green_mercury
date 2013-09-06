# I am not really a shell script. Don't execute me anywhere.
# copy/paste commands from here as appropriate.

# ON REMOTE
    # add the puppetlabs apt repository for the latest puppet
    wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb
    sudo dpkg -i puppetlabs-release-precise.deb
    sudo apt-get update

    sudo apt-get install puppet-common
    # make a puppet cron-job with puppet
    sudo puppet resource cron puppet-apply ensure=present user=root minute=30 command='/usr/bin/puppet apply $(/usr/bin/puppet config print manifest)'

# ON LOCAL
    # sync the puppet config
    rsync -rl puppet/* greenmercury:/home/ubuntu/puppet

#ON REMOTE
    # put the puppet config in place
    sudo cp -r puppet/modules/* /etc/puppet/modules/
    sudo cp -r puppet/manifests/* /etc/puppet/manifests/
    sudo puppet apply $(sudo puppet config print manifest)

    #run puppet

    #create a .env file for the app
    # it needs these keys (and values, where provided)

    # PGPASSWORD
    # AWS_ACCESS_KEY_ID
    # AWS_SECRET_ACCESS_KEY
    # CLOUDFRONT=d2tkaj1n5zn3uf
    # ENGAGE_API_KEY
    # FOG_DIRECTORY=green-mercury-assets
    # FOG_PROVIDER=AWS
    # MEETUP_API_KEY
    # MEETUP_API_SECRET
    # NEW_RELIC_APP_NAME=Green Mercury
    # NEW_RELIC_LICENSE_KEY
    # NEW_RELIC_LOG=stdout
