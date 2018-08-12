def project = 'tyler-matheson/argus-aws'
def url = new URL("https://api.github.com/repos/${project}/contents/builds")
def builds = new groovy.json.JsonSlurper().parse(url.newReader())
builds.each {
    def buildName = it.name
    def jobName = "${project}-${buildName}".replaceAll('/','-')
    job(jobName) {
        scm {
            git("git://github.com/${project}/builds/${buildName}.git")
        }
    }
}