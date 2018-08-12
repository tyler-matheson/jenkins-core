def account = 'tyler-matheson'
def url = new URL("https://api.github.com/users/${account}/repos")
def repos = new groovy.json.JsonSlurper().parse(url.newReader())
repos.each {
    def buildName = it.name
    def jobName = "${account}.${buildName}".replaceAll('/','-')

    def url = new URL("https://api.github.com/repos/${account}/${buildName}/contents/")
    def content = new groovy.json.JsonSlurper().parse(url.newReader())
    content.each {
        if (it.name == "Jenkinsfile")
        job(jobName) {
            scm {
                git("git://github.com/${account}/${buildName}.git")
            }
        }
    }
}