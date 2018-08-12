def project = 'tyler-matheson/builds'
def branchApi = new URL("https://api.github.com/repos/${project}/branches")
def branches = new groovy.json.JsonSlurper().parse(branchApi.newReader())
branches.each {
    def branchName = it.name
    def jobName = "${project}_${buildName}".replaceAll('/','-')

    def url2 = new URL("https://api.github.com/repos/${project}/contents/")
    def content = new groovy.json.JsonSlurper().parse(url2.newReader())
    content.each {
        if (it.name == "Jenkinsfile"){
            multibranchPipelineJob('jobName') {
                branchSources {
                    git {
                        git("git://github.com/${project}.git", branchName)
                    }
                }
            }
        }
    }
}