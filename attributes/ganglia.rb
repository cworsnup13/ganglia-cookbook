### GENERAL
#
set[:ganglia][:version]                               = `lsb_release -cs`.chomp == 'precise' ? "3.4.0" : '3.3.8'
set[:ganglia][:uri]                                   = "http://sourceforge.net/projects/ganglia/files/ganglia%20monitoring%20core/#{ganglia[:version]}/ganglia-#{ganglia[:version]}.tar.gz/download"
set[:ganglia][:checksum]                              = "4d4d30ef26703a0c72a7ac62be83d27e"

default[:ganglia][:dir]                               = "/etc/ganglia"
default[:ganglia][:lib]                               = "/usr/lib/ganglia"

set[:ganglia][:web][:version]                         = "3.4.2"
set[:ganglia][:web][:checksum]                        = "09a4a8766bc323fd0df8d27a034a4d60bfbcfe97"
set[:ganglia][:web][:save_to_basepath]                = "/usr/local/src"
set[:ganglia][:web][:dir_name]                        = "ganglia-web-#{ganglia[:web][:version]}"
set[:ganglia][:web][:archive_name]                    = "#{ganglia[:web][:dir_name]}.tar.gz"
set[:ganglia][:web][:save_to]                         = "#{ganglia[:web][:save_to_basepath]}/#{ganglia[:web][:archive_name]}"
set[:ganglia][:web][:uri]                             = "http://sourceforge.net/projects/ganglia/files/ganglia-web/#{ganglia[:web][:version]}/#{ganglia[:web][:archive_name]}/download"

default[:ganglia][:web][:server_name]                 = "ganglia-web.localhost"
default[:ganglia][:web][:ssl][:enabled]               = true
default[:ganglia][:web][:ssl][:certificate]           = "/etc/ssl/certs/ssl-cert-snakeoil.pem"
default[:ganglia][:web][:ssl][:key]                   = "/etc/ssl/certs/ssl-cert-snakeoil.key"
default[:ganglia][:web][:ssl][:certificate_authority] = "/etc/apache2/ssl.crt/ca-bundle.crt"
default[:ganglia][:web][:views][:enabled]             = []
default[:ganglia][:web][:views][:disabled]            = []
default[:ganglia][:web][:username]                    = "ganglia"
default[:ganglia][:web][:password]                    = "ChangeMeNOW!!!"



