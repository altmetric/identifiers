# Identifiers [![Gem Version](https://badge.fury.io/rb/identifiers.svg)](https://badge.fury.io/rb/identifiers)

Collection of utilities related to the extraction, validation and normalization of various scholarly identifiers. The supported list is:

- [ADS Bibcodes](http://adsdoc.harvard.edu/abs_doc/help_pages/bibcodes.html)
- [arXiv IDs](https://arxiv.org/help/arxiv_identifier)
- [DOIs](https://www.doi.org/) (including [ISBN-As](https://www.doi.org/factsheets/ISBN-A.html))
- [Handles](https://en.wikipedia.org/wiki/Handle_System)
- [ISBNs](https://en.wikipedia.org/wiki/International_Standard_Book_Number)
- [National Clinical Trial IDs](https://clinicaltrials.gov/)
- [PubMed IDs](http://www.ncbi.nlm.nih.gov/pubmed)
- [RePEc IDs](https://en.wikipedia.org/wiki/Research_Papers_in_Economics)
- [URNs](https://en.wikipedia.org/wiki/Uniform_Resource_Name)
- [ORCID identifiers](http://orcid.org/)

**Supported Ruby versions**: >= 2.7

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'identifiers', '~> 0.12'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install identifiers

## Usage

```ruby
Identifiers::DOI.extract('example: 10.1234/5678.ABC')
# => ["10.1234/5678.abc"]

Identifiers::DOI.extract('no DOIs here')
# => []

Identifiers::URN.new('urn:abc:123')
# => #<URN:0x007ff11c13d930 @urn="urn:abc:123", @nid="abc", @nss="123">

Identifiers::URN('urn:abc:123')
# => #<URN:0x007ff11c0ff568 @urn="urn:abc:123", @nid="abc", @nss="123">
```

A small percentage of DOIs end in trailing `.`. However, having trailing periods
being returned by the default extraction method would possibly return quite a few
false positives.
`DOI.extract` accepts a `strict` option, which can be set to true if we prefer to
return DOIs ending in `.`. By default, this option is set to `false`, which strips
any trailing `.`:

```ruby
Identifiers::DOI.extract('example: 10.1234/5678.abc.', strict: true)
# => ["10.1234/5678.abc."]

Identifiers::DOI.extract('example: 10.1234/5678.abc.')
# => ["10.1234/5678.abc"]
```

## By identifier

`.extract` is a common method that works across all the supported identifiers.

```ruby
Identifiers::AdsBibcode.extract('')
Identifiers::ArxivId.extract('')
Identifiers::DOI.extract('')
Identifiers::Handle.extract('')
Identifiers::ISBN.extract('')
Identifiers::NationalClinicalTrialId.extract('')
Identifiers::ORCID.extract('')
Identifiers::PubmedId.extract('')
Identifiers::RepecId.extract('')
Identifiers::URN.extract('')
```

For `ISBN`s `.extract`, you can pass an array of prefixes as an optional parameter when you want to exclude matches that are not preceded by those prefixes (it is case insensitive and ignores ':' and extra whitespaces):

```ruby
Identifiers::ISBN.extract(
  "IsBN:9789992158104  \n isbn-10 9789971502102 \n ISBN-13: 9789604250592 \n 9788090273412",
  ["ISBN", "ISBN-10"]
)
# => ["9789992158104", "9789971502102"]
```


But for some identifiers might have more. Check [their implementation](https://github.com/altmetric/identifiers/tree/master/lib/identifiers) to see all the methods available.

For `URN`s, please check the [URN gem documentation](https://github.com/altmetric/urn) to see all the available options.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/altmetric/identifiers.

## Contributions

* Thanks to [Tom Stuart](https://github.com/tomstuart) for [cleaning up the ISBN check digit code](https://github.com/altmetric/identifiers/pull/10).

## PHP version

We also maintain [a version of this library for PHP](https://github.com/altmetric/php-identifiers).

## License

Copyright © 2016-2024 Altmetric LLP

Distributed under the [MIT License](http://opensource.org/licenses/MIT).
