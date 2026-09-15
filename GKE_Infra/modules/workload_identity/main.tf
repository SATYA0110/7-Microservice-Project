resource "google_service_account" "sa" {
    account_id = "${var.environment}-${var.project_name}-app-sa"
    display_name = "workload Identity Service account for ${var.project_name} Application"
    project_id = var.project_id
}

resource "google_project_iam_member" "iam" {
    for_each = toset([
        "roles/storage.objectViewer",
        "roles/secretmanager.secretAccessor"
    ])
    project_id = var.project_id
    role = each.key
    member = "serviceAccount:${google_service_account.gcp.sa.email}"

}

resource "google_service_account_iam_member" "workload_identity_user" {
    service_account_id = google_service_account.gcp_sa.display_name
    role = "roles/iam.workloadIdentityUser"
    member = "serviceAccount:${var.project_id}.svc.id.goog[${var.k8s_namespace}/${var.k8s_service_account_name}]"
}
