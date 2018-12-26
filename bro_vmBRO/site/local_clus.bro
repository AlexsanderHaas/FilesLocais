##! Local site policy. Customize as appropriate.
##!
##! This file will not be overwritten when upgrading or reinstalling!

# This script logs which scripts were loaded during each run.
@load misc/loaded-scripts

# Apply the default tuning scripts for common tuning settings.
@load tuning/defaults

# Estimate and log capture loss.
@load misc/capture-loss

# Enable logging of memory, packet and lag statistics.
@load misc/stats

# Load the scan detection script.
@load misc/scan

# Detect traceroute being run on the network. This could possibly cause
# performance trouble when there are a lot of traceroutes on your network.
# Enable cautiously.
#@load misc/detect-traceroute

# Generate notices when vulnerable versions of software are discovered.
# The default is to only monitor software found in the address space defined
# as "local".  Refer to the software framework's documentation for more
# information.
@load frameworks/software/vulnerable

# Detect software changing (e.g. attacker installing hacked SSHD).
@load frameworks/software/version-changes

# This adds signatures to detect cleartext forward and reverse windows shells.
@load-sigs frameworks/signatures/detect-windows-shells

# Load all of the scripts that detect software in various protocols.
@load protocols/ftp/software
@load protocols/smtp/software
@load protocols/ssh/software
@load protocols/http/software
# The detect-webapps script could possibly cause performance trouble when
# running on live traffic.  Enable it cautiously.
#@load protocols/http/detect-webapps

# This script detects DNS results pointing toward your Site::local_nets
# where the name is not part of your local DNS zone and is being hosted
# externally.  Requires that the Site::local_zones variable is defined.
@load protocols/dns/detect-external-names

# Script to detect various activity in FTP sessions.
@load protocols/ftp/detect

# Scripts that do asset tracking.
@load protocols/conn/known-hosts
@load protocols/conn/known-services
@load protocols/ssl/known-certs

# This script enables SSL/TLS certificate validation.
@load protocols/ssl/validate-certs

# This script prevents the logging of SSL CA certificates in x509.log
@load protocols/ssl/log-hostcerts-only

# Uncomment the following line to check each SSL certificate hash against the ICSI
# certificate notary service; see http://notary.icsi.berkeley.edu .
# @load protocols/ssl/notary

# If you have libGeoIP support built in, do some geographic detections and
# logging for SSH traffic.
@load protocols/ssh/geo-data
# Detect hosts doing SSH bruteforce attacks.
@load protocols/ssh/detect-bruteforcing
# Detect logins using "interesting" hostnames.
@load protocols/ssh/interesting-hostnames

# Detect SQL injection attacks.
@load protocols/http/detect-sqli

#### Network File Handling ####

# Enable MD5 and SHA1 hashing for all files.
@load frameworks/files/hash-all-files

# Detect SHA1 sums in Team Cymru's Malware Hash Registry.
@load frameworks/files/detect-MHR

# Uncomment the following line to enable detection of the heartbleed attack. Enabling
# this might impact performance a bit.
# @load policy/protocols/ssl/heartbleed

# Uncomment the following line to enable logging of connection VLANs. Enabling
# this adds two VLAN fields to the conn.log file.
# @load policy/protocols/conn/vlan-logging

# Uncomment the following line to enable logging of link-layer addresses. Enabling
# this adds the link-layer address for each connection endpoint to the conn.log file.
# @load policy/protocols/conn/mac-logging

# Uncomment the following line to enable the SMB analyzer.  The analyzer
# is currently considered a preview and therefore not loaded by default.
# @load policy/protocols/smb

# Add 15-12-18 Alexsander Haas
@load base/utils/site
redef Site::local_nets: set[subnet] = {
		10.0.0.0/8,
		192.168.0.0/16,
		172.16.0.0/12,
		100.64.0.0/10,  # RFC6598 Carrier Grade NAT
		127.0.0.0/8,
		[fe80::]/10,
		[::1]/128,
	};

# Add 30-05 Alexsander Haas

@load base/protocols/http
redef HTTP::default_capture_password = T;

@load policy/protocols/dhcp/known-devices-and-hostnames
@load policy/misc/known-devices
redef Known::known_devices = {"1.0 min"};

@load policy/protocols/http/detect-sqli
@load policy/protocols/http/detect-webapps
@load policy/protocols/http/software
@load policy/protocols/http/software-browser-plugins

@load policy/protocols/dns/auth-addl
@load policy/protocols/dns/detect-external-names

@load policy/protocols/conn/known-hosts
@load policy/protocols/conn/known-services
@load policy/protocols/conn/vlan-logging
@load policy/protocols/conn/mac-logging

@load policy/protocols/ssh/interesting-hostnames
@load policy/protocols/ssh/software
@load policy/protocols/ssh/detect-bruteforcing

# Add 28-11
#@load zcodes/add_field
@load zcodes/kafka_producer_cluster

# Add 03-06 Alexsander Haas
#@load module-foo
#@load zcodes/module-full
#@load zcodes/module-devices

redef ignore_checksums = T; #add 25-11
