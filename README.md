# Perfect 
![Perfect logo](https://www.perfect.org/images/icon_128x128.png) 

[![Swift 2.0](https://img.shields.io/badge/Swift-2.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms OS X | iOS | tvos](https://img.shields.io/badge/Platforms-OS%20X%20%7C%20iOS-lightgray.svg?style=flat)](https://developer.apple.com/swift/)
[![License AGPL](https://img.shields.io/badge/License-AGPL-lightgrey.svg?style=flat)](http://www.perfect.org/AGPL_3_0_With_Perfect_Additional_Terms.txt)
[![Docs](https://img.shields.io/badge/docs-83%-yellow.svg?style=flat)](http://www.perfect.org/docs/)
[![Issues](https://img.shields.io/github/issues-raw/PerfectlySoft/Perfect.svg?style=flat)](https://github.com/PerfectlySoft/Perfect/issues)
[![Donate](https://img.shields.io/badge/Donate-PayPal-blue.svg?style=flat)](https://paypal.me/perfectlysoft)
[![Twitter](https://img.shields.io/badge/Twitter-@PerfectlySoft-brightgreen.svg?style=flat)](http://twitter.com/PerfectlySoft)
[![Join the chat at https://gitter.im/PerfectlySoft/Perfect](https://img.shields.io/badge/Gitter-Join%20Chat-brightgreen.svg)](https://gitter.im/PerfectlySoft/Perfect?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Perfect is an application server which provides a framework for developing web and other REST services in the Swift programming language. Its primary focus is on facilitating mobile apps which require backend server software. It enables you to use one language for both front and back ends.

Perfect operates using either its own stand-alone HTTP server or through FastCGI with Apache 2.4. It provides a system for loading your own Swift based modules at startup and for interfacing those modules with its built-in mustache template processing system.


Perfect consists of the following components:

* [PerfectLib](PerfectLib/#perfectlib) - Framework components and utilities for client and server.
	* [PerfectLib Reference](http://www.perfect.org/docs/)
	* OS X / Linux
	* iOS
* [Perfect Server](PerfectServer/#perfectserver) - Backend server supporting FastCGI or stand-alone HTTP.
	* Perfect Server FastCGI - Server process which accepts connections over FastCGI.
	* Perfect Server HTTP - Stand-alone HTTP server.
	* Perfect Server HTTP App - Development focused stand-alone HTTP server OS X app.
* Connectors - Server-side connectivity.
	* [mod_perfect](Connectors/mod_perfect/#mod_perfect) - FastCGI connectivity for Apache 2.4.
	* [MySQL](Connectors/MySQL/#mysql) - Provides connectivity for MySQL databases.
	* [PostgreSQL](Connectors/PostgreSQL/#postgresql) - Provides connectivity for PostgreSQL databases.
	* [MongoDB](Connectors/MongoDB/#mongodb) - Provides connectivity for MongoDB databases (*in progress*).
* [Examples](Examples/#examples) - A set of examples which show how to utilize Perfect.
	* Mobile iOS Examples
	* Web Site Examples
	* Game Examples (coming soon!)

## Getting Started
Check the [README](Examples/#examples) in the Examples directory for further instructions.

## More Information
For more information on the Perfect project, please visit [perfect.org](http://perfect.org).
