
use strict;
use warnings;
use Epochs;
use Test::Most;

no warnings 'portable';

my @tests = (
	{
		sub => 'chrome',
		obs => 'foo',
		exp => undef,
	},

	{
		sub => 'chrome',
		obs => 12879041490000000,
		exp => '2009-02-13T23:31:30Z',
	},

	{
		sub => 'chrome',
		obs => 12912187816559001,
		exp => '2010-03-04T14:50:16.559001Z',
	},
	{
		sub => 'to_chrome',
		obs => '2010-03-04T14:50:16.559001Z',
		exp => 12912187816559001,
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
		sub => 'icq',
		obs => 41056.2752083333,
		exp => '2012-05-27T06:36:17.999997418Z',
	},
	{
		sub => 'icq',
		obs => 41056.2967361111,
		exp => '2012-05-27T07:07:17.999999080Z',
	},
	{
		sub => 'to_icq',
		obs => '2012-04-01T00:00:00Z',
		exp => 41_000,
	},
	{
		sub => 'to_icq',
		obs => '2012-05-27T07:07:17.999999080Z',
		exp => 41056.2967361111,
	},

	{
		sub => 'java',
		obs => 1234567890000,
		exp => '2009-02-13T23:31:30Z',
	},
	{
		sub => 'java',
		obs => 1283002533751,
		exp => '2010-08-28T13:35:33.751Z',
	},
	{
		sub => 'to_java',
		obs => '2010-08-28T13:35:33.751Z',
		exp => 1283002533751,
	},

	{
		sub => 'mozilla',
		obs => 1234567890000000,
		exp => '2009-02-13T23:31:30Z',
	},
	{
		sub => 'to_mozilla',
		obs => '2009-02-13T23:31:30Z',
		exp => 1234567890000000,
	},

	{
		sub => 'ole',
		obs => 0xdedddd5d3f76e340,
		exp => '2009-02-13T23:31:30.000000083Z',
	},
	{
		sub => 'ole',
		obs => 0x8ad371b4bcd2e340,
		exp => '2011-02-23T21:31:43.127000061Z',
	},
	{
		sub => 'to_ole',
		obs => '2011-02-23T21:31:43.127000061Z',
		exp => '0x8ad371b4bcd2e340',
	},

	{
		sub => 'symbian',
		obs => 63401787090000000,
		exp => '2009-02-13T23:31:30Z',
	},
	{
		sub => 'to_symbian',
		obs => '2009-02-13T23:31:30Z',
		exp => 63401787090000000,
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
		sub => 'windows_date',
		obs => 633701646900000000,
		exp => '2009-02-13T23:31:30Z',
	},
	{
		sub => 'windows_date',
		obs => 634496538123456789,
		exp => '2011-08-22T23:50:12.345678900Z',
	},
	{
		sub => 'to_windows_date',
		obs => '2011-08-22T23:50:12.345678900Z',
		exp => 634496538123456789,
	},

	{
		sub => 'windows_file',
		obs => 128790414900000000,
		exp => '2009-02-13T23:31:30Z',
	},
	{
		sub => 'windows_file',
		obs => 0x1cabbaa00ca9000,
		exp => '2010-03-04T14:50:16.559001600Z',
	},
	{
		sub => 'to_windows_file',
		obs => '2010-03-04T14:50:16.559001600Z',
		exp => 0x1cabbaa00ca9000,
	},

);

for my $t (@tests) {
	no strict 'refs';
	no warnings 'uninitialized';
	my $obs = "Epochs::$t->{sub}"->($t->{obs});
	is $obs, $t->{exp}, "$t->{sub}($t->{obs}) => $t->{exp}";
}

done_testing;
