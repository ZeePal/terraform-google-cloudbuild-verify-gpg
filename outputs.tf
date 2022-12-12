output "id" {
  description = "an identifier for the resource with format projects/{{project}}/locations/{{location}}/triggers/{{trigger_id}}"
  value       = google_cloudbuild_trigger.this.id
}

output "trigger_id" {
  description = "The unique identifier for the trigger."
  value       = google_cloudbuild_trigger.this.trigger_id
}

output "create_time" {
  description = "Time when the trigger was created."
  value       = google_cloudbuild_trigger.this.create_time
}
