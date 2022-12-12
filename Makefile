.PHONY: docs
docs:
	docker run --rm --volume "$(shell pwd):/PWD" -u "$(shell id -u)" \
		quay.io/terraform-docs/terraform-docs:0.16.0 /PWD
