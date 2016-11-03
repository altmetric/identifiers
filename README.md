# Identifiers

Collection of utilities related to the extraction, validation and normalization of various scholarly identifiers. The supported list is:
- [ADS Bibcodes](http://adsdoc.harvard.edu/abs_doc/help_pages/bibcodes.html)
- [arXiv](https://arxiv.org/help/arxiv_identifier)
- [DOI](https://www.doi.org/)
- [Handle](https://en.wikipedia.org/wiki/Handle_System)
- [ISBN](https://en.wikipedia.org/wiki/International_Standard_Book_Number)
- [National Clinic Trials](https://clinicaltrials.gov/)
- [PubMed](http://www.ncbi.nlm.nih.gov/pubmed)
- [RePEc](https://en.wikipedia.org/wiki/Research_Papers_in_Economics)
- [URN](https://en.wikipedia.org/wiki/Uniform_Resource_Name)
- [ORCID](http://orcid.org/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'identifiers', '~> 0.2'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install identifiers

## Usage

```ruby
Identifiers::DOI.extract('example: 10.123/abcd.efghi')

Identifiers::URN.new('urn:abc:123')
Identifiers::URN('urn:abc:123')
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

But for some identifiers might have more. Check their implementation to see all the methods available.

For `URN`s, please check the [URN gem documentation](https://github.com/altmetric/urn) to see all the available options.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/altmetric/identifiers.

## License

Copyright © 2016 Altmetric LLP

Distributed under the [MIT License](http://opensource.org/licenses/MIT).
