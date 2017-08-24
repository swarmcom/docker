#!/bin/sh -e

/usr/bin/ruby /usr/local/sipx/lib/ruby/gems/1.8/gems/sipxcallresolver-2.0.0/lib/main.rb --daemon --confdir /etc/sipxcdr/conf --logdir /var/log/sipxpbx
