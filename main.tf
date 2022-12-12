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
      owner = lookup(github, "owner", null)
      name  = lookup(github, "name", null)

      dynamic "pull_request" {
        for_each = lookup(github, "pull_request", null) != null ? [github["pull_request"]] : []
        content {
          branch          = lookup(pull_request, "branch", null)
          comment_control = lookup(pull_request, "comment_control", null)
          invert_regex    = lookup(pull_request, "invert_regex", null)
        }
      }

      dynamic "push" {
        for_each = lookup(github, "push", null) != null ? [github["push"]] : []
        content {
          invert_regex = lookup(push, "invert_regex", null)
          branch       = lookup(push, "branch", null)
          tag          = lookup(push, "tag", null)
        }
      }
    }
  }

  # Basic mapping from the modified local.build_template from var.source_build_template to terraform blocks
  build {
    dynamic "step" {
      for_each = lookup(local.build_template, "steps", [])
      content {
        name       = lookup(step, "name", null)
        args       = lookup(step, "args", null)
        env        = lookup(step, "env", null)
        dir        = lookup(step, "dir", null)
        entrypoint = lookup(step, "entrypoint", null)
        id         = lookup(step, "id", null)
        script     = lookup(step, "script", null)
        secret_env = lookup(step, "secretEnv", null)
        timeout    = lookup(step, "timeout", null)

        dynamic "volumes" {
          for_each = lookup(step, "volumes", [])
          content {

            name = lookup(volumes, "name", null)
            path = lookup(volumes, "path", null)
          }
        }

        wait_for = lookup(step, "waitFor", null)
      }
    }

    dynamic "artifacts" {
      for_each = lookup(local.build_template, "artifacts", [])
      content {
        images = lookup(artifacts, "images", null)

        dynamic "objects" {
          for_each = lookup(artifacts, "objects", [])
          content {
            location = lookup(objects, "location", null)
            paths    = lookup(objects, "paths", null)
          }
        }
      }
    }

    dynamic "available_secrets" {
      for_each = lookup(local.build_template, "availableSecrets", [])
      content {
        secret_manager {
          env          = lookup(available_secrets["secretManager"], "env", null)
          version_name = lookup(available_secrets["secretManager"], "versionName", null)
        }
      }
    }

    images      = lookup(local.build_template, "images", null)
    logs_bucket = lookup(local.build_template, "logs_bucket", null)

    dynamic "options" {
      for_each = lookup(local.build_template, "options", [])
      content {
        disk_size_gb            = lookup(options, "diskSizeGb", null)
        dynamic_substitutions   = lookup(options, "dynamicSubstitutions", null)
        env                     = lookup(options, "env", null)
        log_streaming_option    = lookup(options, "logStreamingOption", null)
        logging                 = lookup(options, "logging", null)
        machine_type            = lookup(options, "machineType", null)
        requested_verify_option = lookup(options, "requestedVerifyOption", null)
        secret_env              = lookup(options, "secretEnv", null)
        source_provenance_hash  = lookup(options, "sourceProvenanceHash", null)
        substitution_option     = lookup(options, "substitutionOption", null)

        dynamic "volumes" {
          for_each = lookup(options, "volumes", [])
          content {

            name = lookup(volumes, "name", null)
            path = lookup(volumes, "path", null)
          }
        }

        worker_pool = lookup(options, "workerPool", null)
      }
    }

    queue_ttl = lookup(local.build_template, "queueTtl", null)

    dynamic "secret" {
      for_each = lookup(local.build_template, "secrets", [])
      content {
        kms_key_name = lookup(secret, "kmsKeyName", null)
        secret_env   = lookup(secret, "secretEnv", null)
      }
    }

    dynamic "source" {
      for_each = lookup(local.build_template, "source", [])
      content {
        dynamic "repo_source" {
          for_each = lookup(source, "repoSource", [])
          content {
            repo_name     = lookup(repo_source, "repoName", null)
            branch_name   = lookup(repo_source, "branchName", null)
            commit_sha    = lookup(repo_source, "commitSha", null)
            dir           = lookup(repo_source, "dir", null)
            invert_regex  = lookup(repo_source, "invertRegex", null)
            project_id    = lookup(repo_source, "projectId", null)
            substitutions = lookup(repo_source, "substitutions", null)
            tag_name      = lookup(repo_source, "tagName", null)
          }
        }

        dynamic "storage_source" {
          for_each = lookup(source, "storageSource", [])
          content {
            bucket     = lookup(storage_source, "bucket", null)
            object     = lookup(storage_source, "object", null)
            generation = lookup(storage_source, "generation", null)
          }
        }
      }
    }

    substitutions = lookup(local.build_template, "substitutions", null)
    tags          = lookup(local.build_template, "tags", null)
    timeout       = lookup(local.build_template, "timeout", null)
  }
}
