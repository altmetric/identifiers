# Change Log
All notable changes to this project will be documented in this file. This
project adheres to [Semantic Versioning](http://semver.org/).

## [0.14.0] - 2024-07-30
### Added
- Added optional prefixes argument to ISBNs extraction.
  If passed `.extract` will only match series of numbers that are preceded by any of the passed prefixes

## [0.13.0] - 2019-09-04
### Added
- Added new mode to the DOI extraction, so that it doesn't strip trailing
  periods when in `strict` mode

## [0.12.1] - 2018-04-09
### Fixed
- Restored support for extracting hyphenated ISBN-10s with registration group
  identifiers longer than one digit

## [0.12.0] - 2018-04-06
### Added
- Added support for extracting more old Wiley DOIs

### Changed
- Performance improvements when extracting DOIs with trailing punctuation

## [0.11.0] - 2018-03-12
### Fixed
- Stricter ISBN extraction: consistent hyphenation (#27) and correct number of groups (#28)
- Prevent stack overflow when extracting DOIS (#25)

## [0.10.0] - 2017-12-20
### Added
- Extract PubMed IDs from URLs (e.g https://www.ncbi.nlm.nih.gov/pubmed/123456) and URIs with schemes `pmid:` and `info:pmid`

## [0.9.1] - 2017-08-01
### Fixed
- Don't extract duplicate ISBN-10s from within ISBN-13s

## [0.9.0] - 2017-07-31
### Added
- Support extraction of multiple ISBNs separated by a single space
- Support passing nil to any of the extract methods

## [0.8.1] - 2017-04-10
### Fixed
- Fixed extraction of multiple DOIs separated by Unicode whitespace

## [0.8.0] - 2017-04-10
### Added
- Added support for ISBNs with digits separated by Unicode whitespace and dashes

## [0.7.0] - 2017-04-10
### Added
- Added support for cleaning trailing punctuation from DOIs that also end in punctuation

## [0.6.0] - 2017-04-08
### Added
- Added support for valid DOIs ending in punctuation

## [0.5.0] - 2017-01-27
### Added
- Added support for ISBN-As when extracting DOIs and ISBNs

## [0.4.0] - 2017-01-23
### Changed
- Extract ISBNs separated by spaces as well as hyphens

## [0.3.1] - 2016-12-06
### Fixed
- Fix ISBN-10 to 13 conversion when check digit is 10

## [0.3.0] - 2016-11-03
### Added
- Support for ORCID

## [0.2.0] - 2016-11-01
### Changed
- Strip leading 0s from Pubmed IDs. 0 is no longer a valid Pubmed ID

## [0.1.0] - 2016-10-21
### Added
- Initial release

[0.1.0]: https://github.com/altmetric/identifiers/releases/tag/v0.1.0
[0.2.0]: https://github.com/altmetric/identifiers/releases/tag/v0.2.0
[0.3.0]: https://github.com/altmetric/identifiers/releases/tag/v0.2.0
[0.3.1]: https://github.com/altmetric/identifiers/releases/tag/v0.3.1
[0.4.0]: https://github.com/altmetric/identifiers/releases/tag/v0.4.0
[0.5.0]: https://github.com/altmetric/identifiers/releases/tag/v0.5.0
[0.6.0]: https://github.com/altmetric/identifiers/releases/tag/v0.6.0
[0.7.0]: https://github.com/altmetric/identifiers/releases/tag/v0.7.0
[0.8.0]: https://github.com/altmetric/identifiers/releases/tag/v0.8.0
[0.8.1]: https://github.com/altmetric/identifiers/releases/tag/v0.8.1
[0.9.0]: https://github.com/altmetric/identifiers/releases/tag/v0.9.0
[0.9.1]: https://github.com/altmetric/identifiers/releases/tag/v0.9.1
[0.10.0]: https://github.com/altmetric/identifiers/releases/tag/v0.10.0
[0.11.0]: https://github.com/altmetric/identifiers/releases/tag/v0.11.0
[0.12.0]: https://github.com/altmetric/identifiers/releases/tag/v0.12.0
[0.12.1]: https://github.com/altmetric/identifiers/releases/tag/v0.12.1
[0.13.0]: https://github.com/altmetric/identifiers/releases/tag/v0.13.0
