@{
    "runs-on" = "ubuntu-latest"    
    if = '${{ success() }}'
    steps = @(
        @{
            name = 'Check out repository'
            uses = 'actions/checkout@v3'
        },
        @{
            name = 'GitLogger'
            uses = 'GitLogging/GitLoggerAction@main'
            id = 'GitLogger'
        },
        @{    
            name = 'Use PSSVG Action'
            uses = 'StartAutomating/PSSVG@main'
            id = 'PSSVG'
        },
        'RunPipeScript',
        'RunEZOut',
        @{
            name = 'Use GitPub Action'
            uses = 'StartAutomating/GitPub@main'
            id  = 'GitPub'
            with = @{                
                PublishParameters = @'
{
    "Get-GitPubIssue": {
        "Repository": '${{github.repository}}'        
    },
    "Get-GitPubRelease": {
        "Repository": '${{github.repository}}'        
    },
    "Publish-GitPubJekyll": {
        "OutputPath": "docs/_posts"
    }
}
'@                    
            }
        },
        @{
            name = 'Run ShowDemo (on branch)'
            if   = '${{github.ref_name != ''main''}}'
            uses = './'
            id = 'ShowDemo'
        },
        'RunHelpOut',
        @{
            name = 'PSA'
            uses = 'StartAutomating/PSA@main'
            id = 'PSA'
        }
        @{
            'name'='Log in to the Container registry'
            'uses'='docker/login-action@master'
            'with'=@{
                'registry'='${{ env.REGISTRY }}'
                'username'='${{ github.actor }}'
                'password'='${{ secrets.GITHUB_TOKEN }}'
            }
        },
        @{
            name = 'Switch to latest branch (if on main)'
            if   = '${{github.ref_name == ''main'' || github.ref_name == ''master''}}'
            run  = 'git checkout -b latest'
        },
        @{
            'name'='Extract metadata (tags, labels) for Docker'
            'id'='meta'
            'uses'='docker/metadata-action@master'
            'with'=@{
                'images'='${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}'
            }
        },
        @{
            name = 'Build and push Docker image (from branch)'
            uses = 'docker/build-push-action@master'
            with = @{
                'context'='.'
                'push'='true'
                'tags'='${{ steps.meta.outputs.tags }}'
                'labels'='${{ steps.meta.outputs.labels }}'
            }
        }
    )
}