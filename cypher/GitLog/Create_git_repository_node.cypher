// Create git repository information node

MERGE (git_repository:Git:Repository {
    name:             $git_repository_origin, 
    tags:             split($git_repository_current_tags, ','),
    branch:           coalesce($git_repository_current_branch, ''),
    commit:           coalesce($git_repository_current_commit, ''),
    fileName:         $git_repository_directory_name,
    absoluteFileName: $git_repository_absolute_directory_name
})