# generator-puppetskel [![NPM version][npm-image]][npm-url] [![Build Status][travis-image]][travis-url] [![Dependency Status][daviddm-image]][daviddm-url]
> Lays down a customized puppet testbed based on the puppet skeleton

## Installation

First, install [Yeoman](http://yeoman.io) and generator-puppetskel using [npm](https://www.npmjs.com/) (we assume you have pre-installed [node.js](https://nodejs.org/)).

```bash
npm install -g yo
npm install -g generator-puppetskel
```

Then generate your new project:

```bash
yo puppetskel
```

## Purpose

This module exists to simplify the creation of a useful puppet module testbed. It utilizes rspec-puppet for unit tests, and Beaker for acceptance tests. (I'm still working on Windows Beaker tests for now). This is to simplify the process of starting from scratch to build a Puppet module, and the testbed was derived from GarethR's [Puppet Module Skeleton](https://github.com/garethr/puppet-module-skeleton). I will add gradual improvements, but I hope this can be useful to anyone starting out with Puppet module creation.

### Testing

Unit tests:
```
bundle exec rake test
```

Acceptance on an OS:
```
bundle exec rake acceptance[centos6]
```


## Getting To Know Yeoman

Yeoman has a heart of gold. He&#39;s a person with feelings and opinions, but he&#39;s very easy to work with. If you think he&#39;s too opinionated, he can be easily convinced. Feel free to [learn more about him](http://yeoman.io/).

## License

 © [Josh Souza](development@pureinsomnia.com)


[npm-image]: https://badge.fury.io/js/generator-puppetskel.svg
[npm-url]: https://npmjs.org/package/generator-puppetskel
[travis-image]: https://travis-ci.org/joshsouza/generator-puppetskel.svg?branch=master
[travis-url]: https://travis-ci.org/joshsouza/generator-puppetskel
[daviddm-image]: https://david-dm.org/joshsouza/generator-puppetskel.svg?theme=shields.io
[daviddm-url]: https://david-dm.org/joshsouza/generator-puppetskel
