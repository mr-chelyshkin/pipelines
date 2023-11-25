## WebHook trigger

WebHook not fully support by terraform, should have manual actions.
```terraform
module "my_module" {
  source = "../aws-codebuild"
  
  credentials = {
    token : "{{ support_only_github_PAT }}"
    useWebHooks: true
  }
  ...
}
```
- Run terraform apply: You got error `Could not find access token for server ...`.  
- Now go to web: `CodeBuild/BuildDetails/Primary source webhook events/Edit`.  
- Change Repository from "Public" to "Repository in my GitHub Account" and select project.
- Run terraform plan, check changes, if everything ok it should return "NO CHANGES".

### PAT Credentials
| Name           | Access     |
|----------------|------------|
| Actions        | Read-only  |
| Administration | Read-only  |
| Contents       | Read-only  |
| Metadata       | Read-only  |
| WebHooks       | Read-only  |
