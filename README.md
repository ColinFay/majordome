
<!-- README.md is generated from README.Rmd. Please edit that file -->

\[EXPERIMENTAL - DO NOT USE IN PRODUCTION\]

# majordome

The goal of `{majordome}` is to provide an interface from R that allows
to manage remote Connect and RStudio Package Manger session.

## Installation

You can install the released version of majordome from GitHub.

``` r
remotes::install_github("Thinkr-open/majordome")
```

## Usage

`{majordome}` has two objects: `Connect` & `RSPM`. Both allows to
initialize a ssh connection to a remote server with one of the service
listed above.

The `new()` method from both these object takes the name of the host
(`user@IP`), `keyfile` & `verbose` which are passed to
`ssh::ssh_connect()`, a service (“systemctl” or “upstart”, with default
to “systemctl”), and `with_sudo`, which indicate if the commands in the
session should be passed as `sudo cmd` (default is TRUE).

``` r
sess <- Connect$new("root@IP")
```

### methods

Once the object is created, you have access to several methods:

  - `cat_*` (cat\_access\_log, cat\_config\_file, cat\_var\_log) go on
    the server and run a `cat` on these files
  - `status`, `start`, `restart`, `reload`, `stop`, `disable`, `enable`
    run `service * product` (for example `systemctl start
    rstudio-connect`) on the server.
  - `dl_config_file` / `upload_config_file` download / upload a local
    copy of the config file from and to the server.

## CoC

Please note that the ’majordome’project is released with a [Contributor
Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project,
you agree to abide by its terms.
