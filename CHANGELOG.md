<div align = "center">

# CHANGELOG

</div>

<div align = "justify">

All notable changes to this *PostgreSQL DB Management* project will be documented in this file. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project adheres to [`semver`](https://semver.org/) styling.

## Release Note(s)

The release notes are documented, the list of changes to each different release are documented. The `major.minor` are indicated
under `h3` tags, while the `patch` and other below identifiers are listed under `h4` and subsequent headlines. The legend for
changelogs are provided in the detail pane, while the version wise note is as available below.

<details>
<summary>Click Here to View Legend</summary>

<p><small>
<ul style = "list-style-type:circle">
  <li>✨ - <b>Major Feature</b> : something big that was not available before.</li>
  <li>🎉 - <b>Feature Enhancement</b> : a miscellaneous minor improvement of an existing feature.</li>
  <li>🛠️ - <b>Patch/Fix</b> : something that previously didn't work as documented should now work.</li>
  <li>🐛 - <b>Bug/Fix</b> : a bug in the code was resolved and documented.</li>
  <li>⚙️ - <b>Code Efficiency</b> : an existing feature now may not require as much computation or memory.</li>
  <li>💣 - <b>Code Refactoring</b> : a breakable change often associated with `major` version bump.</li>
</ul>
</small></p>

</details><br>

### `v1` Stable Release

We're pleased to announce that the PostgreSQL database management for macroeconomics data is made public  and the
first initial public release was made on 7th Feburary 2026 (the commit and source code is thus has an older timestamp).
The first release brings the following features.

#### v1.1.2 | 2026-04-18

Security fixes, docker file configuration and publication of tables are added into this release with minor changes and bug
fixes. This release has the following new features:

  * ✨ Added [`Dockerfile`](./Dockerfile) for faster testing and standalone isolation system development,
  * ⚙️ Added security checks to prevent data or security code leaks in the repository, and
  * 🐛 Other minor bug fixes and enhancements.

#### v1.1.1 | 2026-02-12

The releases on providing additional support and utility functions that can be used to integrate with external modules
giving additional capabilities.

  * 🎉 Added function to return data in a desired base for direct value conversion, and
  * 🎉 Added developer/administrator function for managing forex tables and get missing data information.

#### v1.1.0 | 2026-02-07

The release fixes minor bugs and enhancements for forward integration. The tables are further refined and made generic
thus allowing more robust controls.

  * ✨ Create a table to store foreign exchange rates from various different sources,
  * 🛠️ Minor bug fixes and improvements for currency and country tables, and
  * 🎉 Create database initialization statement can be integrated with docker for testing.

#### v1.0.0 | 2026-02-07

The initial release is designed to be simple, effective and create a backbone for data-driven analysis across multiple
geographic levels (country, state, etc.) and bring seamless integration with any models.

  * ✨ A set of table to store continent, region, country, state and city information, and
  * ✨ A set of table to store currency information like name, minor unit name, decimal places, etc.

</div>
