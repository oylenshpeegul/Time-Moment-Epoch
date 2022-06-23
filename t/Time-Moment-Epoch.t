
use strict;
use warnings;
use Math::Int64 qw(int64 :native_if_available);
use Time::Moment::Epoch;
use Test::Most;

my @tests = (

	{
		sub => 'apfs',
		obs => int64('1234567890000000000'),
		exp => '2009-02-13T23:31:30Z',
	},
	{
		sub => 'to_apfs',
		obs => '2009-02-13T23:31:30Z',
		exp => int64('1234567890000000000'),
	},

	{
		sub => 'chrome',
		obs => 'foo',
		exp => undef,
	},

	{
		sub => 'chrome',
		obs => int64('12879041490000000'),
		exp => '2009-02-13T23:31:30Z',
	},

	{
		sub => 'chrome',
		obs => int64('12912187816559001'),
		exp => '2010-03-04T14:50:16.559001Z',
	},
	{
		sub => 'to_chrome',
		obs => '2010-03-04T14:50:16.559001Z',
		exp => int64('12912187816559001'),
	},

	{
		sub => 'cocoa',
		obs => 256260690,
		exp => '2009-02-13T23:31:30Z',
	},
	{
		sub => 'cocoa',
		obs => 314238233,
		exp => '2010-12-17T00:23:53Z',
	},
	{
		sub => 'to_cocoa',
		obs => '2010-12-17T00:23:53Z',
		exp => 314238233,
	},

	{
		sub => 'dos',
		obs => 1211730978,
		exp => '2016-01-25T17:33:04Z',
	},
	{
		sub => 'to_dos',
		obs => '2016-01-25T17:33:04Z',
		exp => 1211730978,
	},

	{
		sub => 'google_calendar',
		obs => 1297899090,
		exp => '2009-02-13T23:31:30Z',
	},
	{
		sub => 'to_google_calendar',
		obs => '2009-02-13T23:31:30Z',
		exp => 1297899090,
	},

	{
		sub => 'icq',
		obs => 0,
		exp => '1899-12-30T00:00:00Z',
	},
	{
		sub => 'icq',
		obs => 41_000,
		exp => '2012-04-01T00:00:00Z',
	},
	{
		sub => 'to_icq',
		obs => '2012-04-01T00:00:00Z',
		exp => 41_000,
	},
        # These values are different for longdouble builds.
        #   https://rt.cpan.org/Public/Bug/Display.html?id=131731
        # I'm not sure what to do about that.
        #
	# {
	# 	sub => 'icq',
	# 	obs => 41056.2752083333,
	# 	exp => '2012-05-27T06:36:17.999997418Z',
	# },
	# {
	# 	sub => 'icq',
	# 	obs => 41056.2967361111,
	# 	exp => '2012-05-27T07:07:17.999999080Z',
	# },
	# {
	# 	sub => 'to_icq',
	# 	obs => '2012-05-27T07:07:17.999999080Z',
	# 	exp => 41056.2967361111,
	# },

	{
		sub => 'java',
		obs => int64('1234567890000'),
		exp => '2009-02-13T23:31:30Z',
	},
	{
		sub => 'java',
		obs => int64('1283002533751'),
		exp => '2010-08-28T13:35:33.751Z',
	},
	{
		sub => 'to_java',
		obs => '2010-08-28T13:35:33.751Z',
		exp => int64('1283002533751'),
	},

	{
		sub => 'mozilla',
		obs => int64('1234567890000000'),
		exp => '2009-02-13T23:31:30Z',
	},
	{
		sub => 'to_mozilla',
		obs => '2009-02-13T23:31:30Z',
		exp => int64('1234567890000000'),
	},

	{
		sub => 'ole',
		obs => pack('H*', 'dedddd5d3f76e340'),
		exp => '2009-02-13T23:31:30.000000083Z',
	},
	{
		sub => 'ole',
		obs => pack('H*', '8ad371b4bcd2e340'),
		exp => '2011-02-23T21:31:43.127000061Z',
	},
	{
		sub => 'to_ole',
		obs => '2011-02-23T21:31:43.127000061Z',
		exp => pack('H*', '8ad371b4bcd2e340'),
	},

	{
		sub => 'symbian',
		obs => int64('63401787090000000'),
		exp => '2009-02-13T23:31:30Z',
	},
	{
		sub => 'to_symbian',
		obs => '2009-02-13T23:31:30Z',
		exp => int64('63401787090000000'),
	},

	{
		sub => 'unix',
		obs => 1234567890,
		exp => '2009-02-13T23:31:30Z',
	},
	{
		sub => 'unix',
		obs => -1234567890,
		exp => '1930-11-18T00:28:30Z',
	},
	{
		sub => 'to_unix',
		obs => '2009-02-13T23:31:30Z',
		exp => 1234567890,
	},
	{
		sub => 'to_unix',
		obs => '1930-11-18T00:28:30Z',
		exp => -1234567890,
	},

	{
		sub => 'uuid_v1',
		obs => int64('134538606900000000'),
		exp => '2009-02-13T23:31:30Z',
	},
	{
		sub => 'uuid_v1',
		obs => int64('134113006617397493'),
		exp => '2007-10-10T09:17:41.739749300Z',
	},
	{
		sub => 'to_uuid_v1',
		obs => '2009-02-13T23:31:30Z',
		exp => int64('134538606900000000'),
	},
	{
		sub => 'to_uuid_v1',
		obs => '2007-10-10T09:17:41.739749300Z',
		exp => int64('134113006617397493'),
	},

	{
		sub => 'windows_date',
		obs => int64('633701646900000000'),
		exp => '2009-02-13T23:31:30Z',
	},
	{
		sub => 'windows_date',
		obs => int64('634496538123456789'),
		exp => '2011-08-22T23:50:12.345678900Z',
	},
	{
		sub => 'to_windows_date',
		obs => '2011-08-22T23:50:12.345678900Z',
		exp => int64('634496538123456789'),
	},

	{
		sub => 'windows_file',
		obs => int64('128790414900000000'),
		exp => '2009-02-13T23:31:30Z',
	},
	{
		sub => 'windows_file',
		obs => int64('129121878165590016'),
		exp => '2010-03-04T14:50:16.559001600Z',
	},
	{
		sub => 'to_windows_file',
		obs => '2010-03-04T14:50:16.559001600Z',
		exp => int64('129121878165590016'),
	},
	{
		sub => 'windows_system',
		obs => 'd907020005000d0017001f001e000000',
		exp => '2009-02-13T23:31:30Z',
	},
	{
		sub => 'to_windows_system',
		obs => '2009-02-13T23:31:30Z',
		exp => 'd907020005000d0017001f001e000000',
	},

);

for my $t (@tests) {
	no strict 'refs';
	no warnings 'uninitialized';
	my $obs = "Time::Moment::Epoch::$t->{sub}"->($t->{obs});
	is $obs, $t->{exp}, "$t->{sub}($t->{obs}) => $t->{exp}";
}

done_testing;
