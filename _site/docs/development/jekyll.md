## Contents

1. [Installation](#Installation)
2. [Testing](#Testing)

## Installation

Check [sofwares required](https://jekyllrb.com/docs/installation/) for installation on the Jekyll offical website.

Here are the required packages installed, last tested on 2021/01/25 :
```
sudo dnf install ruby ruby-devel openssl-devel redhat-rpm-config @development-tools
```

To install Jekyll locally, copy/paste the following commands:

```bash
gem install jekyll bundler \
sudo yum install g++ \
gem install rake \
gem install listen -v 3.4.0 \
gem install jekyll-feed -v 0.13.0 \
gem install jekyll-seo-tag -v 2.6.1 \
gem install minima -v 2.5.1 \
gem install concurrent-ruby -v 1.1.7 \
gem install rexml -v 3.2.4
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