### MODULES
#
# Redis
# Exposes most of the counters in the Redis `INFO` command
default[:ganglia][:python_modules][:redis][:status]         = :disabled
default[:ganglia][:python_modules][:redis][:collect_every]  = 10
default[:ganglia][:python_modules][:redis][:time_threshold] = 30
default[:ganglia][:python_modules][:redis][:host]           = "localhost"
default[:ganglia][:python_modules][:redis][:port]           = 6379
#
# MongoDB
# Parses output from the db.serverStatus() and rs.status() commands
# /usr/bin/mongo --host mongodb-1 --port 27017 --quiet --eval "printjson(db.serverStatus())"
default[:ganglia][:python_modules][:mongodb][:status]         = :disabled
default[:ganglia][:python_modules][:mongodb][:collect_every]  = 30
default[:ganglia][:python_modules][:mongodb][:time_threshold] = 60
default[:ganglia][:python_modules][:mongodb][:server_status]  = "mongo --quiet --eval 'printjson(db.serverStatus())'"
default[:ganglia][:python_modules][:mongodb][:rs_status]      = "mongo --quiet --eval 'printjson(rs.status())'"
#
# MySQL
# To setup database access:
#   GRANT SUPER, PROCESS ON *.* TO your_user@localhost \
#   IDENTIFIED BY "your_password";
set[:ganglia][:python_modules][:mysql][:files]                = %w[DBUtil.py]
set[:ganglia][:python_modules][:mysql][:pips]                 = { 'mysql-python' => "1.2.3" }
default[:ganglia][:python_modules][:mysql][:status]           = :disabled
default[:ganglia][:python_modules][:mysql][:collect_every]    = 30
default[:ganglia][:python_modules][:mysql][:time_threshold]   = 60
default[:ganglia][:python_modules][:mysql][:host]             = "localhost"
default[:ganglia][:python_modules][:mysql][:username]         = "root"
default[:ganglia][:python_modules][:mysql][:password]         = ""
default[:ganglia][:python_modules][:mysql][:innodb]           = "True"
default[:ganglia][:python_modules][:mysql][:master]           = "False"
default[:ganglia][:python_modules][:mysql][:slave]            = "False"
default[:ganglia][:python_modules][:mysql][:delta_per_second] = "True"
#
# RabbitMQ
# Supposedly works, not sure about that...
# https://github.com/ganglia/gmond_python_modules/pull/64
# Sends metrics on RabbitMQ nodes using the stats api. It is based off the very
# similar ElasticSearch module.
set[:ganglia][:python_modules][:rabbitmq][:pips]                 = { 'simplejson' => "2.6.0" }
default[:ganglia][:python_modules][:rabbitmq][:status]           = :disabled
default[:ganglia][:python_modules][:rabbitmq][:collect_every]    = 30
default[:ganglia][:python_modules][:rabbitmq][:time_threshold]   = 60
default[:ganglia][:python_modules][:rabbitmq][:host]             = "localhost"
default[:ganglia][:python_modules][:rabbitmq][:vhost]            = "/"
default[:ganglia][:python_modules][:rabbitmq][:username]         = "guest"
default[:ganglia][:python_modules][:rabbitmq][:password]         = "guest"
#
# Diskfree
# Reads a list of mountpoints from the "mounts" parameter (probably
# /proc/mounts) and creates a "disk_free_(absolute|percent)_*" metric for each
# mountpoint it finds.
default[:ganglia][:python_modules][:diskfree][:status]         = :disabled
default[:ganglia][:python_modules][:diskfree][:collect_every]  = 60
default[:ganglia][:python_modules][:diskfree][:time_threshold] = 180
default[:ganglia][:python_modules][:diskfree][:mounts]         = "/proc/mounts"
default[:ganglia][:python_modules][:diskfree][:custom_metrics] = [
  #{
    #:name => "disk_free_percent_mnt",
    #:title => "Disk Space Available On /mnt in %"
  #}
]
#
# Diskstat
# Can monitor multiple disk block devices including specific partitions instead of the entire device.
# This module has the option of explicitly setting which devices
# to check using the "devices" option in your configuration. You
# can monitor specific partitions instead of the entire device.
default[:ganglia][:python_modules][:diskstat][:status]         = :disabled
default[:ganglia][:python_modules][:diskstat][:collect_every]  = 60
default[:ganglia][:python_modules][:diskstat][:time_threshold] = 180
# Example value: "sda1 sda2".
# Example value: "sda sdb sdc".
default[:ganglia][:python_modules][:diskstat][:devices]        = "sda"
default[:ganglia][:python_modules][:diskstat][:device_mapper]  = "False"
#
# Apache status
# Sends metrics on Apache's status (mod_status.so).
# Remember to enable mod_status in Apache.
default[:ganglia][:python_modules][:apache_status][:status]              = :disabled
default[:ganglia][:python_modules][:apache_status][:collect_every]       = 10
default[:ganglia][:python_modules][:apache_status][:time_threshold]      = 20
default[:ganglia][:python_modules][:apache_status][:url]                 = "http://localhost/server-status?auto"
# Collecting SSL metrics under Apache 2.2 appears to cause a memory leak
# in mod_status. Watch Apache memory utilization if you enable them
default[:ganglia][:python_modules][:apache_status][:collect_ssl]         = "False"
#
# nginx status
# Sends metrics on nginx's status (stub module): http://wiki.nginx.org/HttpStubStatusModule
#
# server {
#   server_name nginx_status;
#
#   location / {
#     stub_status on;
#     access_log  off;
#     allow       127.0.0.1;
#     deny        all;
#   }
# }
default[:ganglia][:python_modules][:nginx_status][:status]         = :disabled
default[:ganglia][:python_modules][:nginx_status][:collect_every]  = 10
default[:ganglia][:python_modules][:nginx_status][:time_threshold] = 20
default[:ganglia][:python_modules][:nginx_status][:url]            = "http://nginx_status"
default[:ganglia][:python_modules][:nginx_status][:refresh_rate]   = 15
#
# Procstat
# Exposes values for CPU and memory utilization for running processes. You can
# retrieve the process ID from either providing a pidfile or an awk regular
# expression. Using a pidfile is the most efficient and direct method.
default[:ganglia][:python_modules][:procstat][:status]         = :disabled
default[:ganglia][:python_modules][:procstat][:collect_every]  = 30
default[:ganglia][:python_modules][:procstat][:time_threshold] = 30
default[:ganglia][:python_modules][:procstat][:processes]      = [
  {
    :name  => "ganglia-monitor",
    :value => "/bin.*gmond/"
  }
]



