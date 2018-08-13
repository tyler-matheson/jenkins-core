def project = 'tyler-matheson/builds'
def jobName = "${project}".replaceAll('/','_')

multibranchPipelineJob("${jobName}") {
    branchSources {
        git {
            remote "git://github.com/${project}.git"
        }
    }
    configure { node ->
        (node / 'factory').@class = 'org.jenkinsci.plugins.pipeline.multibranch.defaults.PipelineBranchDefaultsProjectFactory'
        (node / 'factory').@plugin = 'pipeline-multibranch-defaults'

        def traits = node / sources / data / 'jenkins.branch.BranchSource' / source / traits
        traits << 'jenkins.plugins.git.traits.BranchDiscoveryTrait' {}
    }
}