## Unreleased

### Changes
* Change return of deliver/2 to work with Bamboo v2.0
* Require Bamboo 2.0.0 or above

## 0.7.0

### Fixes/Enhancements

* Support inline attachments ([#34])

[#34]: https://github.com/pablo-co/bamboo_postmark/pull/34

## 0.6.1

### Fixes/Enhancements

* Pass attachments as params to Postmark ([#31])

[#31]: https://github.com/pablo-co/bamboo_postmark/pull/31

## 0.6.0

### New Additions

* Allow configuring API key with {:system, "ENVVAR"} ([#26])

[#26]: https://github.com/pablo-co/bamboo_postmark/pull/26

## 0.5.0

### New Additions

* Make JSON library configurable ([#22])

[#22]: https://github.com/pablo-co/bamboo_postmark/pull/22

## 0.4.2

### Fixes/Enhancements

* Relax bamboo and hackney library requirements ([#18])
* Fix bug when leaving default `template_model` value in `PostmarkHelper.template/3` ([#17])
* Fix code style issues and compiler warnings ([#16])

[#16]: https://github.com/pablo-co/bamboo_postmark/pull/16
[#17]: https://github.com/pablo-co/bamboo_postmark/pull/17
[#18]: https://github.com/pablo-co/bamboo_postmark/pull/18

## 0.4.1

### Fixes/Enhancements

* Return body in response of PostmarkAdapter.deliver ([#14])

[#14]: https://github.com/pablo-co/bamboo_postmark/pull/14

## 0.4.0

### New Additions

* Allow configuration of request options ([#12])

[#12]: https://github.com/pablo-co/bamboo_postmark/pull/12

## 0.3.0

### New Additions

* Support passing custom params to Postmark ([#9])

### Fixes/Enhancements

* Fix Elixir 1.4 warnings and deprecations ([#7])

[#9]: https://github.com/pablo-co/bamboo_postmark/pull/9
[#7]: https://github.com/pablo-co/bamboo_postmark/pull/7

## 0.2.0

### New Additions

* Add support for tagging emails ([#5])

### Fixes/Enhancements

* Relax Bamboo version from library dependencies ([#6])

[#5]: https://github.com/pablo-co/bamboo_postmark/pull/5
[#6]: https://github.com/pablo-co/bamboo_postmark/pull/6
