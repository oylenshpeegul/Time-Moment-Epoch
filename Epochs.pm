package Epochs;

use strict;
use warnings;
use Math::BigInt lib => 'GMP';
use Math::BigFloat;
use Scalar::Util qw(looks_like_number);
use Time::Moment;

my $SECONDS_PER_DAY = 24 * 60 * 60;
my $NANOSECONDS_PER_DAY = $SECONDS_PER_DAY * 1e9;

# Chrome time is the number of microseconds since 1601-01-01, which is
# 11,644,473,600 seconds before the Unix epoch.
#
sub chrome {
	my $num = shift;
	_epoch2time($num, 1_000_000, -11_644_473_600);
}
sub to_chrome {
	my $tm = shift;
	_time2epoch($tm, 1_000_000, -11_644_473_600);
}

# Cocoa time is the number of seconds since 2001-01-01, which
# is 978,307,200 seconds after the Unix epoch.
sub cocoa {
	my $num = shift;
	_epoch2time($num, 1, 978_307_200);
}
sub to_cocoa {
	my $tm = shift;
	_time2epoch($tm, 1, 978_307_200);
}

# Google Calendar time seems to count 32-day months from the day
# before the Unix epoch. @noppers worked out how to do this.
sub google_calendar {
	my $n = shift;

	return unless looks_like_number $n;

	my $b = Math::BigInt->new($n);
	my($total_days, $seconds) = $b->bdiv($SECONDS_PER_DAY);
	my($months, $days) = $total_days->bdiv(32);

	Time::Moment
		  ->from_epoch(-$SECONDS_PER_DAY)
		  ->plus_days($days)
		  ->plus_months($months)
		  ->plus_seconds($seconds);
}
sub to_google_calendar {
	my $tm = shift;

	if (ref $tm ne 'Time::Moment') {
		$tm = Time::Moment->from_string($tm);
	}

	((((($tm->year - 1970 )*12
	  + ($tm->month -   1))*32
	  +  $tm->day_of_month)*24
	  +  $tm->hour        )*60
	  +  $tm->minute      )*60
	  +  $tm->second;
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
	my $fracday = int(($days - $intdays) * $NANOSECONDS_PER_DAY);

	return $t->plus_days($days)->plus_nanoseconds($fracday);
}
sub to_icq {
	my $tm = shift;

	if (ref $tm ne 'Time::Moment') {
		$tm = Time::Moment->from_string($tm);
	}

	my $t2 = Time::Moment->from_epoch(-2_209_161_600);

	$t2->delta_nanoseconds($tm) / $NANOSECONDS_PER_DAY;
}

# Java time is in milliseconds since the Unix epoch.
sub java {
	my $num = shift;
	_epoch2time($num, 1000);
}
sub to_java {
	my $tm = shift;
	_time2epoch($tm, 1000);
}

# Mozilla time is in microseconds since the Unix epoch.
sub mozilla {
	my $num = shift;
	_epoch2time($num, 1_000_000);
}
sub to_mozilla {
	my $tm = shift;
	_time2epoch($tm, 1_000_000);
}

#  OLE time is the number of days since 1899-12-30, which is
#  2,209,161,600 seconds before the Unix epoch.
sub ole {
	my $num = shift // return;

	my $hex = sprintf "%x", $num;
	my $d_days = unpack('d', pack('H*', $hex)) or return;

	return if $d_days eq '-nan';

	return icq $d_days;
}
sub to_ole {
	my $t = shift // return;

	my $icq = to_icq($t);

	my $hex = unpack('H*', pack('d', $icq)) or return;

	return "0x$hex";
}

# Symbian time is the number of microseconds since the year 0, which
# is 62,167,219,200 seconds before the Unix epoch.
sub symbian {
	my $num = shift;
	_epoch2time($num, 1_000_000, -62_167_219_200);
}
sub to_symbian {
	my $tm = shift;
	_time2epoch($tm, 1_000_000, -62_167_219_200);
}

# Unix time is the number of seconds since 1970-01-01.
sub unix {
	my $num = shift;
	_epoch2time($num);
}
sub to_unix {
	my $tm = shift;
	_time2epoch($tm);
}

# UUID version 1 time (RFC 4122) is the number of hectonanoseconds
# (100 ns) since 1582-10-15, which is 12,219,292,800 seconds before
# the Unix epoch.
sub uuid_v1 {
	my $num = shift;
	_epoch2time($num, 10_000_000, -12_219_292_800);
}

# Windows date time (e.g., .NET) is the number of hectonanoseconds
# (100 ns) since 0001-01-01, which is 62,135,596,800 seconds before
# the Unix epoch.
sub windows_date {
	my $num = shift;
	_epoch2time($num, 10_000_000, -62_135_596_800);
}
sub to_windows_date {
	my $tm = shift;
	_time2epoch($tm, 10_000_000, -62_135_596_800);
}

# Windows file time (e.g., NTFS) is the number of hectonanoseconds
# (100 ns) since 1601-01-01, which is 11,644,473,600 seconds before
# the Unix epoch.
sub windows_file {
	my $num = shift;
	_epoch2time($num, 10_000_000, -11_644_473_600);
}
sub to_windows_file {
	my $tm = shift;
	_time2epoch($tm, 10_000_000, -11_644_473_600);
}

	
sub _epoch2time {
	my $num = shift // return;
	my $q = shift // 1;
	my $s = shift // 0;

	return unless looks_like_number $num;

	my($z, $m) = Math::BigInt->new($num)->bdiv($q);
	my $r = ($m * 1e9)->bdiv($q);
	Time::Moment->from_epoch($z + $s, $r);
}

sub _time2epoch {
	my $t = shift // return;
	my $m = shift // 1;
	my $s = shift // 0;

	if (ref $t ne 'Time::Moment') {
		$t = Time::Moment->from_string($t);
	}
	
	my $bf = Math::BigFloat->new($t->nanosecond)->bdiv(1e9);
	int $m*($t->epoch + $bf - $s);
}

1;
