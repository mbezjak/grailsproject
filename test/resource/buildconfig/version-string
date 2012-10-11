grails.project.dependency.resolution = {
    inherits 'global'
    log 'warn'

    repositories {
        grailsPlugins()
        grailsHome()
        grailsCentral()
    }

    plugins {
        build   ':codenarc:latest.integration'

        compile ':hibernate:$grailsVersion'
        compile ':tomcat:$grailsVersion'
        compile ':quartz:0.4.2'

        runtime ':rollback-on-exception:latest.release'
    }

}
