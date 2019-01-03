
Properties {

    $ModuleNames    = 'VMwareFever'

    $GalleryEnabled = $true
    $GalleryKey     = Use-VaultSecureString -TargetName 'PowerShell Gallery Key (claudiospizzi)'

    $GitHubEnabled  = $true
    $GitHubRepoName = 'claudiospizzi/VMwareFever'
    $GitHubKey      = Use-VaultSecureString -TargetName 'GitHub Token (claudiospizzi)'
}
