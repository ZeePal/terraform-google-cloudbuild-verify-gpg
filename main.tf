# Just pass through variables to the resource except for the "build" block at the end which is the modified local.build_template
resource "google_cloudbuild_trigger" "this" {
  name        = var.name
  description = var.description

  location = var.location
  project  = var.project

  ignored_files  = var.ignored_files
  included_files = var.included_files

  tags               = var.tags
  disabled           = var.disabled
  substitutions      = var.substitutions
  service_account    = var.service_account
  include_build_logs = var.include_build_logs
  filter             = var.filter

  dynamic "github" {
    for_each = var.github != null ? [var.github] : []
    content {
      owner = lookup(github.value, "owner", null)
      name  = lookup(github.value, "name", null)

      dynamic "pull_request" {
        for_each = lookup(github.value, "pull_request", null) != null ? [github.value["pull_request"]] : []
        content {
          branch          = lookup(pull_request.value, "branch", null)
          comment_control = lookup(pull_request.value, "comment_control", null)
          invert_regex    = lookup(pull_request.value, "invert_regex", null)
        }
      }

      dynamic "push" {
        for_each = lookup(github.value, "push", null) != null ? [github.value["push"]] : []
        content {
          invert_regex = lookup(push.value, "invert_regex", null)
          branch       = lookup(push.value, "branch", null)
          tag          = lookup(push.value, "tag", null)
        }
      }
    }
  }

  # Basic mapping from the modified local.build_template from var.source_build_template to terraform blocks
  build {
    dynamic "step" {
      for_each = lookup(local.build_template, "steps", [])
      content {
        name       = lookup(step.value, "name", null)
        args       = lookup(step.value, "args", null)
        env        = lookup(step.value, "env", null)
        dir        = lookup(step.value, "dir", null)
        entrypoint = lookup(step.value, "entrypoint", null)
        id         = lookup(step.value, "id", null)
        script     = lookup(step.value, "script", null)
        secret_env = lookup(step.value, "secretEnv", null)
        timeout    = lookup(step.value, "timeout", null)

        dynamic "volumes" {
          for_each = lookup(step.value, "volumes", [])
          content {

            name = lookup(volumes.value, "name", null)
            path = lookup(volumes.value, "path", null)
          }
        }

        wait_for = lookup(step.value, "waitFor", null)
      }
    }

    dynamic "artifacts" {
      for_each = lookup(local.build_template, "artifacts", [])
      content {
        images = lookup(artifacts.value, "images", null)

        dynamic "objects" {
          for_each = lookup(artifacts.value, "objects", [])
          content {
            location = lookup(objects.value, "location", null)
            paths    = lookup(objects.value, "paths", null)
          }
        }
      }
    }

    dynamic "available_secrets" {
      for_each = lookup(local.build_template, "availableSecrets", [])
      content {
        secret_manager {
          env          = lookup(available_secrets.value["secretManager"], "env", null)
          version_name = lookup(available_secrets.value["secretManager"], "versionName", null)
        }
      }
    }

    images      = lookup(local.build_template, "images", null)
    logs_bucket = lookup(local.build_template, "logs_bucket", null)

    dynamic "options" {
      for_each = lookup(local.build_template, "options", [])
      content {
        disk_size_gb            = lookup(options.value, "diskSizeGb", null)
        dynamic_substitutions   = lookup(options.value, "dynamicSubstitutions", null)
        env                     = lookup(options.value, "env", null)
        log_streaming_option    = lookup(options.value, "logStreamingOption", null)
        logging                 = lookup(options.value, "logging", null)
        machine_type            = lookup(options.value, "machineType", null)
        requested_verify_option = lookup(options.value, "requestedVerifyOption", null)
        secret_env              = lookup(options.value, "secretEnv", null)
        source_provenance_hash  = lookup(options.value, "sourceProvenanceHash", null)
        substitution_option     = lookup(options.value, "substitutionOption", null)

        dynamic "volumes" {
          for_each = lookup(options.value, "volumes", [])
          content {

            name = lookup(volumes.value, "name", null)
            path = lookup(volumes.value, "path", null)
          }
        }

        worker_pool = lookup(options.value, "workerPool", null)
      }
    }

    queue_ttl = lookup(local.build_template, "queueTtl", null)

    dynamic "secret" {
      for_each = lookup(local.build_template, "secrets", [])
      content {
        kms_key_name = lookup(secret.value, "kmsKeyName", null)
        secret_env   = lookup(secret.value, "secretEnv", null)
      }
    }

    dynamic "source" {
      for_each = lookup(local.build_template, "source", [])
      content {
        dynamic "repo_source" {
          for_each = lookup(source.value, "repoSource", [])
          content {
            repo_name     = lookup(repo_source.value, "repoName", null)
            branch_name   = lookup(repo_source.value, "branchName", null)
            commit_sha    = lookup(repo_source.value, "commitSha", null)
            dir           = lookup(repo_source.value, "dir", null)
            invert_regex  = lookup(repo_source.value, "invertRegex", null)
            project_id    = lookup(repo_source.value, "projectId", null)
            substitutions = lookup(repo_source.value, "substitutions", null)
            tag_name      = lookup(repo_source.value, "tagName", null)
          }
        }

        dynamic "storage_source" {
          for_each = lookup(source.value, "storageSource", [])
          content {
            bucket     = lookup(storage_source.value, "bucket", null)
            object     = lookup(storage_source.value, "object", null)
            generation = lookup(storage_source.value, "generation", null)
          }
        }
      }
    }

    substitutions = lookup(local.build_template, "substitutions", null)
    tags          = lookup(local.build_template, "tags", null)
    timeout       = lookup(local.build_template, "timeout", null)
  }
}