### GMETAD - Responsible for collecting data from an arbitrary number of GMONDs
#
# If you don't want gmetad to setuid then set this to off.
default[:ganglia][:gmetad][:setuid]  = "on"
#
# User gmetad will setuid to (defaults to "nobody")
default[:ganglia][:gmetad][:user]  = "nobody"
default[:ganglia][:gmetad][:gridname]  = "unspecified"
default[:ganglia][:gmetad][:clusters]  = {}

default[:ganglia][:gmetad][:rrd_dir] = "/var/lib/ganglia/rrds"

### GMOND - Gathers user specified stats and shares them over the network
#
# Ganglia uses an IP address as a "key" so to avoid possible conflicts if
# override_ip is not specified it will be set to override_hostname. This avoids
# issues if you decide to change the override_hostname on the same machine.
#
# If you don't want gmetad to setuid then set this to no.
default[:ganglia][:gmond][:setuid] = "yes"
#
# User gmetad will setuid to (defaults to "ganglia")
default[:ganglia][:gmond][:user] = "ganglia"
#
default[:ganglia][:gmond][:override_hostname] = node[:hostname]
#
# This is problematic for the collector, investigate if it becomes a requirement
#
# default[:ganglia][:gmond][:override_ip] = node[:ipddress]
#
# There should only be one cluster section defined.
# This section controls how gmond reports the attributes of the cluster
# that it is part of.
#
default[:ganglia][:gmond][:cluster_name] = "unspecified"

# The owner tag specifies the administrators of the cluster.
# The pair name/owner should be unique to all clusters in your network.
#
default[:ganglia][:gmond][:cluster_owner] = "unspecified"

# The url for more information on the cluster.
# Intended to give purpose, owner, administration, and account details
# for this cluster.
#
default[:ganglia][:gmond][:cluster_url] = "unspecified"

# The host section provides information about the host running this
# instance of gmond. Currently only the location string attribute is supported.
#
default[:ganglia][:gmond][:host_location] = "unspecified"

# The host_dmax value is an integer with units in seconds. When set to zero (0),
# gmond will never delete a host from its list even when a remote host
# has stopped reporting. If host_dmax is set to a positive number then
# gmond will flush a host after it has not heard from it for host_dmax seconds.
# By the way, dmax means "delete max".
#
default[:ganglia][:gmond][:host_dmax] = 3600 # seconds

# The cleanup_threshold is the minimum amount of time before gmond will
# cleanup any hosts or metrics where tn > dmax a.k.a. expired data.
#
default[:ganglia][:gmond][:cleanup_threshold] = 300 # seconds

# The send_metadata_interval establishes an interval in which gmond will send
# or resend the metadata packets that describe each enabled metric.
# This directive by default is set to 0 which means that gmond will only send
# the metadata packets at startup and upon request from other gmond nodes
# running remotely. If a new machine running gmond is added to a cluster,
# it needs to announce itself and inform all other nodes of the metrics that
# it currently supports. In multicast mode, this isn't a problem because any
# node can request the metadata of all other nodes in the cluster.
# However in unicast mode, a resend interval must be established.
# The interval value is the minimum number of seconds between resends.
#
default[:ganglia][:gmond][:send_metadata_interval] = 30 # seconds

# You can define as many udp_send_channel sections as you like within the
# limitations of memory and file descriptors. If gmond is configured as mute
# this section will be ignored.
#
# The udp_send_channel has the following attributes:
# * mcast_join
# * mcast_if
# * host
# * port
# * ttl
#
# The mcast_join and mcast_if attributes are optional.
# When specified gmond will create the UDP socket and join the mcast_join
# multicast group and send data out the interface specified by mcast_if.
#
# If only a host and port are specified then gmond will send unicast UDP messages
# to the hosts specified. You could specify multiple unicast hosts for redundancy
# as gmond will send UDP messages to all UDP channels.
#
# EXAMPLE:
#
#   udp_send_channel {
#     host = host.foo.com
#     port = 2389
#   }
#
#   udp_send_channel {
#     host = 192.168.3.4
#     port = 2344
#   }
#
# This gmond doesn't send any data:
#
default[:ganglia][:gmond][:udp_send_channels] = []

