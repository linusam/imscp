# i-MSCP - internet Multi Server Control Panel
# Copyright (C) 2010-2015 by internet Multi Server Control Panel
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

package Servers::httpd::apache_itk::uninstaller;

use strict;
use warnings;

use iMSCP::Debug;
use iMSCP::File;
use iMSCP::Dir;
use iMSCP::Database;
use File::Basename;
use Servers::httpd::apache_itk;
use parent 'Common::SingletonClass';

sub uninstall
{
	my $self = $_[0];

	my $rs = $self->_removeVloggerSqlUser();
	return $rs if $rs;

	$rs = $self->_removeDirs();
	return $rs if $rs;

	$rs = $self->_vHostConf();
	return $rs if $rs;

	$self->_restoreConf();
}

sub _init
{
	my $self = $_[0];

	$self->{'httpd'} = Servers::httpd::apache_itk->getInstance();

	$self->{'apacheCfgDir'} = $self->{'httpd'}->{'apacheCfgDir'};
	$self->{'apacheBkpDir'} = "$self->{'apacheCfgDir'}/backup";
	$self->{'apacheWrkDir'} = "$self->{'apacheCfgDir'}/working";

	$self->{'config'} = $self->{'httpd'}->{'config'};

	$self;
}

sub _removeVloggerSqlUser
{
	my $self = $_[0];

	my $db = iMSCP::Database->factory();

	$db->doQuery('dummy', 'DROP USER ?@?', 'vlogger_user', $main::imscpConfig{'DATABASE_USER_HOST'});
	$db->doQuery('dummy', 'FLUSH PRIVILEGES');

	0;
}

sub _removeDirs
{
	my $self = $_[0];

	iMSCP::Dir->new('dirname' => $self->{'config'}->{'HTTPD_CUSTOM_SITES_DIR'})->remove();
}

sub _vHostConf
{
	my $self = $_[0];

	if(-f "$self->{'config'}->{'HTTPD_SITES_AVAILABLE_DIR'}/00_nameserver.conf") {
		my $rs = $self->{'httpd'}->disableSites('00_nameserver.conf');
    	return $rs if $rs;

		$rs = iMSCP::File->new(
			'filename' => "$self->{'config'}->{'HTTPD_SITES_AVAILABLE_DIR'}/00_nameserver.conf"
		)->delFile();
		return $rs if $rs;
	}

	my $confDir = (-d "$self->{'config'}->{'HTTPD_CONF_DIR'}/conf-available")
		? $self->{'config'}->{'HTTPD_CONF_DIR'}/conf-available : "$self->{'config'}->{'HTTPD_CONF_DIR'}/conf.d";

    if(-f "$confDir/00_imscp.conf") {
		my $rs = $self->{'httpd'}->disableConfs('00_imscp.conf');
		return $rs if $rs;

		$rs = iMSCP::File->new('filename' => "$confDir/00_imscp.conf")->delFile();
		return $rs if $rs;
	}

	for('000-default', 'default') {
		my $rs = $self->{'httpd'}->enableSites($_) if -f "$self->{'config'}->{'HTTPD_SITES_AVAILABLE_DIR'}/$_";
		return $rs if $rs;
	}

	0;
}

sub _restoreConf
{
	my $self = $_[0];

	for ("$main::imscpConfig{'LOGROTATE_CONF_DIR'}/apache2", "$self->{'config'}->{'HTTPD_CONF_DIR'}/ports.conf") {
		my $filename = fileparse($_);

		if (-f "$self->{bkpDir}/$filename.system") {
			my $rs	= iMSCP::File->new('filename' => "$self->{bkpDir}/$filename.system")->copyFile($_)
			return $rs if $rs;
		}
	}

	0;
}

1;
__END__
