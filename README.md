# Epochs
Convert various epoch times to `Time::Moment` times in Perl.

For example, running this code

```perl
#!/usr/bin/env perl

use v5.20;
use warnings;
use Epochs;

my $unix = Epochs::unix(1234567890);
say $unix;

my $chrome = Epochs::chrome(12879041490654321);
say $chrome;
```

would give

```
2009-02-13T23:31:30Z
2009-02-13T23:31:30.654321Z
```

See [epochs](https://github.com/oylenshpeegul/epochs) for a similar
thing in Go.

