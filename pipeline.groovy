def account = 'tyler-matheson'
def url = new URL("https://api.github.com/users/${account}/repos")
def repos = new groovy.json.JsonSlurper().parse(url.newReader())
repos.each {
    def buildName = it.name
    def jobName = "${account}_${buildName}".replaceAll('/','-')

    def url2 = new URL("https://api.github.com/repos/${account}/${buildName}/contents/")
    def content = new groovy.json.JsonSlurper().parse(url2.newReader())
    content.each {
        if (it.name == "Jenkinsfile")
        multibranchPipelineJob('jobName') {
            branchSources {
                git {
                    remote("https://github.com/${account}/${buildName}.git")
                }
            }
        }
    }
}