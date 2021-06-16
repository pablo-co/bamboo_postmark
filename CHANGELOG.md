# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v1.0.0 - 2021-04-30

### Changes
* Change return of deliver/2 to work with Bamboo v2.0
* Require Bamboo 2.0.0 or above

## v0.7.0 - 2020-12-13

### Fixes/Enhancements

* Support inline attachments ([#34])

[#34]: https://github.com/pablo-co/bamboo_postmark/pull/34

## v0.6.1 - 2020-12-13

### Fixes/Enhancements

* Pass attachments as params to Postmark ([#31])

[#31]: https://github.com/pablo-co/bamboo_postmark/pull/31

## v0.6.0 - 2019-06-19

### New Additions

* Allow configuring API key with {:system, "ENVVAR"} ([#26])

[#26]: https://github.com/pablo-co/bamboo_postmark/pull/26

## v0.5.0 - 2019-02-11

### New Additions

* Make JSON library configurable ([#22])

[#22]: https://github.com/pablo-co/bamboo_postmark/pull/22

## v0.4.2 - 2018-01-23

### Fixes/Enhancements

* Relax bamboo and hackney library requirements ([#18])
* Fix bug when leaving default `template_model` value in `PostmarkHelper.template/3` ([#17])
* Fix code style issues and compiler warnings ([#16])

[#16]: https://github.com/pablo-co/bamboo_postmark/pull/16
[#17]: https://github.com/pablo-co/bamboo_postmark/pull/17
[#18]: https://github.com/pablo-co/bamboo_postmark/pull/18

## v0.4.1 - 2017-06-07

### Fixes/Enhancements

* Return body in response of PostmarkAdapter.deliver ([#14])

[#14]: https://github.com/pablo-co/bamboo_postmark/pull/14

## v0.4.0 - 2017-05-23

### New Additions

* Allow configuration of request options ([#12])

[#12]: https://github.com/pablo-co/bamboo_postmark/pull/12

## v0.3.0 - 2017-05-06

### New Additions

* Support passing custom params to Postmark ([#9])

### Fixes/Enhancements

* Fix Elixir 1.4 warnings and deprecations ([#7])

[#9]: https://github.com/pablo-co/bamboo_postmark/pull/9
[#7]: https://github.com/pablo-co/bamboo_postmark/pull/7

## v0.2.0 - 2016-12-29

### New Additions

* Add support for tagging emails ([#5])

### Fixes/Enhancements

* Relax Bamboo version from library dependencies ([#6])

[#5]: https://github.com/pablo-co/bamboo_postmark/pull/5
[#6]: https://github.com/pablo-co/bamboo_postmark/pull/6

## v0.1.0 - 2016-09-02

* Initial public release.
