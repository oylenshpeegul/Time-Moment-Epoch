package Epochs;

use strict;
use warnings;
use Scalar::Util qw(looks_like_number);
use Math::BigInt lib => 'GMP';
use Time::Moment;

my $SECONDS_PER_DAY = 24 * 60 * 60;

# Chrome time is the number of microseconds since 1601-01-01, which is
# 11,644,473,600 seconds before the Unix epoch.
#
sub chrome {
	my $num = shift;
	_epoch($num, 1_000_000, -11_644_473_600);
}

# Cocoa time is the number of seconds since 2001-01-01, which
# is 978,307,200 seconds after the Unix epoch.
sub cocoa {
	my $num = shift;
	_epoch($num, 1, 978_307_200);
}

# Google Calendar time seems to count 32-day months from the day
# before the Unix epoch.
sub google_calendar {
	my $n = shift;

	return unless looks_like_number $n;

	my $b = Math::BigInt->new($n);
	my($total_days, $seconds) = $b->bdiv($SECONDS_PER_DAY);

	# A "Google month" has 32 days!
	my($months, $days) = $total_days->bdiv(32);

	# The "Google epoch" is apparently off by a day.
	my $t = Time::Moment->from_epoch(-$SECONDS_PER_DAY);

	# Add the days first...
	my $u = $t->plus_days($days);

	# ...then the months.
	my $v = $u->plus_months($months);

	# ...then the seconds.
	my $w = $v->plus_seconds($seconds);

	return $w;
}

#  ICQ time is the number of days since 1899-12-30, which is
#  2,209,161,600 seconds before the Unix epoch. Days can have a
#  fractional part.
sub icq {
	my $days = shift // return;

	return unless looks_like_number $days;

	my $t = Time::Moment->from_epoch(-2_209_161_600);

	my $intdays = int($days);

	# Want the fractional part of the day in nanoseconds.
	my $fracday = int(($days - $intdays) * $SECONDS_PER_DAY * 1e9);

	return $t->plus_days($days)->plus_nanoseconds($fracday);
}

# Java time is in milliseconds since the Unix epoch.
sub java {
	my $num = shift;
	_epoch($num, 1000);
}

# Mozilla time is in microseconds since the Unix epoch.
sub mozilla {
	my $num = shift;
	_epoch($num, 1_000_000);
}

#  OLE time is the number of days since 1899-12-30, which is
#  2,209,161,600 seconds before the Unix epoch.
sub ole {
	my $num = shift // return;

	my $hex = sprintf "%x", $num;
	my $d_days = unpack("d", pack("H*", $hex)) or return;

	return if $d_days eq '-nan';

	return icq $d_days;
}

# Symbian time is the number of microseconds since the year 0, which
# is 62,167,219,200 seconds before the Unix epoch.
sub symbian {
	my $num = shift;
	_epoch($num, 1_000_000, -62_167_219_200);
}

# Unix time is the number of seconds since 1970-01-01.
sub unix {
	my $num = shift;
	_epoch($num);
}

# UUID version 1 time (RFC 4122) is the number of hectonanoseconds
# (100 ns) since 1582-10-15, which is 12,219,292,800 seconds before
# the Unix epoch.
sub uuid_v1 {
	my $num = shift;
	_epoch($num, 10_000_000, -12_219_292_800);
}

# Windows date time (e.g., .NET) is the number of hectonanoseconds
# (100 ns) since 0001-01-01, which is 62,135,596,800 seconds before
# the Unix epoch.
sub windows_date {
	my $num = shift;
	_epoch($num, 10_000_000, -62_135_596_800);
}

# Windows file time (e.g., NTFS) is the number of hectonanoseconds
# (100 ns) since 1601-01-01, which is 11,644,473,600 seconds before
# the Unix epoch.
sub windows_file {
	my $num = shift;
	_epoch($num, 10_000_000, -11_644_473_600);
}

	
sub _epoch {
	my $num = shift // return;
	my $q = shift // 1;
	my $s = shift // 0;

	return unless looks_like_number $num;

	my($z, $m) = Math::BigInt->new($num)->bdiv($q);
	my $r = ($m * 1e9)->bdiv($q);
	Time::Moment->from_epoch($z + $s, $r);
}

1;
