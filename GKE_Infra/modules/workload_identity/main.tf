resource "google_service_account" "sa" {
  account_id   = "${var.environment}-${var.project_name}-app-sa"
  display_name = "workload Identity Service account for ${var.project_name} Application"
  project      = var.project_id
}

resource "google_project_iam_member" "iam" {
  for_each = toset([
    "roles/storage.objectViewer",
    "roles/secretmanager.secretAccessor"
  ])
  project = var.project_id # Fixed: Argument name is 'project', not 'project_id'
  role    = each.key
  member  = "serviceAccount:${google_service_account.sa.email}" # Fixed: Corrected resource name reference
}

resource "google_service_account_iam_member" "workload_identity_user" {
  service_account_id = google_service_account.sa.name # Fixed: Changed gcp_sa to sa, and display_name to name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${var.k8s_namespace}/${var.k8s_service_account_name}]"
}
