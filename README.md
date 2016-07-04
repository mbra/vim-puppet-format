# vim-puppet-format

Formats your puppet code with [puppet-lint](https://github.com/rodjek/puppet-lint) when you save a puppet file.
When using this, the following plugins are highly recommended:

 * [strict_indent](https://github.com/relud/puppet-lint-strict_indent-check)
 * [trailing_comma](https://github.com/voxpupuli/puppet-lint-trailing_comma-check/)
 * [trailing_newline](https://github.com/rodjek/puppet-lint-trailing_newline-check)

Install puppet-lint with your distro package or via `gem install`. The plugins are also installable via `gem` as:

  * puppet-lint-strict_indent-check
  * puppet-lint-trailing_comma-check
  * puppet-lint-trailing_newline-check

This should do the trick:
```
$ gem install --user-install puppet-lint puppet-lint-strict_indent-check puppet-lint-trailing_comma-check puppet-lint-trailing_newline-check
```
