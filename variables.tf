variable "source_build_template" {
  description = "cloudbuild.yaml contents to insert git gpg verification into, eg: yamldecode(file('cloudbuild.yaml'))"
}

variable "signing_key" {
  description = "Allowed Git Signing Key (GPG Ascii Armored), eg: -----BEGIN PGP PUBLIC KEY BLOCK-----"
  type        = string
}

# Pass through vars for google_cloudbuild_trigger: https://registry.terraform.io/providers/hashicorp/google/4.45.0/docs/resources/cloudbuild_trigger
variable "github" {
  description = "(Required) Describes the configuration of a trigger that creates a build whenever a GitHub event is received: https://registry.terraform.io/providers/hashicorp/google/4.45.0/docs/resources/cloudbuild_trigger#nested_github"
}

variable "name" {
  description = "(Optional) Name of the trigger. Must be unique within the project."
  default     = null
}
variable "description" {
  description = "(Optional) Human-readable description of the trigger."
  default     = null
}

variable "location" {
  description = "(Optional) The Cloud Build location for the trigger. If not specified, 'global' is used."
  default     = null
}
variable "project" {
  description = "(Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  default     = null
}

variable "ignored_files" {
  description = "(Optional) ignoredFiles and includedFiles are file glob matches using https://golang.org/pkg/path/filepath/#Match extended with support for **. If ignoredFiles and changed files are both empty, then they are not used to determine whether or not to trigger a build. If ignoredFiles is not empty, then we ignore any files that match any of the ignored_file globs. If the change has no files that are outside of the ignoredFiles globs, then we do not trigger a build."
  default     = null
}
variable "included_files" {
  description = "(Optional) ignoredFiles and includedFiles are file glob matches using https://golang.org/pkg/path/filepath/#Match extended with support for **. If any of the files altered in the commit pass the ignoredFiles filter and includedFiles is empty, then as far as this filter is concerned, we should trigger the build. If any of the files altered in the commit pass the ignoredFiles filter and includedFiles is not empty, then we make sure that at least one of those files matches a includedFiles glob. If not, then we do not trigger a build."
  default     = null
}


variable "tags" {
  description = "(Optional) Tags for annotation of a BuildTrigger"
  default     = null
}
variable "disabled" {
  description = "(Optional) Whether the trigger is disabled or not. If true, the trigger will never result in a build."
  default     = null
}
variable "substitutions" {
  description = "(Optional) Substitutions data for Build resource."
  default     = null
}
variable "service_account" {
  description = "(Optional) The service account used for all user-controlled operations including triggers.patch, triggers.run, builds.create, and builds.cancel. If no service account is set, then the standard Cloud Build service account ([PROJECT_NUM]@system.gserviceaccount.com) will be used instead. Format: projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT_ID_OR_EMAIL}"
  default     = null
}
variable "include_build_logs" {
  description = "(Optional) Build logs will be sent back to GitHub as part of the checkrun result. Values can be INCLUDE_BUILD_LOGS_UNSPECIFIED or INCLUDE_BUILD_LOGS_WITH_STATUS Possible values are INCLUDE_BUILD_LOGS_UNSPECIFIED and INCLUDE_BUILD_LOGS_WITH_STATUS."
  default     = null
}
variable "filter" {
  description = "(Optional) A Common Expression Language string. Used only with Pub/Sub and Webhook."
  default     = null
}
