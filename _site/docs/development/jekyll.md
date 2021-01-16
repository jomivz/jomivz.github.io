## Contents

1. [Installation](#Installation)
1. [Testing](#Testing)

## Installation

[Sofwares required](https://jekyllrb.com/docs/installation/) for installation explained on the Jekyll website.

Jekyll runs with Ruby. Install Jekyll with the following command:

```bash
gem install jekyll bundler
sudo yum install g++
gem install rake
gem install listen -v 3.4.0
gem install jekyll-feed -v 0.13.0
gem install jekyll-seo-tag -v 2.6.1
gem install minima -v 2.5.1
```

```bash
gem install just-the-docs
```

## Testing

Run a localhost webserver with the following command:

```bash
bundle exec jekyll serve --watch
```
For shared directory in a VM or container, run
```bash
bundle exec jekyll serve --watch --force
```