# You can specify as many udp_recv_channel sections as you like within the
# limits of memory and file descriptors. If gmond is configured deaf this
# attribute will be ignored.
#
# The udp_recv_channel section has following attributes:
# * mcast_join
# * bind
# * port
# * mcast_if
# * family
#
# The udp_recv_channel can also have an acl definition.
#
# The mcast_join and mcast_if should only be used if you want to have this
# UDP channel receive multicast packets the multicast group mcast_join
# on interface mcast_if. If you do not specify multi-cast attributes then
# gmond will simply create a UDP server on the specified port.
#
# You can use the bind attribute to bind to a particular local address.
#
# The family address is set to inet4 by default. If you want to bind the port
# to an inet6 port, you need to specify that in the family attribute.
# Ganglia will not allow IPV6=>IPV4 mapping (for portability and security reasons).
# If you want to listen on both inet4 and inet6 for a particular port,
# explicitly state it.
#
# If you specify a bind address, the family of that address takes precedence.
# If your IPv6 stack doesn't support IPV6_V6ONLY, a warning will be issued,
# but gmond will continue working (this should rarely happen).
#
# Multicast Note: for multicast, specifying a bind address with the same value
# used for mcast_join will prevent unicast UDP messages to the same port
# from being processed.
#
# This gmond listens on any local IP for UDP packets on port 8649.
#
default[:ganglia][:gmond][:udp_recv_channels] = [
  {
    :port => 8649
  }
]

# You can specify as many tcp_accept_channel sections as you like within the
# limitations of memory and file descriptors. If gmond is configured to be
# mute, then these sections are ignored.
#
# The tcp_accept_channel has the following attributes:
# * bind
# * port
# * interface
# * family
# * timeout
#
# A tcp_accept_channel may also have an acl section specified.
#
# The bind address is optional and allows you to specify which local address
# gmond will bind to for this channel.
#
# The port is an integer than specifies which port to answer requests for data.
#
# The family address is set to inet4 by default. If you want to bind the port
# to an inet6 port, you need to specify that in the family attribute.  Ganglia
# will not allow IPV6=>IPV4 mapping (for portability and security reasons).  If
# you want to listen on both inet4 and inet6 for a particular port, explicitly
# state it.
#
# If you specify a bind address, the family of that address takes precedence.
# If your IPv6 stack doesn't support IPV6_V6ONLY, a warning will be issued, but
# gmond will continue working (this should rarely happen).
#
# The timeout attribute allows you to specify how many microseconds to block
# before closing a connection to a client. The default is set to 1 second
# (1000000 usecs). If you have a very slow connection you may need to increase
# this value.
#
# This gmond listens on any local IP for TCP packets on port 8649.
#
default[:ganglia][:gmond][:tcp_accept_channels] = [
  {
    :port => 8649
  }
]

# You can specify as many collection_group section as you like within the
# limitations of memory.  A collection_group has the following attributes:
# * collect_once
# * collect_every
# * time_threshold
#
# A collection_group must also contain one or more metric sections.
#
# The metric section has the following attributes:
# * name
# * value_threshold
# * title
#
# For a list of available metric names, run the following command:
#  % gmond -m
#
# Here is an example of a collection group for a static metric:
#
# collection_group {
#   collect_once = yes
#   time_threshold = 1800
#   metric {
#     name = "cpu_num"
#     title = "Number of CPUs"
#   }
# }
#
# This collection_group entry would cause gmond to collect the cpu_num metric
# once at startup (since the number of CPUs will not change between reboots).
# The metric cpu_num would be send every 1/2 hour (1800 seconds). The default
# value for the time_threshold is 3600 seconds if no time_threshold is specified.
#
# The time_threshold is the maximum amount of time that can pass before gmond
# sends all metrics specified in the collection_group to all configured
# udp_send_channels. A metric may be sent before this time_threshold is met if
# during collection the value surpasses the value_threshold (explained below).
#
# Here is an example of a collection group for a volatile metric:
#
# collection_group {
#   collect_every = 60
#   time_threshold = 300
#   metric {
#     name = "cpu_user"
#     value_threshold = 5.0
#     title = "CPU User"
#   }
#   metric {
#     name = "cpu_idle"
#     value_threshold = 10.0
#     title = "CPU Idle"
#   }
# }
#
# This collection group would collect the cpu_user and cpu_idle metrics every 60
# seconds (specified in collect_every). If cpu_user varies by 5.0% or cpu_idle
# varies by 10.0%, then the entire col- lection_group is sent. If no
# value_threshold is triggered within time_threshold seconds (in this case 300),
# the entire collection_group is sent.
#
# Each time the metric value is collected the new value is compared with the old
# value collected. If the difference between the last value and the current
# value is greater than the value_thresh- old, the entire collection group is
# send to the udp_send_channels defined.
#
# It's important to note that all metrics in a collection group are sent even
# when only a single value_threshold is surpassed.  In addition a user friendly
# title can be substituted for the metric name by including a title within the
# metric section.

### WEB SERVER - plain auth credentials, behind HTTPS presumably
#
default[:ganglia][:admin] = {
  :user     => "ganglia",
  :password => "ChangeMeNOW!!!"
}
