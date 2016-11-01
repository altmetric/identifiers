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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/altmetric/identifiers.

## License

Copyright © 2016 Altmetric LLP

Distributed under the [MIT License](http://opensource.org/licenses/MIT).
