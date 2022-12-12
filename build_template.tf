locals {
  script_git_gpg_verify = <<EOS
#!/usr/bin/env bash
set -euo pipefail

gpg --import <(cat <<!
${var.signing_key}
!
)
git verify-commit HEAD
EOS

  build_template = merge( # Start with source_build as a base & replace "steps"
    var.source_build_template,
    {
      steps = concat( # Replace "steps"
        [
          { # Insert at the very beginning the 'git verify-commit HEAD' script
            id     = "git-gpg-verify"
            name   = "gcr.io/cloud-builders/git"
            script = local.script_git_gpg_verify
          }
        ],
        [ # Append all source_build steps
          for step in lookup(var.source_build_template, "steps", []) :
          merge( # Replace "waitFor" (if it exists)
            step,
            lookup(step, "waitFor", null) == null ? {} : {
              waitFor = [
                for wait_for in lookup(step, "waitFor", []) :
                # if element of "waitFor" is "-" then it means run at start of the cloud build trigger,
                # adjust it to instead wait for gpg verification first
                wait_for == "-" ? "git-gpg-verify" : wait_for
              ]
            }
          )
        ]
      )
    }
  )
}
