# Cloud Build Trigger with Git GPG Verification
Simple(ish) module to uplift a provided `cloudbuild.yaml` file with an initial `git verify-commit HEAD` step.


## Example Usage
```hcl
module "pipeline" {
  source = "github.com/ZeePal/terraform-google-cloudbuild-verify-gpg"

  source_build_template = yamldecode(file("cloudbuild.yaml"))
  signing_key           = file("signing_key.asc")

  github = {
    owner = "ZeePal"
    name  = "zeepalnet-base"
    push = {
      branch = "^main$"
    }
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [google_cloudbuild_trigger.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github"></a> [github](#input\_github) | (Required) Describes the configuration of a trigger that creates a build whenever a GitHub event is received: https://registry.terraform.io/providers/hashicorp/google/4.45.0/docs/resources/cloudbuild_trigger#nested_github | `any` | n/a | yes |
| <a name="input_signing_key"></a> [signing\_key](#input\_signing\_key) | Allowed Git Signing Key (GPG Ascii Armored), eg: -----BEGIN PGP PUBLIC KEY BLOCK----- | `string` | n/a | yes |
| <a name="input_source_build_template"></a> [source\_build\_template](#input\_source\_build\_template) | cloudbuild.yaml contents to insert git gpg verification into, eg: yamldecode(file('cloudbuild.yaml')) | `any` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | (Optional) Human-readable description of the trigger. | `any` | `null` | no |
| <a name="input_disabled"></a> [disabled](#input\_disabled) | (Optional) Whether the trigger is disabled or not. If true, the trigger will never result in a build. | `any` | `null` | no |
| <a name="input_filter"></a> [filter](#input\_filter) | (Optional) A Common Expression Language string. Used only with Pub/Sub and Webhook. | `any` | `null` | no |
| <a name="input_ignored_files"></a> [ignored\_files](#input\_ignored\_files) | (Optional) ignoredFiles and includedFiles are file glob matches using https://golang.org/pkg/path/filepath/#Match extended with support for **. If ignoredFiles and changed files are both empty, then they are not used to determine whether or not to trigger a build. If ignoredFiles is not empty, then we ignore any files that match any of the ignored\_file globs. If the change has no files that are outside of the ignoredFiles globs, then we do not trigger a build. | `any` | `null` | no |
| <a name="input_include_build_logs"></a> [include\_build\_logs](#input\_include\_build\_logs) | (Optional) Build logs will be sent back to GitHub as part of the checkrun result. Values can be INCLUDE\_BUILD\_LOGS\_UNSPECIFIED or INCLUDE\_BUILD\_LOGS\_WITH\_STATUS Possible values are INCLUDE\_BUILD\_LOGS\_UNSPECIFIED and INCLUDE\_BUILD\_LOGS\_WITH\_STATUS. | `any` | `null` | no |
| <a name="input_included_files"></a> [included\_files](#input\_included\_files) | (Optional) ignoredFiles and includedFiles are file glob matches using https://golang.org/pkg/path/filepath/#Match extended with support for **. If any of the files altered in the commit pass the ignoredFiles filter and includedFiles is empty, then as far as this filter is concerned, we should trigger the build. If any of the files altered in the commit pass the ignoredFiles filter and includedFiles is not empty, then we make sure that at least one of those files matches a includedFiles glob. If not, then we do not trigger a build. | `any` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | (Optional) The Cloud Build location for the trigger. If not specified, 'global' is used. | `any` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Optional) Name of the trigger. Must be unique within the project. | `any` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | (Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used. | `any` | `null` | no |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | (Optional) The service account used for all user-controlled operations including triggers.patch, triggers.run, builds.create, and builds.cancel. If no service account is set, then the standard Cloud Build service account ([PROJECT\_NUM]@system.gserviceaccount.com) will be used instead. Format: projects/{PROJECT\_ID}/serviceAccounts/{ACCOUNT\_ID\_OR\_EMAIL} | `any` | `null` | no |
| <a name="input_substitutions"></a> [substitutions](#input\_substitutions) | (Optional) Substitutions data for Build resource. | `any` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Tags for annotation of a BuildTrigger | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_create_time"></a> [create\_time](#output\_create\_time) | Time when the trigger was created. |
| <a name="output_id"></a> [id](#output\_id) | an identifier for the resource with format projects/{{project}}/locations/{{location}}/triggers/{{trigger\_id}} |
| <a name="output_trigger_id"></a> [trigger\_id](#output\_trigger\_id) | The unique identifier for the trigger. |
<!-- END_TF_DOCS -->
