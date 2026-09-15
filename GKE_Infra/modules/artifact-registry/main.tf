resource "google_artifact_registry_repository" "docker_repo" {
    project = var.project_id
    location = var.region
    repository_id = "${var.environment}-${var.project}-docker_repo"
    description   = "Production Docker container registry for ${var.project_name} application images."
    format        = "DOCKER"
    mode = "STANDARD_REPOSITORY"

    cleanup_policies {
    id     = "delete-untagged-images"
    action = "DELETE"
    condition {
      tag_state = "UNTAGGED"
    }
  }

  cleanup_policies {
    id     = "keep-last-10-tagged-versions"
    action = "KEEP"
    condition {
      tag_state             = "TAGGED"
      tag_prefixes          = ["v", "release-"] # Matches standard semver or release prefixes
      newer_than            = "30d"             # Keep images if they are less than 30 days old
      packageName_prefixes  = []
    }
  }

  depends_on = [google_project_service.artifact_registry]
}