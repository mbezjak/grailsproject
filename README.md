# grailsproject
Provide information about a grails project.

[![Build Status](https://secure.travis-ci.org/mbezjak/grailsproject.png?branch=master)](http://travis-ci.org/mbezjak/grailsproject)

This project is still in development. When completed it will be capable of
showing:

 * project directory in ~/.grails
 * project/plugin name
 * project/plugin version
 * grails version
 * a list of dependent plugins (name and version)

Information will be printed in a way to allow easy command line processing
(using AWK or any other tool). Example:

    if [[ $(grailsproject grailsVersion) == 2.* ]]; then
      echo 'project is built with grails 2.x'
    else
      echo 'project is not built with grails 2.x'
    fi

## License
Project uses MIT license. Check LICENSE file for more info.
