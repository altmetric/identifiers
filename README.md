# Identifiers [![Build Status](https://travis-ci.org/altmetric/identifiers.svg?branch=master)](https://travis-ci.org/altmetric/identifiers) [![Gem Version](https://badge.fury.io/rb/identifiers.svg)](https://badge.fury.io/rb/identifiers)

Collection of utilities related to the extraction, validation and normalization of various scholarly identifiers. The supported list is:

- [ADS Bibcodes](http://adsdoc.harvard.edu/abs_doc/help_pages/bibcodes.html)
- [arXiv IDs](https://arxiv.org/help/arxiv_identifier)
- [DOIs](https://www.doi.org/)
- [Handles](https://en.wikipedia.org/wiki/Handle_System)
- [ISBNs](https://en.wikipedia.org/wiki/International_Standard_Book_Number)
- [National Clinical Trial IDs](https://clinicaltrials.gov/)
- [PubMed IDs](http://www.ncbi.nlm.nih.gov/pubmed)
- [RePEc IDs](https://en.wikipedia.org/wiki/Research_Papers_in_Economics)
- [URNs](https://en.wikipedia.org/wiki/Uniform_Resource_Name)
- [ORCID identifiers](http://orcid.org/)

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'identifiers', '~> 0.4'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install identifiers

## Usage

```ruby
Identifiers::DOI.extract('example: 10.123/abcd.efghi')
# => ["10.123/abcd.efghi"]

Identifiers::DOI.extract('no DOIs here')
# => []

Identifiers::URN.new('urn:abc:123')
# => #<URN:0x007ff11c13d930 @urn="urn:abc:123", @nid="abc", @nss="123">
Identifiers::URN('urn:abc:123')
# => #<URN:0x007ff11c0ff568 @urn="urn:abc:123", @nid="abc", @nss="123">
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

But for some identifiers might have more. Check [their implementation](https://github.com/altmetric/identifiers/tree/master/lib/identifiers) to see all the methods available.

For `URN`s, please check the [URN gem documentation](https://github.com/altmetric/urn) to see all the available options.

### DOIs

DOI's are notoriously tricky to pin down in a regex, since the actual regex could feasibly be `10\.{\d}+/\S+` in order to match all possible DOIs.

The regular expression we use is taken from a [CrossRef article](http://blog.crossref.org/2015/08/doi-regular-expressions.html) describing a sane way of matching 74.4M of their 74.9M registered DOIs (as of 2015). Additionally, the library will seek out a portion of more unusual looking DOIs (predominately used by Wiley). This catches around 300k extra IDs. The blog post goes into extra regexs, however they'll add more false positives.

It should be noted that we do not make attempts to clean up the DOIs. You may well find punction at the end of the extracted DOI, or invalid Unicode characters. This will depend on the quality of the source you're scraping.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/altmetric/identifiers.

## PHP version

We also maintain [a version of this library for PHP](https://github.com/altmetric/php-identifiers).

## License

Copyright © 2016 Altmetric LLP

Distributed under the [MIT License](http://opensource.org/licenses/MIT).
