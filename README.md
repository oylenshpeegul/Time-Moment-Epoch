# Epochs
Convert various epoch times to `Time::Moment` times in Perl.

For example, running this code

```perl
#!/usr/bin/env perl

use v5.20;
use warnings;
use Epochs;

say Epochs::unix(1234567890);

say Epochs::chrome(12879041490654321);
```

would give

```
2009-02-13T23:31:30Z
2009-02-13T23:31:30.654321Z
```

**Update:** Now there are functions in the other direction too! For example, running this

```perl
#!/usr/bin/env perl

use v5.22;
use warnings;
use Epochs;

say Epochs::to_unix('2009-02-13T23:31:30Z');

say Epochs::to_chrome('2009-02-13T23:31:30.654321Z');
```

gives

```
1234567890
12879041490654321
```


See [epochs](https://github.com/oylenshpeegul/epochs) for a similar
thing in Go.

## Contributors

[@noppers](https://github.com/noppers) originally worked out how to do the Google Calendar calculation.
