grails.project.dependency.resolution = {
    inherits 'global'
    log 'warn'

    repositories {
        grailsPlugins()
        grailsHome()
        grailsCentral()
    }

    plugins {
        build   ':codenarc:0.17'

        test    'org.spockframework:spock-core:0.5-groovy-1.8', {
            export = false
        }

        compile(':hibernate:1.3.7') {
            excludes 'javassist'
        }
        compile ':tomcat:1.3.7'
        compile ':quartz:0.4.2'

        runtime ':rollback-on-exception:0.1'
    }

}
