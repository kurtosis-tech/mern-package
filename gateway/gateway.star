nginx = import_module("github.com/kurtosis-tech/nginx-package/main.star")

NGINX_SERVICE_NAME = "nginx"
NGINX_PORT_NUMBER = 80
NGINX_ROOT_DIRPATH = "/var/www/html"
NGINX_PORT_ID = "http"
NGINX_IMAGE_NAME = "nginx:latest"

def run(plan, frontend_service, backend_service):

    nginx_templates = plan.upload_files(
        src="./templates",
        name="nginx-templates",
    )

    file_artifacts = {
        "/etc/nginx/templates": nginx_templates,
    }

    env_vars = {
        "NGINX_PORT_NUMBER": "{}".format(NGINX_PORT_NUMBER),
        "NGINX_ROOT_FOLDER": NGINX_ROOT_DIRPATH,
        "FRONTEND_HOST": frontend_service.hostname,
        "FRONTEND_PORT": "{}".format(frontend_service.ports['http'].number),
        "BACKEND_HOST": backend_service.hostname,
        "BACKEND_PORT": "{}".format(backend_service.ports['http'].number),
    }

    nginx_args = {
        "name":NGINX_SERVICE_NAME,
        "image":NGINX_IMAGE_NAME,
        "file_artifacts":file_artifacts,
        "port_id":NGINX_PORT_ID,
        "port_number":NGINX_PORT_NUMBER,
        "env_vars":env_vars,
    }

    nginx.run(
        plan,
        args= nginx_args,
    )
