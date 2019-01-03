
Properties {

    $ModuleNames    = 'VMwareFever'

    $GalleryEnabled = $true
    $GalleryKey     = Use-VaultSecureString -TargetName 'PowerShell Gallery Key (claudiospizzi)'

    $GitHubEnabled  = $true
    $GitHubRepoName = 'claudiospizzi/VMwareFever'
    $GitHubToken    = Use-VaultSecureString -TargetName 'GitHub Token (claudiospizzi)'
}
