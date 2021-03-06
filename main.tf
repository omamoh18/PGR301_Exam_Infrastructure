resource "google_cloud_run_service" "dbzexampgr301" {
  name = "dbzexampgr301"
  location = "us-central1"
  project = var.project_id

  template {
    spec {
      containers {
        image = "gcr.io/dbzexampgr301/dbzexampgr301@sha256:520b925795d6f03049e49722c1824c7f71212af698faf6cca3b6e91926ece5a3"
        env {
          name = "LOGZ_TOKEN"
          #referring to stored variable.tf file
          value = var.logz_token
        }
        env {
          name = "LOGZ_URL"
          value = var.logz_url
        }
        resources {
          limits = {
            memory = "512Mi"
          }
        }
      }
    }
  }
  traffic {
    percent = 100
    latest_revision = true
  }
}

data "google_iam_policy" "noauth" {
  binding{
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.dbzexampgr301.location
  project = google_cloud_run_service.dbzexampgr301.project
  service = google_cloud_run_service.dbzexampgr301.name
  policy_data = data.google_iam_policy.noauth.policy_data
 }

output "url" {
  value = google_cloud_run_service.dbzexampgr301.status[0].url
}