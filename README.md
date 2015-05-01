# _euthanize_

Some memory caching systems, such as [_memcached_][memcached], employ a
Least-Recently Used (LRU) algorithm for sweeping the cache. That is to say, when
the overall size of the cache is at its limit, the items that have been accessed
the longest time ago are removed from the cache in order to make room for new
items. _euthanize_ is an implementation of LRU for **filesystem-based** caching
systems.

Aside from caching systems, you may also find _euthanize_ useful for keeping
noncritical data (such as personal download folders) to a manageable size.

## Installation

Use Make to install _euthanize_. This automated method first runs a suite of
tests in order to determine whether your operating system is supported.

    $ make install

## Usage

Supply a `--help` or `-h` option in order to display help.

    $ euthanize
    Delete least-recently-used files in a directory.

    Usage:

    euthanize --size SIZE PATH
    euthanize  -s    SIZE PATH

      Deletes files in PATH only if PATH is estimated to exceed SIZE, which is
      interpreted as a number of 512-byte blocks. If SIZE is followed by a scale
      indicator, then it is scaled as:

        kb  kilobytes (1024 bytes)
        mb  megabytes (1024 kilobytes)
        gb  gigabytes (1024 megabytes)
        tb  terabytes (1024 gigabytes)
        pb  petabytes (1024 terabytes)

      PATH must be a directory, a symbolic link, or a regular file.

Trim a directory _foo_ down to 1 MB in size.

    $ euthanize --size 1mb foo

## Contributing

1. [Fork][fork-euthanize] the official repository.
2. Create your feature branch: `git checkout -b my-new-feature`.
3. Commit your changes: `git commit -am 'Add some feature'`.
4. Push to the branch: `git push origin my-new-feature`.
5. [Create][compare-euthanize-branches] a new pull request.

## License

Released under the [MIT License][MIT-License].

[memcached]:                  http://www.memcached.org
[fork-euthanize]:             https://github.com/njonsson/euthanize/fork                   "Fork the official repository of ‘euthanize’"
[compare-euthanize-branches]: https://github.com/njonsson/euthanize/compare                "Compare branches of ‘euthanize’ repositories"
[MIT-License]:                https://github.com/njonsson/euthanize/blob/master/License.md "MIT License claim for ‘euthanize’"
