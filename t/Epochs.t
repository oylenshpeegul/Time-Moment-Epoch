
use strict;
use warnings;
use Epochs;
use Test::Most;

my @tests = (
	{
		sub => 'chrome',
		num => 'foo',
		exp => undef,
	},

	{
		sub => 'chrome',
		num => 12879041490000000,
		exp => '2009-02-13T23:31:30Z',
	},

	{
		sub => 'chrome',
		num => 12912187816559001,
		exp => '2010-03-04T14:50:16.559001Z',
	},

	{
		sub => 'cocoa',
		num => 256260690,
		exp => '2009-02-13T23:31:30Z',
	},
	{
		sub => 'cocoa',
		num => 314238233,
		exp => '2010-12-17T00:23:53Z',
	},

	{
		sub => 'google_calendar',
		num => 1297899090,
		exp => '2009-02-13T23:31:30Z',
	},

	{
		sub => 'icq',
		num => 0,
		exp => '1899-12-30T00:00:00Z',
	},
	{
		sub => 'icq',
		num => 41_000,
		exp => '2012-04-01T00:00:00Z',
	},
	{
		sub => 'icq',
		num => 41056.2752083333,
		exp => '2012-05-27T06:36:17.999997418Z',
	},
	{
		sub => 'icq',
		num => 41056.2967361111,
		exp => '2012-05-27T07:07:17.999999080Z',
	},

	{
		sub => 'java',
		num => 1234567890000,
		exp => '2009-02-13T23:31:30Z',
	},
	{
		sub => 'java',
		num => 1283002533751,
		exp => '2010-08-28T13:35:33.751Z',
	},

	{
		sub => 'mozilla',
		num => 1234567890000000,
		exp => '2009-02-13T23:31:30Z',
	},

	{
		sub => 'ole',
		num => 0xdedddd5d3f76e340,
		exp => '2009-02-13T23:31:30.000000083Z',
	},
	{
		sub => 'ole',
		num => 0x8ad371b4bcd2e340,
		exp => '2011-02-23T21:31:43.127000061Z',
	},

	{
		sub => 'symbian',
		num => 63401787090000000,
		exp => '2009-02-13T23:31:30Z',
	},

	{
		sub => 'unix',
		num => 1234567890,
		exp => '2009-02-13T23:31:30Z',
	},
	{
		sub => 'unix',
		num => -1234567890,
		exp => '1930-11-18T00:28:30Z',
	},

	{
		sub => 'windows_date',
		num => 633701646900000000,
		exp => '2009-02-13T23:31:30Z',
	},
	{
		sub => 'windows_date',
		num => 634496538123456789,
		exp => '2011-08-22T23:50:12.345678900Z',
	},

	{
		sub => 'windows_file',
		num => 128790414900000000,
		exp => '2009-02-13T23:31:30Z',
	},
	{
		sub => 'windows_file',
		num => 0x1cabbaa00ca9000,
		exp => '2010-03-04T14:50:16.559001600Z',
	},

);

for my $t (@tests) {
	no strict 'refs';
	my $obs = "Epochs::$t->{sub}"->($t->{num});
	is $obs, $t->{exp}, "$t->{sub}($t->{num}) => $t->{exp}";
}

done_testing;
